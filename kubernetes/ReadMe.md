### Introdution

Container Orchestrator is a software that is used for automatically deploying and managing/monitoring containers.

When you have only few containers, you can manage them on your own. But as number of containers grow in size, you need a software that manages the entire lifecycle of a container.

You can have your containers running on multiple servers/nodes and manage all of those through a orchestrator running on your local machine.

A container orchestrator can automatically add more containers as load grows and destroy containers as load decreases, just like how auto scaling works for virtual machines. You can also add more nodes if you run out of hardware resources and spin up new containers on those nodes.

There are many container orchestrator softwares such as docker-swarm, kubernetes, etc.

### Do you need orchestrator ?

A orchestrator offers a lot of functionalities. Those functionalities really shines when you have a lot of containers running on multiple nodes and you want to automate the deployment and management process.

Running a orchestrator involves a lot of overhead. Setting up a orchestrator, managing it, securing it is a tedious work. So, you should first identify if you really need a orchestartion service or not.

There are few scenarios where you wont need a container such as:

- **Less Containers:** You only need few containers to run you application. This means there is not much need for automating management/monitoring.
- **Less Deployment:** Your application inside the container doesnot change much. This means you dont need to automate deployment.

If you resonate with above scnearios, you might consider using other platforms such as Heroku or Elastic Beanstalk.

### Kubernetes

Kubernetes is he most famous container orchestration service. It can manage containers based upon multiple runtimes such as containerd and docker.

Kubernetes was released by Google on 2015 and is maintained by Open Source Communities. There are many distributions of kubernetes which are essentially extra features on top of the open source kubernetes version. Kubernetes is also called K8s. (8 refers to 8 letters between K and s).

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

### Kubernetes Architecture

As kubernetes offers a lot of features, there are a lot of parts in kubernetes. Some of them are :

- Node
- Cluster
- API Server
- etcd
- kubelet
- Container Runtime

- KubeCtl
- KubeProxy
- Single/Multi node Cluster
- Control Plane

Node: A node is a machine, either physical or virtual that is responsible for running our application. Nodes are divided into 2 categories, Master and Worker.

Cluster: A Cluster is a collection of nodes grouped together. If we are using Kubernetes, our requirements consists of running multiple containers on multiple nodes.

API server: This serves as a frontend for kubernetes. A user will communicate with API server via CLI tool or a GUI application to interact with a cluster.

etcd: this is a key-value distributed database that stores all data used for managing clusters such as information regarding worker nodes, manager nodes etc. All the information is stored on all nodes in a cluster in a distributed fashion.

Scheduler: It is responsible for distributing work across all the nodes in the cluster. If a container needs to be created, scheduler will find the right node in the cluster and assign the work to the node.

Kubelet: It is a agent running on all worker nodes. Once scheduler assigns task to the node, kubelet will pick up the task and will create the contaier.

Container Runtime: Kubelet will use a underlying container runtime such as Docker in order to create and run a container.

Controller: Controller is the brain behind orchestration. It is responsible for noticing and responding when a container or a node goes down. In such scenarios, they also make decisions to bring up new containers.

### Worker Node vs Master Node

Lets say we have 20 nodes each running 2 containers. All the load is distributed equally among all nodes using Load Balancer. Now, what if two nodes went down ? We will face 2 problems here

- We have to identify failed nodes and remove them from our load balancer.
- We should launch new nodes to compensate for failed nodes.

Kubernetes handles this situation with the concept of Master Nodes.

**Worker Nodes** are responsible for running the application and **Master Nodes** are responsible for monitoring worker nodes. Both nodes need to install kubernetes in order to work but the components needed for both nodes are different.

Worker nodes will need following 2 components.

- kubelet: kubelet is responsible for communicating with master node. kubelet will pick up the tasks assigned to it by master nodes. kubelet will also pass health checks to master node frequently.
- container runtime (Docker): kubelet will use container runtime to start and run containers.

Master nodes will need following 4 components.

- kube-apiserver: This is responsible for communicating with kubelet. It passes the information of tasks and also retrieves health checks.
- etcd: All the information fetched from worker node is stored in etcd database.
- control manager: Master uses control manager to make decisions regarding actions to perform in worker nodes.
- scheduler: scheduler schedules the actions that has to performed in worker nodes.

