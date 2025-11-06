#!/bin/bash

declare -a HELM_ARGS

usage() {
    echo "Usage: $0 [install|diff|update|uninstall] -c|--config <path to YAML config file>"
    exit 1
}

load_config () {
    local script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
    local config_file=""

    if [[ $# -eq 0 ]]; then
        echo "Error: Configuration file is required."
        usage
        exit 1
    fi

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -c|--config)
		config_file="$2"
                shift
                ;;
            *)
                shift
                ;;
        esac
    done

    if [[ "$config_file" = "" || ! -f "$config_file" ]]; then
        echo "Error: Configuration file is required."
        usage
        exit 1
    fi

    # Load parameters from YAML file
    HELM_ARGS+=($(yq e '.release' "$config_file"))
    HELM_ARGS+=($(yq e '.chart' "$config_file"))
    HELM_ARGS+=(--version $(yq e '.version' "$config_file"))
    HELM_ARGS+=(--namespace $(yq e '.namespace' "$config_file"))

    while IFS= read -r val_file; do
        if [ -n "$val_file" ]; then
            HELM_ARGS+=(--values "$val_file")
        fi
    done < <(yq e '.values_files[]?' "$config_file")
}

install() {
    echo "Installing package: ${HELM_ARGS[0]}"
    helm upgrade --install "${HELM_ARGS[@]}" \
        --create-namespace
}

diff() {
    echo "Preview changes on package: ${HELM_ARGS[0]}"
    helm diff upgrade "${HELM_ARGS[@]}" \
        -C 4 --three-way-merge
}

uninstall() {
    echo "Removing package: ${HELM_ARGS[0]}"
    helm uninstall "${HELM_ARGS[0]}" -n "${HELM_ARGS[5]}"
#        --cascade foreground
}

### Main script logic
if ! command -v yq &> /dev/null; then
    echo "Error: yq is not installed. Please install it to run this script." >&2
    exit 1
fi

echo "yq found. Continuing with the script..."
yq --version

if [[ $# -eq 0 ]]; then
    usage
fi

COMMAND="$1"
case "$COMMAND" in
    diff)
        load_config "$@"
        diff
        ;;
    install)
        load_config "$@"
        install
        ;;
    uninstall)
        load_config "$@"
        uninstall
        ;;
    update)
        load_config "$@"
        diff
        read -p "Do you want to apply the changes? [y/n]: " choice
        case $choice in
            y) install ;;
        esac
        ;;
    help)
        usage
        ;;
    *)
        echo "Error: Unknown command '$COMMAND'" >&2
        usage
        ;;
esac

