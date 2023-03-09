
## Node Concept
---

### Introduction to Node

As we know Kubernetes is used to run multiple replicas of a container across various machines. These machines are called as nodes. 

Theoretically, we could just have a single host in the entire kubernetes cluster and use that host to run containers. Such architecture is said to be a single-node cluster.

But having a single-node cluster is not a good idea. If the node goes down, our application fails. The self-healing functionality of Kubernetes will be of no use as kubernetes do not have any other nodes to start the replacement container. So, having multi-node cluster gives high availability as well as load balancing.  



### How do we manage all these nodes? How do we know if a node went down?

This is when we need another node that acts as a manager for other nodes. This manager node will be responsible for managing all other nodes and containers running on those nodes. 
Now, there are 2 kind of nodes in kubernetes with completely different purpose. Hence both nodes should be named differently that reflects their purpose. Kubernetes names Manager Node as **Master Node** and other nodes as **Worker Node**. 

This concept of having master and worker nodes arises few questions. Lets see those questions and answers.


### Question 1: Can Master Node also act as Worker Node?

Yes, Master Node can also act as Worker Node. However this is not recommended by kubernetes.
   

### Question 2: Can I have Multiple Master Nodes in the cluster?

Yes, you can have multiple master nodes in the cluster. This is recommended by kubernetes. If you lose access to your master nodes, you effectively lose access to your entire cluster. So, its better to have multiple master nodes. 


### Multiple Component Architecture

As worker nodes are used to run containers and not have managing task, they don't need functionality related to managing nodes. As master nodes are used to manage other containers and not run containers (although they can), they might not need all the functionality as worker nodes.

This is the reason why kubernetes has multiple components architecture. All these components work together to perform all the functionality that made kubernetes so powerful. This means installing kubernetes is not like any other applications. We need to install different components based on if we want the node to act as worker node or manager node. Lets learn more on Kubernetes Architecture.

---



## Kubernetes Architecture

---
### Major Components of Architecture

Kubernetes is composed of multiple components. Some of the major components are API Server, Kubelet Service, etcd database, container runtime, schedulers and controllers. Here is the brief description of all the components.

- API server: It acts as a front-end for interacting with Kubernetes. All web applications, command line interface etc all communicate with API server to access kubernetes. however
- Kubelet service: It is a agent that runs in the worker nodes. It is responsible to run containers on the worker node (when assigned by master node) and communicate their health information with master node.
- etcd database: This database stores all the information about all the nodes and containers in the cluster. This is a distributed database i.e. its data is replicated across all the nodes in the cluster. Even if one node fails, the data is still secure. 
- Container Runtime: This is used to run containers. Some of the container runtime are docker, Crio, etc
- Schedulers: Schedulers schedule new containers to run to multiple worker nodes.
- Controller: Controller are brain of kubernetes. They are responsible for making sure everything is working properly. In case they detect some problem, they take appropriate steps to resolve a problem. 

We will dive deeper into all these components in later sections. 

Now, lets understand another critical part of kubernetes called kubectl. Kubectl is not a core part of kubernetes functioning but is the most famous tool used to interact with kubernetes. So, its important to understand it.

### Introduction to Kubectl

Kubectl is a command line utility that is used to interact with Kubernetes API server, one of the kubernetes components discussed above. While it is technically possible to directly interact with API server, it is recommended to use kubectl. Using kubectl instead of API server directly arises a question.

### Question 1: Why not directly use API server instead of Kubectl?

The main reason to use kubectl is its ease of use and consistent interface. 

- Ease of Use: Users dont need to know about the underlying API endpoints of API server to interact with it. 
- Consistent Interface: API Server Endpoints might change according to different kubernetes version but kubectl interface will remain the same.  

### Question 2: What is Kubernetes Control Plane?

API server, etcd database, controller and scheduler are collectively known as kubernetes control plane. They are responsible for managing the state of the cluster by ensuring that the desired state of the cluster is running at all time.

Container runtime can function independently. Hence it is not considered to be part of the control plane. Kubelet agent does not run on all the nodes. It does not manage the state of the cluster. While the container runtime and kubelet are not part of the control plane, they are critical components of the Kubernetes cluster infrastructure and work together with the control plane components to ensure that the desired state of the system is achieved and maintained.

---


## Pods

---

### Introduction to Pods

