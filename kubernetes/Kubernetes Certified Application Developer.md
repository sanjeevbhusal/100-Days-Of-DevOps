
# Node Concept

As we know Kubernetes is used to run multiple replicas of a container across various machines. These machines are called as nodes. 

Theoretically, we could just have a single host in the entire kubernetes cluster and use that host to run containers. Such architecture is said to be a single-node cluster.

But having a single-node cluster is not a good idea. If the node goes down, our application fails. The self-healing functionality of Kubernetes will be of no use as kubernetes donot have any other nodes to start the replacement container. So, having multi-node cluster gives high availability as well as load balancing. But having multiple nodes arises a question. 

**How do we manage all these nodes? How do we know if a node went down?**

This is when we need another node that acts as a manager for other nodes. This manager node will be responsible for managing all other nodes and containers running on those nodes. 

Now, there are 2 kind of nodes in kubernetes with completely different purpose. Hence both nodes should be named differently that reflects their purpose. Kubernetes names Manager Node as **Master Node** and other nodes as **Worker Node**. 

This concept of having master and worker nodes arises few questions. Lets see those questions and answers.

**1. Can Master Node also act as Worker Node?**
   Yes, Master Node can also act as Worker Node. However this is not recommended by kubernetes.
   
**2. Can I have Multiple Master Nodes in the cluster?**
   Yes, you can have multiple master nodes in the cluster. This is recommended by kubernetes. If you lose access to your master nodes, you effectively lose access to your entire cluster. So, its better to have multiple master nodes. 

As worker nodes are used to run containers and not have managing task, they dont need functionality related to managing nodes. As master nodes are used to manage other containers and not run containers (although they can), they might not need all the functionality as worker nodes.

This is the reason why kubernetes has multiple components architecture. All these components work together to perform all the functionality that made kubernetes so powerful. This means installing kubernetes is not like any other applications. We need to install different components based on if we want the node to act as worker node or manager node. Lets learn more on Kubernetes Architecture.
  

# Kubernetes Architecuture

Kubernetes is composed of multiple components. Some of the major components are API Server, Kubelet Service, etcd database, container runtime, schedulers and controllers. Here is the brief description of tsudo install minikube-linux-amd64 /usr/local/bin/minikubehese components.

- API server: It acts as a frontend for interacting with Kubernetes. All web applications, command line interface etc all communicate with API server to access kubernetes. however
- Kubelet service: It is a agent that runs in the worker nodes. It is responsible to run containers on the worker node (when assigned by master node) and communicate their health information with master node.
- etcd database: This database stores all the information about all the nodes and containers in the cluster. This is a distributed database i.e. its data is replicated across all the nodes in the cluster. Even if one node fails, the data is still secure. 
- Container Runtime: This is used to run containers. Some of the container runtime are docker, Crio, etc
- Schedulers: Schedulers schedule new containers to run to multiple worker nodes.
- Controller: Controller are brain of kubernetes. They are responsible for making sure everything is working properly. In case they detect some problem, they take appropriate steps to resolve a problem. 

We will dive deeper into all these components in later sections. 

Now, lets understand another critical part of kubernetes called kubectl. Kubectl is not a core part of kubernetes functioning but is the most famous tool used to interact with kubernetes. So, its important to understand it.

## Kubectl

Kubectl is a command line utility that is used to interact with Kubernetes API server, one of the kubernetes components discussed above. While it is technically possible to directly interact with API server, it is recommended to use kubectl. Using kubectl instead of API server directly arises a question.

**Why not directly use API server instead of Kubectl?**

The main reason to use kubectl is its ease of use and consistenct interface. 

- Ease of Use: Users dont need to know about the underlying API endpoints of API server to interact with it. 
- Consistent Interface: API Server Endpoints might change according to different kubernetes version but kubectl interface will remain the same.  

# Pods

In kubernetes, we dont deploy container directly in the worker nodes. We wrap containers in a object known as pods. Pods are the smallest object you can create in kubernetes. Just like a container wraps your application, pod wraps a container. Deploying pods instead of containers raises a quesion.

**Why do we need Pods? Why not just deploy container directly?**

Lets keep kuberenetes out of the discussion and just focus on docker containers. We will use an example to understand why deploying pods is better than deploying containers.

Lets say we want to deploy a python application inside a docker container. We will use a Image called `python-app`. We can easily deploy a python application using `docker run python-app`. Lets say we get a lot of traffic and decide to create 5 replicas of the container for load balancing. We can easily do it by running the same command 4 times. 

Overtime our application goes architectural changes and now we also need to create a new helper container for each of the 5 containers. The helper container will use a image called `helper`. We wil have to do number of steps to make this work. The steps we have to perform are: 

- Deploy 5 helper containers by running this command 5 times. `docker run helper` 
- Create 5 different custom networks.
- Assign each  `python-app` container with one of the custom network. 
- Assign each worker container with one of the custom network.  

The final result is 5 different networks and each network having one python-app container and one helper container. This will allow python-app container and worker container to communicate with each other. 

Now what if both containers need to share some Volume? Python-app container might write to a file that has to be accessed by worker container







Now, each python container can communicate with one helper container. 

we link them together, configure networking so python-app container 1 can communicate with helper container 1. We also need to share volumes between python-app container 1 and helper container 1. If python-app-container one is removed, we also need to remove helper container 1.

In case of kubernetes, we would wrap both python-app container and helper container inside a pod and deploy 5 replicas of the pod. Kubernetes will take care of managing shared storage between the containers in a pod. Kubernetes will also keep all containers in a pod in the same network. So, containers can communicate with each other by using localhost as URL as both share the same pod. When one container goes down, kubernets will also destroy other containers in the same pod.This way, we donot have to manage multiple containers ourself.

The dowside is even if we only want to deploy a single container, we have to deploy it inside a pod. Thats just how Kubernetes works.

**What if instead of creating a new pod, we deploy new containers in existing pod?**

Lets say you have a pod containing python application. After some time, you want to deploy a new containers of the same application for high-availability and load balancing requirements.

You have 2 options.

- You could either deploy a new pod in the same worker Node or in other worker Node inside your cluster.
- You could deploy a new container inside the existing pod. Now, the pod consists of 2 python application containers.

It is recommended that you use the first approach to scale your application. Although, it is possible to add a new container inside the existing pod, it goes against the principle of contanerization which states that a container should contain only minimal application/services that can be scaled independently.

When you add a new instance of the application to an existing pod, you are effectively creating a monolithic service, which can make it difficult to manage and scale the application. This also increases the risk of downtime, as any issues with one application can affect all applications in the pod.

Your application container and pod ususally have a 1:1 relationship i.e. 1 pod only has 1 application container.
