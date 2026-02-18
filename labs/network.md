# Network Engineering Lab

## Table of Contents
- [Kubernetes Networking](#kubernetes-networking)

## Kubernetes Networking
[Kubernetes](../README.md#kubernetes) is a platform that automates the deployment, scaling, and management of containerized applications. To understand how Kubernetes ensures containers run efficiently and reliably across a cluster of machines, we need to know components of Kubernetes and how they communcate.

![kube-arch](../images/kind/kube-arch.png)

### Components

#### Pod

#### Service
Kubernetes services define how to expose applications running on pods, with 3 main types: **ClusterIP** (internal), **NodePort** (external port), and **LoadBalancer** (cloud provider load balancer). These types determine network accessibility, with ClusterIP as default and LoadBalancer typically used for public-facing production apps. 

Here is a breakdown of the Kubernetes service types:

- **ClusterIP (Default)**
  - The default type, providing a stable internal IP address reachable only within the cluster for internal load balancing. It acts as an internal load balancer, balancing traffic across backend pods.
  - **Use Case:** Internal microservices communication (e.g., frontend-to-backend), database connections, or components that should not be exposed to the public internet.

- **NodePort**
  - A service type, exposing the service on a specific port (usually 30000–32767) on every node's IP to allow traffic form outside the cluster via `<NodeIP>:<NodePort>`. It also automatically creates a ClusterIP, to which it routes, so when a traffic is received on the node, then forwarded to the service's ClusterIP.
  - **Use Case:** Development, testing, scenarios requiring direct Node access without a cloud load balancer, or small-scale apps needing quick external access (not recommended in production).

- **LoadBalancer**
  - A recommended service type for external-facing service leveraging cloud provider load balancers (Layer 4). It automatically creates a NodePort and a ClusterIP, serving as an extension of both, to route traffic directly to pods.
  - **Use Case:** Production applications needing high availability and automatic, public/internet-facing load balancing.

Other service types:
- **ExternalName**
  - A service type, providing maps the a service to a DNS name using a CNAME record. This is commonly used to create a service within Kubernetes to represent an external DNS endpoint (e.g., an external database or API).
  - **Use Case:** Accessing external services (e.g., an external database) rather than pods or during application migration. 

- **Headless Service**
  - A type of ClusterIP that skips assigning a single stable IP, instead returning the IP addresses of all backend pods via DNS.
  - **Use Case:** Stateful applications (e.g., databases) needing direct, client-side load balancing or pod-to-pod discovery without load balancing. Useful for databases or StatefulSets. 

```mermaid
graph TD
    subgraph Client
        User(User)
        ClusterDNS(Internal DNS)
        ExternalSource(External Service)
    end

    subgraph Kubernetes Cluster
        direction LR
        subgraph Services
            C_IP("Service\n(ClusterIP)")
            N_Port("Service\n(NodePort)")
            L_B("Service\n(LoadBalancer)")
            E_Name("Service\n(ExternalName)")
            H_less("Service\n(Headless)")
        end

        subgraph Nodes
            direction TD
            Node1[Node 1]
            Node2[Node 2]
        end

        subgraph Pods
            PodA[Pod A]
            PodB[Pod B]
            PodC[Pod C]
        end

        %% Connections within the cluster
        C_IP -- "Internal IP" --> PodA
        C_IP -- "Internal IP" --> PodB

        N_Port -- "Node IP:NodePort" --> PodA
        N_Port -- "Node IP:NodePort" --> PodB

        L_B -- "External IP:Port" --> PodA
        L_B -- "External IP:Port" --> PodB

        H_less -- "Direct DNS Lookup" --> PodC

        %% Traffic flow from clients
        User -- "Internal Access" --> C_IP
        User -- "Node IP:NodePort" --> N_Port

        ExternalSource -- "External Load Balancer IP" --> L_B

        ClusterDNS -- "CNAME" --> ExternalSource
        E_Name -- "Returns CNAME to" --> ClusterDNS

        %% Pod connections
        PodA -.-> PodB
        PodC -.-> PodA
    end

    %% Styles for clarity
    classDef internal fill:#f9f,stroke:#333,stroke-width:2px;
    class C_IP,H_less internal;
    classDef external fill:#ccf,stroke:#333,stroke-width:2px;
    class N_Port,L_B,E_Name external;
    classDef component fill:#ffc,stroke:#333,stroke-width:1px;
    class PodA,PodB,PodC,Node1,Node2,User,ClusterDNS,ExternalSource component;
```

#### DNS
Cluster DNS is a DNS server, in addition to the other DNS server(s) in your environment, which serves DNS records for Kubernetes services. Containers started by Kubernetes automatically include this DNS server in their DNS searches

#### Ingress
While not a "service type" itself, Ingress is an API object that acts as a smart router (HTTP/HTTPS) in front of ClusterIP services, often providing cost-effective traffic management, such as TLS termination.

# Additional Resources
## Kubernetes Networking
- [Cluster Networking | Kubernetes](https://kubernetes.io/docs/concepts/cluster-administration/networking/)
- [Services, Load Balancing, and Networking | Kubernetes](https://kubernetes.io/docs/concepts/services-networking/)
- [Connecting Applications with Services | Kubernetes](https://kubernetes.io/docs/tutorials/services/connect-applications-service/)
- [Enhancing DevOps Efficiency on Amazon EKS with Devtron](https://aws.amazon.com/blogs/apn/enhancing-devops-efficiency-on-amazon-eks-with-devtron/)