In kubernetes, we don't deploy container directly in the worker nodes. We wrap containers in a object known as pods. Pods are the smallest object you can create in kubernetes. Just like a container wraps your application, pod wraps a container. A pod could contain one or more containers. Deploying pods instead of containers raises a quesion.

### Why do we need Pods? What is the problem in deploying containers directly?

 Lets keep kubernetes out of the discussion and just focus on docker containers. We will use an example to understand the problems we face when we deploy containers directly.

 Lets say we want to deploy a python application inside a docker container. We will use a Image called `python-app`. We can easily deploy a python application using `docker run python-app`. Lets say we get a lot of traffic and decide to create 5 replicas of the container for load balancing. We can easily do it by running the same command 4 times. 

 Overtime our application goes architectural changes and now we also need to create a new helper container for each of the 5 containers. The helper container will use a image called `helper`. We wil have to do number of steps to make this work. The steps we have to perform are: 

 - Deploy 5 helper containers by running this command 5 times. `docker run helper` 
 - Create 5 different custom networks.
 - Assign each  `python-app` container with one of the custom network. 
 - Assign each worker container with one of the custom network.  

 The final result is 5 different networks and each network having one python-app container and one helper container. This will allow python-app container and worker container to communicate with each other. 

 Now what if both containers need to share some Volume? Python-app container might write to a file that has to be accessed by worker container. In such cases, we need to assign a common volume manually to both the containers. 

 Now, what if we want to remove python-app container? We also have to remove both the network and worker container associated with the removed python-app container.  

 Performing all these mentioned tasks are not a problem. They are just a part of running containerized application. The problem is doing all these task manually. Docker doesn't have a way to understand if 2 containers are related to each other. So, it cannot automatically create and share a network between 2 containers, share common volumes between 2 containers and have same life-cycle for both containers. Kubernetes on the other hand, solves this problem with pod.   

### Kubernetes Solution to this Problem

Kubernetes creates a virtual wrapper around containers called pods which solves all the issues discussed above. As discussed above, a pod can contain one or more containers. When we deploy a pod, Kubernetes automatically does the following:

-   creates a custom network that is attached to all the containers inside the pod.
-   creates a volume and attaches it to all the containers inside the pod.
-   make the lifecycle of containers depend on the pod. This means, when we create a pod, all the containers are automatically created and when we delete a pod, all the containers are automatically deleted.

There are some other questions regarding pods and containers in kubernetes. Lets see the questions and their answers.

###  Question 1: Can you deploy container directly and not use pod if you only want to deploy 1 container?
 No, even if we only want to deploy a single container, we have to deploy it inside a pod. Kubernetes doesn't work with containers directly. This is the reason why kubernetes can work with multiple container runtime components such as docker, crio etc. Always remember, the smallest object in kubernetes are Pods.

### Question 2: Should a Pod contain a single container or should it always contain more than one container? ###
 Kubernetes recommends only running one container per pod. However there might be some rare use-cases when you need 2 containers in the same pod. 
 
 The reason why you should not have 2 containers in a pod has to do mostly with how kubernetes performs scaling. As discussed above, pods as the smallest object available in kubernetes. If we want to scale our application, kubernetes deploys the new instance of pod. This means all the containers will be created inside the newly created pod even if we only needed to deploy a specific container. This leads to wastage of containers.

 Instead, if we create 2 seperate pods, each containing one single container, it will be easier for use to scale containers. We can scale the respective pod without creating any additional unneeded containers. 
 
 Your application container and pod usually have a 1:1 relationship i.e. 1 pod only has 1 application container.

### Question 3: Is it possible to add a new container inside a existing Pod? ###
  Yes, it is possible to add a new container inside a existing Pod. You need to modify the configuration YAML file. However this is not recommended by kubernetes. Lets see the reason with this example.
  
  Lets say you have a pod containing python application. After some time, you want to deploy a new containers of the same application for high-availability and load balancing requirements.

  You have 2 options.

 - You could either deploy a new pod in the same worker Node or in other worker Node inside your cluster.
 - You could deploy a new container inside the existing pod. Now, the pod consists of 2 python application containers.

 It is recommended that you use the first approach to scale your application. Although, it is possible to add a new container inside the existing pod, it goes against the principle of containerization which states that a container should contain only minimal application/services that can be scaled independently.

 When you add a new instance of the application to an existing pod, you are effectively creating a monolithic service, which can make it difficult to manage and scale the application. This also increases the risk of downtime, as any issues with one application can affect all applications in the pod.

