### What is a container orchestrator ?

Container Orchestrator is a software that manages all your containers across various servers.
You will need to manage orchestrator and it will manage containers on all the servers.

- Orchestrator takes a series of servers/nodes and make them behave as one.
- Orchestrator will distribute your container workloads across all these servers.
- A orchestrator runs on top of a container runtime such as Docker or containerd.

There are many orchestrators services. Some of them such as docker-swarm, kubernetes work everywhere. Other services such as ECS(Elastic Container Service) are cloud vendor specific.

### Do you need orchestrator ?

We can run containers normally with simple `docker run` command. But as your application grows, you will end up with 10's of containers across multiple servers. Orchestrator softwares helps you to organize/manage all these containers through one single service.

That also means that you might not need a orchestrator if you have less containers or if the application inside the container doesnot change much. Even if you feel you need orchestrator, you might not need all the features offered by a orchestrator. Setting up a orchestrator, managing it, securing it is a tedious work. This is where platforms such as Heroku or Elastic Beanstalk shine.

So, if you have a lot of containers running on multiple servers and application inside the container changes frequently, you should use a orchestrator to automate tasks and monitor servers.

### Kubernetes

Kubernetes is a orchestrator that is used to manage containers across various servers. It can manage containers started with runtime such as containerd and docker but is primarily focused on Docker.
Kubernetes was released by Google on 2015 and is maintained by Open Source Communities.
There are many distributions of kubernetes which are essentially extra features on top of the open source kubernetes version. Kubernetes is also called K8s. (8 refers to 8 letters between K and s).

### How do you use Kubernetes

Kubernetes exposes APIs/CLI that can be used to manage containers.

### How do you install Kubernetes

You can install kubernetes on your local machine directly from Github's Repository. You can also install kubernetes provided by other vendors such as Rancher, Openshift, Vmware or cloud companies.

You should prefer to use vendors provided options rather that using the raw github's option. This is because you need to configure kubernetes with additional configurations, plugins etc to really make the best of it. With vendor specific version, a lot of these configurations are simplified.

### Swarm vs Kubernetes

- Swarm is easy to setup.
- Swarm makes it really easy to deploy/manage containers.
- Swarm is packed with docker so it works really well with docker and has a very mimimal size.
- It has support for networking.
- It follows a good security practice by default.
- It runs anywhere docker runs i.e. Windows, Linux, Rasperry Pi etc.
- Easier to troubleshoot as it is simple to use and has less things to manage.

Swarm works prefect for 80% of the use cases but there are few scenarios where swarm doesnot solve all the issues. Thats where Kubernetes comes.

- Kubernetes is relatively hard to setup.
- Kubernetes is more complex to use as compared to swarm.
- Kubernetes provides more flexilibity to accomplish the same task.
- Kubernetes has more features in terms of managing containers.
- Kubernetes also has a wider adoption as compared to swarm.

### Parts of Kubernetes

KubeCtl: KubeCtl is a CLI tool that is used for talking with kubernetes API. It is also called as cube control. There are a lot of CLI tools that can talk to kubernetes but KubeCtl is the official one.

Node: A server is called a node in kubernetes.

Kublet: Kublet is a container that runs on all worker nodes. Inside a container, there is a small agent responsible for communication between nodes and kubernetes control plane.

Kube-procy: Kube-proxy is a container that runs on all worker nodes. This container is responsible for managing networking.

Single/Multi node cluster: You might be running your kubernetes management system in a single node. That is called a single node kubernetes cluster. You also might be running your kubernetes management system in multiple nodes. This is called multi node kubernetes cluster.

Control plane: Control plane are group of containers that are responsible for managing the entire cluster. They are also called as Masters. Each master (each node in the control plane) will be running multiple containers that includes API, scheduler, controller manager, etcd (database), dns, networking, storage etc. The principle is that one container only does one thing and does that really well. You will deploy your appliation in other nodes and manage those nodes through control plane.

There are a lot of additional tools that you might install on both your masters and worker nodes. kubernetes is designed to be extensible.

### Terminologies in Kubernetes

Pods: Pods are one or more containers running together on a node. They are basic unit of deployment. We never deploy containers directly on kubernetes. We deploy pods.

Controller: Controllers are used to create/update pods and other objects. Controller basically makes sure that everything inside a pod is exactly what you want. It is a differencing engine that makes sure that there are no differences in what is going on inside a pod and what you expect. There are many types of controllers such as Replica Set, Deployments, Job, CronJob, etc. You can deploy pods directly without controller but soing so will remove all benefits of a controller.

Server: It is a network endpoint given to a pod so that it can communicate with others.

Namespace: It is just a filter that filters the output you see on the command line with kubectl commands.

There are other terminologies as well such as secrets, ConfigMaps etc.

### Creating a Pod

Before creating a pod, lets understand some terminologies associated with creation of pod. When you create a pod, you have 3 major terminologies.

- Deployment Contoller
- Replica Set
- Pod

**Deployment Controller**

- It is used to control deployments.
- It can do all sort of deployments such as rolling deployments, blue-green deployments etc.
- It manages Replica Set.
- It is controller by the user through cli commands.

**Replica Set**

- It is used to create and manage pods.
- It is controlled by deployment controller.
- It has the ability to create replicas of a pod using the same image template.

**Pod**

- It is a collection of one or more containers.
- It is managed by Replica set.

We can control all the attributes/configurations of deployment controller, replica set and pods. As a user, we only need to manage deployment containers. Deployment containers will take care of the underlying abstractions.

By default, when we launch a replica set, it will be launched with 1 pod. However, we can configure this parameter while launching. There are 2 parameters in replica set,

- desired state
- current state

desired state means the total pods that is desired by the user.
current state measn the total pods that are currently available in the replica set. We can change the desired state value which will trigger replica set to automatically scale up or down pods.

### Commands in kubernetes

1. First, check that kubernetes cli is properly installed

   - `microk8s.kubectl version`.
   - this command should show versions for client and server.
   - as you will be using kubectl a lot, we can create a alias in your `.bashrc` file as `kubectl=microk8s.kubectl`

2. Lets create a pod for nginx web server

   - `kubectl run my-nginx --image nginx`.
   - `my-nginx` is the name of this pod.

3. Lets view all the objects.

   - `kubectl get all`
   - You will see 2 objects.
     - pod
     - service.
   - To view only pods, you can use `kubectl get pods`.

4. Delete a pod
   - `kubectl delete pod my-nginx`
   - This command will delete the pod.
   - If you have fault tolerance configuration set up, new pod will be created for replacement.

<!-- 4. Change replica set pods

   - `kubectl scale deploy/my-nginx --replicas 3`
   - Notice that we donot talk with replica set directly. We communicate with deployment controller which takes care of underlying abstractions.
     - We set the `desired replicas` to 3 by communicating with `deployment controller`.
     - Deployment Controller communicates with `replica-set controller` and sets pods count to 2.
     - replica-set controller assigns which node should start a new pod.
       - In single node cluster, the current node will be assigned to start a new pod.
       - In multi node cluster, other nodes will be assigned to start a new pod.
     - `kubelet` will figure out that a new pod is needed and will start a new pod.
   - We can write this command in multiple other ways such as
     - `kubectl scale deployments my-nginx --replicas 3`
     - `kubectl scale deployment my-nginx --replicas 3`

   ![replia set picture](./assets/Screenshot%20from%202023-02-10%2016-08-50.png) -->

### Which is faster? Swarm or Kubernetes

Swarm is faster than kubernetes as everything is happening under a single process. With kubernetes we have all these additional abstraction layers that might be running in seperate processes. But in most of the cases this speed difference is negligible.