### Minicube

In order to set up a local kubernetes cluster, we can install minicube. Minicube will install all the components of kubernetes (kube-apiserver, etcd, control manager etc) through a single executable and also configure all of them.

### KubeCtl

In order to communicate with Kubernetes API server, we need a CLI tool. The most famous and official CLI tool is KubeCtl. It is also called as cube control.

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

4. Inspect the pod

   - `kubectl logs pod/my-nginx`
   - this command will print all the logs regarding my-nginx pod's container.
   - if you want more details regarding any object, you should use another command
   - `kubectl describe pod/my-nginx`
   - this command will print all the information along with events happening in the container.

5. Delete a pod
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

### Networking in kubernetes

By default, pods in a cluster donot get assigned any IP address. We can however assign IP address to pods through `kubectl expose` command. This command creates a service for existing pods. Service in kubernetes is a stable IP address for pods.

If we want to resolve IP address through their name, we also need a DNS server. We can allow DNS server inside kubernetes using `CoreDNS` feture.

There are different kinds of services.

- ClusterIP
- NodePort
- LoadBalancer
- ExternamName

ClusterIP is the default service available when you create a kubernetes cluster. This creates a virtual network in the cluster. So, you can only reach any nodes from within the cluster.

NodePort is designed for communication betwen your cluster and outside world. Nodeport will assign high ports to nodes. High ports means port numbers that are above the well known port range (0-1023).

These both services are always available in all kubernetes version.

LoadBalancer is mostly used in the cloud. The idea is to control a external load balancer through kubernetes command line. This service, in the background automatically creates ClusterIP and NodePort service. This service is provided by the cloud vendor . This service is attached to other cloud specific service such as AWS Elastic Load Balancer. This service tells AWS Elastic Load Balancer on how to route traffic to nodes in the cluster. this is basically just automation provided by cloud providers.

ExternalName is used when we need to change how my traffic is getting out of my cluster to some external service when i dont have a way to control DNS of that external thing remotely. We dont use it to assign to Pods but for giving pods a DNS name that will be used outside of kubernetes.

There is another way traffic can get inside of kubernetes and i.e through Kubernetes Ingress. This is specifically desgined for HTTP Traffic.

You can create a service and expose a port with
`kubectl expose deploy/httpserver --port 88888`. Here httpserver is a deployment that is already created with command `kubectl create deployment httpserver --image brerfisher/httpenv`

When you create a service, it doesnot make any changes to pods. So, if you are watching the containers with command `kubectl get pods -w`, no additional logs will be created. Creating a service creates a default network i.e. ClusterIP which sits infront of the deployment.

There is a default service called `kubernetes` that runs on port `443`. This service is used by kubernetes API. As we created a new service, we should see a new service called `httpserver` when we run `kubectl get service` command.

You can see that the deployment now has a IP address associated with it. This is provided by the expose command we ran above. If we manage to hit that IP address, our request will go to the deployment which will then forward the request to one of our pods.

But the IP address assigned is a Cluster IP which is a Internal IP address only accessible within the Kubernetes cluster. So, you can only access this IP address if you run `curl` command from one of the nodes in the cluster. On a linux machine where you are running kubernetes, your machine is a node in the cluster. So, you can just use a curl command to reach the cluster.
In case of windows/macos, the cluster is running on a small linux virtual machine created by docker. So, in this case, you wont be able to reach the cluster from your host machine. You need to somehow be inside the linux vm and then perform curl command as that linux vm is a node in the cluster. So, you can create a new pod inside the kubernetes and open a interactive shell to that pod. Now, you can run curl command in the pod which will be able to reach kubernetes cluster.

Lets create a NodePort.

`kubectl expose deployment/http-server --port 8888 --name httpserver2 --type NodePort`
This will create a Nodeport service. Creating a nodeport service means exposing a host's port so that outer traffic can reach the cluster. Nodeport also creates a ClusterIP and assigns that IP to the http-server depoyment. The host port is choosen randomly from range of `30000-32767`.