### Question 4: What about IP addresses and Port number for Pods and containers? ###
   Pods are assigned a unique IP address and containers inside Pod share the same IP address. When Pod is created, kubernetes assigns a unique IP address to it, and then assigns each container inside the Pod with a unique Port number.  

### Question 5: How do 2 containers running in the same or different pod communicate with each other? ###
 As containers don't have IP addresses, they can't refer each other directly. However as mentioned above, containers are assigned Port number within Pod.

 This means containers within a Pod can communicate with each other through localhost interface, using the assigned port number. Kubernetes configures DNS name `localhost` to map to the current Pod's IP address. They can also communicate with other Pods in the same cluster using the Pod's IP address. 

### Question 6: How do client access Pods? ###
 Kubernetes provides a resource called `service` that allows clients to access a set of Pods using a single IP address and Port number. We will discuss this in later sections. 	



## Replica Set
---

### Introduction to Replication Controller/ Replica Set

We discussed briefly about multiple components that form kubernetes architecture. One of the component was controllers. Controllers are the brain of kubernetes. They are responsible for making sure the state of the cluster is exactly as desired and take appropriate actions if there is a problem. One of such controllers is Replication Controller.

When we discussed the functionality of kubernetes, one of the functionality was kubernetes self-healing property. Replication Controller makes this possible.

Replication Controller is a process that makes sure that a desired number of pods are always running inside the cluster. Replication controller monitors the running pods and can identify if a pod goes down. In such scenario, it will start a new pod as the replacement. Replication controller mainly does 2 things.

- Deploys x number of pods initially to the cluster.
- Monitors those x number of pods, identifies if any pod failed and replaces the failed pods. 

Based upon these 2 points, lets see the advantage of replication controller.

- Saves Time: As replication controller can deploy multiple instances of a pod automatically, it saves us from manually deploying each pod.
- Load Balancing and High Availability: As replication controller can automatically replace failed pods with new one, high availability and load balancing is maintained.

**Can Replication Controller deploy pods in all nodes in the cluster or is it specific to single node?**

Replication Controller spans across all the nodes in the cluster. This means, it can deploy pods across all the worker nodes in the cluster. Replication Controller tries to balance all the pods across all the worker nodes in the cluster. The choice on choosing worker nodes to deploy new pods depends upon the node's currently running pods. 

![[Pasted image 20230308115603.png | 600]]



### Replication Controller vs Replica Set

Replica Set has the same functionality as Replication Controller. Replica Set is a newer technology and is a recommended way to set up replicas. The main difference between the two is their support for `Selector`. 

#### What is a Selector?

A Selector is used to select/refer already existing resources. Lets understand this with a example

When we define a Pod, we can give it multiple labels. If we need to access the Pod in any other Resource such as Replication Controller or Replica Set, we can use a Selector to refer the Pod.

#### Lets see how Replication Controller and Replica Set uses Selector

Both Replica Set and Replication Controller can also manage pods that were not created as part of their creation. Lets understand this with a example: 

Lets say you create a Pod called `Pod 1`. A new requirement comes stating that you need to scale your pods count to 5. This might have been done for high availability and load balancing purposes. As you already have 1 Pod running, you only need to create 4 new Pods. You can approach this with 2 ways.

- You can delete the already running pod and create a new replica set to deploy 5 new replicas of the Pod.
- You can create a replica set to deploy 5 new replicas of the Pod but instruct it to consider already running Pod as well. This means Replica Set will create 4 additional Pods as 1 Pod is already running.

The second point however raises few questions. 

##### Question 1: There might be hundreds of Pod running. How does Replica Set identify which existing pod to consider?

This is when the concept of `Selector` comes in. You have to specify a selector in the replica set definition file. Replica set will match the selector with already existing Pods to identify the pods it should consider. 

##### Question 2: How does the use of Selector differ in Replication Controller and Replica Set?

Selector does not have to be explicitly defined for Replication Controller whereas it should be explicitly defined for Replica Set. This raises a few questions.

###### Question 2.1:  Does that mean Replication Controller does not look for existing Pods when selector is not defined explicitly in its definition file?  

No, Replication Controller still looks for existing Pods to consider. 
	
###### Question 2.2: So, how does it get the label to match? 

Replica Set will also have its own label just like Pod has. We can then use this label to refer this Replica Set. Replica Set will use this same label when labels are not provided explicitly. 

As Kubernetes recommends using Replica Set, going forward we will be using Replica Set.


### Scaling Replica Set

We can scale existing replica set either manually or automatically(based upon load).

## Deployments
---

### Introduction to Deployments

Deployments is a kubernetes resource that comes higher in hierarchy than replica set. In other words, we can say that Deployment wrap Replica Set. 

If all we want is to run few replicas of our containers across various nodes, replica set is enough. The true power of deployment resource comes when we think about the challenges we face while deploying and updating our application in production environment. 

When we deploy to production environment, we might want to use various deployment strategies, perform rollbacks, pause and resume changes so that all changes can be released to users at once etc. All these functionality are not provided by replica set. That's why kubernetes created a new resource called Deployments. 

Lets explain all the features offered by deployment resource one by one.

#### 1. Various Deployment Strategies

A Deployment can contain multiple replica Sets. Each replica Set might have different configuration. 

Just like creating a replica set/replication controller automatically creates pods and manage them, creating Deployment will automatically create and manage replica sets.

## Namespaces

A Kubernetes cluster might have hundreds of pods, replicas and deployments. In order to organize them better, kubernetes creates a group and isolates the resources within a group. You can only see the resources in your currently activated group. This group is called Namespaces. 

Kubernetes creates 4 namespaces by default. They are:

- default namespace: If no any namespace is activated, default namespace is used to provision resources.
- kube-node-lease namespace
- kube-public: Resources provisioned in this namespace is available publically to all the users.
- kube-system: This namespace is used to provision resources related to kubernetes components. When kubernetes starts up, it creates multiple containers that host control plane components, DNS server etc. All these components are crucial for functioning of kubernetes. 


### Why do we create Namespaces?

Lets understand this with a example. Consider you are using same cluster for both dev and prod environment. You have created some resource for dev environment and some resource for prod environment. You have not created any namespaces. This means all your resources are deployed in `default` namespace. This causes 2 problems.

- Environment Clutter: When you view your resources using commands such as `kubectl get pods`, you get all the resources in your current namespace. What if you only wanted to view resources deployed in `dev` environment? 
- Accidental Modification: Lets say you wanted to delete a pod from `dev` environment. You first want to get the details of pod using `kubectl get pods` command. As discussed, this will output all the pods in the current namespace. What if you accidentally delete one of the pods from `prod` environment?

We can solve both of these problems if we create 2 namespaces. One namespace will be used to deploy prod resources and another namespace will be used to deploy dev resources. 

This is the reason why kubernetes deploys containers for host control plane components and DNS server in `kube-system` namespace. 

 ![[Pasted image 20230308160342.png | 600]]

### More about Namespace

Each of the namespace can have their own policies that defines who can do what. You can also give a resource quota to a namespace. This way a namespace will only use resources within its quota.  

Resources inside a namespace can refer to each other directly with their name. To refer resource in another namespace, we can use the name of Namespace followed by the name of Resource. You can use DNS name because when Service is created, a DNS entry is added automatically.

 ![[Pasted image 20230308160812.png | 600]]


 ![[Pasted image 20230308161124.png | 600]]




---

## Security

Before we look at kubernetes security, it is important to understand docker security.

### Introduction to Docker Security

Lets first understand namespaces in Linux. Note that Namespaces in Linux is different than Namespaces in kubernetes.

#### Namespaces in Docker

>[!info]
>We will be talking about a concept called Namespaces. note that this namespace and kubernetes namespace are different concepts.

We know that unlike virtual machines, containers are not completely isolated from the host system. Containers use a Linux concept called Namespaces. A process running in a Namespace can only access resources scoped to that namespace. By resources, i mean filesystem, other processes etc.  A nginx process running in Namespace A can access all the filesystem, other processes etc scoped only to Namespace A.

The Linux host machine runs all the processes in a Namespace. This includes system utilities, docker's containerd runtime, other software's etc.  
When you run the command `ps aux | grep docker` , you can see a docker process running. The only reason you can access docker is because docker is running in host namespace.