When you send a traffic to host port, the traffic is redirected to the cluster. This is possible as you have assigned a IP to the cluster while creating a Nodeport. The cluster then forwards the traffic to the pods at port 8888.

Lets create load balancer.
When we create load balancer, it automatically created Node Port. Node Port then automatically creates Cluster IP. If we configure load balancer to listen on loalhost:80, then:

- user sends request to localhost:80
- load balancer will send request to the Node Port. The Node Port is simply a port in host machine.
- Node Port will send request to cluster IP.
- cluster will send request to the pods.

So, technically you can just skip load balancer and send requests directly to Node Port.

We had DNS service both in Docker and Docker swarm. We also have it in Kubernetes

In kubernetes, you have a concept of Namespaces. You cannot run multiple containers in the same namespace inside the cluster. You can create multiple namespace and run different containers that have the same name. By default, all your containers are running on `default` namespace.

You can see all the namespaces using

`kubectl get namespaces`.

When you access a container with `curl [hostname]`, DNS service will only resolve for the current hostname.
If you want to access another container running in different host name, you can use a fully qualified domain naming system.

`curl [hostname].[namespace].svc.cluster.local`

cluster.local is a DNS name given to your cluster when you create it.

Generators are like templates that create specifications for certain kubernetes resources.

When you use a command (run, create, expose), you are essentially telling kubernetes to create/use a certain resource. Each resource can be supplied certain parameters that control the behaviour of the resoure.

In the bakground, all these commands will use a generator to generate specifications. This specification can be controlled based upon the command line options supplied with the command.

The purpose of generators is to allow user to create a resource by specifying only few options. Rest of the options will be generated by generators. So, generators are like specifying pre-configured/default values for a command.

There are different generators available for different commands. With each version of kubernetes, some of the attributes specified by generators might change. So, generators have versions associated with them.

You can see what are the resources a command will create and the yaml file for defining those resources.

`kubectl create deployments sample --image nginx --dry-run -o yaml`
Client will see this command and figure out what are the resources it needs to create. Client doesot communicate with server so even if some resources already exist, client wont know about it.
This command will basically simulate what will happen if we actually run `kubectl create deployments sample --image nginx`. -o yaml will spit the configuration file (generated by generators). This configuration file is responsible for telling kubernetes what resources to create.

You can create this dry-run yaml file for jobs and services as well.

History of RUN command

Previously `kubectl run` command was used to create deployments, replicas and pods. It was also used to run generators. But currently `kubectl run` is only used to create and run pods. The philosphy is to make it as similar as `docker run` command. You can use other commands to create deployments and other stuff.

`kubectl run` is not recommended for production as it simply just runs a pod. You could do this with just `docker run` command.

Running Kubernetes commands in Imperative/Declarative way

When you run commands in Imperative way, you explicitly define all the commands that needs to run one after another. You care about the process and not just end result. You dont work in abstraction.

Example: Creating and Configuring resources through Command Line

`kubectl create deployment/nginx-deployment`
`kubectl service create my-nginx`
`kubectl run nginx --image nginx`

In this case, you know the state of your program and you are creating/updating resources as you need. You know all the steps you need to take to reach a certain goal.

When you run commands in declarative way, you are only concerned about the end result. You dont necessarily know the current state of the program.

Example: creating and configuring resources through YAML file.
`kubectl create -f file.yml`
`kubectl replace -f file.yml`

In this case you are not sure if you already have a deployment or a replica set. you just care that at the end of the command there will be a deployment, replica set and a pod running nginx container. You dont know the state of the program.

Imperative approach only works with small teams. It is harder to automate following imperative approach. It is easy to learn but harder to manage over time.

In imperative approach,

- you use commands such as `run, expose, create deployment` etc.
- It is easier to learn.
- It is harder to manage large enviroments
- Easier to understand and predict the changes(what will happen)
- It is suited for personal projects.

In middle ground (imperative+declarative) approach,

- you use commands such as `create -f file.yml, replace -f file.yml`.
- It is harder to learn (YML file needed)
- It is easier to manage medium size environments
- It is easier to track changes overtime using git.

In declarative commands approach,

- you use commands such as `apply -f file.yml, apply -f dir\, diff`
- It is best approach for production
- It is easier to track changes overtime using git
- It is harder to understand and predict the result of running the command
- Really easy to automate.

### Best practise

`kubectl apply -f file.yml` command will perform all the operations such as creation of resources, updation of resources, deletion of resources etc. You just update the yaml file and commit it to git to track the changes overtime.

- You can define the file in either YML format or JSON format.
- You can put one resource per file and create multiple files or put all resources in one single file.
- these resources are called manifests. manifests define objects (deployment, service, job)
- each manifest needs 4 parts.
  - apiVersion:
  - kind:
  - metadata:
  - spec:

You can get a lits of available kind of resources with `kubectl api-resources`. This list is however extensible if you use third party resources.
A resource can have multiple versions. Each version defines some of the attributes of that resource differently. You need to choose the resource version you want to use. Use `kubectl api-versions` to view all the available api versions.
For metadata, only name field is required.
For spec, it will be different based upon the resource you choose.

To get information about a resource, you can use `kubectl explain deployments`.
To view all the supported keys of a resource, you can use `kubectl explain deployments --recursive`.
To view only spec object of a resource, you can use `kubectl explain deployments.spec`
To view only type object of a resource, you can use `kubectl explain services.spec.type`

Lets say you have a yaml file. You created resources using the yaml file. Now, you made some changes to the yml file. Now, you want to see the changes between the current yml file and yml file that was used to create the current resources. You can use `kubectl diff -f app.yml`

You can add label under metadata section. They are combination of key:value pair. These are purely optional. They are used to group resources into certain category such as tier:Frontend, tier:Backend, env:Production etc. To get pods which match a certain label run `kubectl get pods -l tier:frontend`. You can also use labels to link multiple resources. A deployment resource needs to have a link to pods to manage them. A service resource needs to have a link to pods to redirect traffic. You can define all this link in yml file.

statefulsets is a new resource in kubernetes that is designed around applictions that need persistent storage. We can persist names, IP, volumes etc. The best type of application example will be database. its better to not deal with pesistent storage untill you feel confident about other features of kubernetes. Use database as a service.

Volumes are of 2 types

- Volumes
  - It lives in the pod.
  - All containers in the pod can share it.
- Persistent Volumes
  - It lives in the cluster.
  - Multiple pods can share it.

You can also use cloud storage as volumes. You will need to install cloud-vendor specific plugins for this.

Ingress
Lets say you have 2 containers that needs to listen on port 80. You can achieve this using Ingress. You can configure it to route the traffic to different containers based upon the hostname or URL in the request. It is not built into kubernetes. You need to install third party plugins. In this case the plugins are proxies (nginx, traefik).

Deployment Tools
There are a lot of deployment tools (over 60) which are built on top of kubernetes. Each have their own opinion on how you should run your YAML file and deploy containers.

The most famous one is called `Helm`. If you want to use docker-compose in kubernetes, you can install another tool called `kompose` that translates docker-compose formatted YAML to kubernetes formatted Yaml.

Each of these tools main purpose are just helping you to format your YAML in a certain way. Helm already has a lot of these templates built in.

GUI

There are a lot of web GUI tools that lets you view and control Kubernetes from Browser. Kubernetes has its official one called `dashboard`. The problem with GUI tools is regarding seurity. There have been cases when outsider got access to companies kubernetes cluster. You can follow some security measures such as running GUI on a ranfom high port, putting some kind of proxy authentication in between etc.

Namespaces

In kubernetes, namespaces are used to create virtual mini clusters. Instead of running all your resources in the same cluster, you can create multiple virtual clusters and run resources on those clusters. This is known as namespace. When you run any commands such as `kubectl get pods`, you are running this command against the current namespace.

There is a `default` namespace in kubernetes. If you donot create any other namespace, all your resources will run in default namespace. You can get all the namespaces using `kubectl get namespaces`. By default, kubernetes hides a lot of process that's running in the background. It does so by running those process in different namespace. To see all the processes in all namespaces, run `kubectl get all --all-namespaces`