When docker creates container, it runs all the processes inside the container in separate namespace. This is done so that processed inside container can only access resources scoped to the containers namespace. This is how docker manages isolation.  But you can see all the container scoped processes from the host as well. This is because, for host namespace, the containers namespace is a child namespace. A host machine can view all the processes in its namespace and its child namespace.

A process can be present in 2 namespaces. Each namespace will have is own Process ID for the process. When you run nginx container, nginx process starts. This process is present in 2 namespaces. Host machine namespace and containers namespace. It will have different process ID in both namespaces. This is because for host namespace, there are already hundreds if not thousands of other processes running. nginx process will get the latest Process ID. In case of nginx container, nginx process is the first process to run. So, In the namespace inside container, nginx process will get process ID of 1.


![[Pasted image 20230309125411.png | 600]]

#### Restricting Containers Permissions

Docker has multiple users available. By default, all the processes inside the container is ran by root user. You can however run a process with other available users as well. You can also create a separate user inside docker container that is only available within the container. The concept of namespaces applies here as well. The user is only scoped within the containers namespace. 

However for security reasons, docker limits the capability of root user inside the container. So, it is not as powerful as root user in the host. Docker also runs containers with limited set of permissions. Processes inside the container cant perform tasks such as rebooting the host that will affect the host and other containers in the host. You can add/remove capabilities for the container when you run it.



### Introduction to Kubernetes Security

Just like you can configure capability of a container in docker, you can also configure capability of both Pods and containers in kubernetes. If you configure capability at Pod level, it will carry down to all the containers in the Pod. If you configure it in both Pod and container, container's capability will override Pod's capability. 

Not all capabilities are supported for Pods. You can configure capabilities like the user responsible for running the Pod but cant configure capabilities like rebooting the host. It is only available at container level. 

### Accounts In Kubernetes

Kubernetes has 2 types of accounts available. 

- User Account
- Service Account

User Account is used by kubernetes administrator or developer who wants to interact with the cluster. Service Account is used by Services such as Prometheus, web application etc who wants to interact with the cluster. 

We already know that in order to interact with the cluster, we need to use kubernetes API-server component. We also know there are 2 ways of accessing API-server component. 

- Through CLI with kubectl
- Directly hitting the rest API endpoint.

User Account will use the first approach of using CLI whereas third party application will use second approach of directly hitting rest API endpoint. Lets explore both accounts in depth.

#### 1. Service Account

For Services, Kubernetes has a Token based authentication system. All applications that want to access the cluster must first authenticate with API-server. For Token, kubernetes supports the use of JWT Token. 

##### Default Service Account

There is a default service account automatically created for every namespace. It is important to note that default service account is very much limited. It only has minimum authorizations available which can only do basic queries. 

#### Creation of Service Account and Token  

The procedure for creating a service account and its token has changed in the past. Lets explore both old and new ways.

###### Old Way of Creating Service Account and Token 

Previously, Service Account and Token used to be treated separately. When you created a Service Account, a new Secret Resource was created that stored the Token for the account. The Secret was then linked to the Service Account's Configuration using its name.  When you view the details of service account using `kubetl describe serviceaccount default`, you would only get the name of a secrets object. You then had to view the secrets object using `kubectl describe secret default-token`. 

When we created a new pod, you could specify a service account name in the definition file. When kubernetes created a pod, it would mount the account and its secrets as a volume inside the pod. This way you didn't had to manually copy the Token from secret object and place it inside the pod. However, If you didn't explicitly specify a service name, kubernetes would mount the default service and its secret. You could however define a field to inform kubernetes not to mount default service when you don't specify any other service.

This way of using JWT token for authentication has some issues mainly concerning Security and Scalability. This is because the service token had no expiration time and was also not bound to any particular kubernetes resource. Hence a new way of using service tokens was introduced in version 1.22 

###### New Way of Creating Service Account and Token 

A new API by the name `TokenRequesetAPI` was introduced which solved the security and scalability issues with the existing approach. Tokens generated by TokenRequestAPI has 3 points that makes it more secure. They are:

- The token is Audience Bound
- The token is Time Bound
- The token is Object Bound.

Now, when we create a service, no token is created. This also means that secret resource is also not created. Instead we create Token on the fly. When we create a new pod, kubernetes will make a API request to TokenRequestAPI to get a token. This token is then mounted as a volume to the Pod, just like we discussed in the Old way. 