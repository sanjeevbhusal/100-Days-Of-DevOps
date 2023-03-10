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

Controller: Controller is the brain behind orchestration. They monitor the kubernetes objects and respond accordingly.

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

### Installation of Kubernetes/ Minicube and KubeCtl

In order to set up a local kubernetes cluster, we can install minicube. Minicube will install all the components of kubernetes (kube-apiserver, etcd, control manager etc) through a single executable and also configure all of them.

In order to communicate with Kubernetes API server, we need a CLI tool. The most famous and official CLI tool is KubeCtl. It is also called as cube control.

Once minikube is installed, we can start a new cluster using `minikube start`. We can view the status of minikube using `minikube status`. We can see the information regarding cluster with `kubectl cluster-info`. We can view the running pods with `kubectl get pods -A`. We should see multiple pods such as api-server, controller, scheduler etc.

### Pods

In kubernetes, we dont deploy container directly in the worker nodes. We wrap containers in a object known as pods. pods are the smallest object you can create in kubernetes. Just like a container wraps your application, pod wraps a container.

**Why do we need Pods? Why not just deploy a single container?**

Lets keep kuberenete out of the discussion and just focus on docker containers. Lets say we want to deploy a python application inside a docker container. We succesfully deploy a python application using `docker run python-app`. Lets say we get a lot of traffic and decide to create 5 replicas of the container for load balancing. Overtime our application goes architectural changes and now we also need to create a new helper container for every python-app container. We have to now deploy 5 helper containers, link them together, configure networking so python-app container 1 can communicate with helper container 1. We also need to share volumes between python-app container 1 and helper container 1. If python-app-container one is removed, we also need to remove helper container 1.

In case of kubernetes, we would wrap both python-app container and helper container inside a pod and deploy 5 replicas of the pod. Kubernetes will take care of managing shared storage between the containers in a pod. Kubernetes will also keep all containers in a pod in the same network. So, containers can communicate with each other by using localhost as URL as both share the same pod. When one container goes down, kubernets will also destroy other containers in the same pod.This way, we donot have to manage multiple containers ourself.

The dowside is even if we only want to deploy a single container, we have to deploy it inside a pod. Thats just how Kubernetes works.

**What if instead of creating a new pod, we deploy new containers in existing pod?**

Lets say you have a pod containing python application. After some time, you want to deploy a new containers of the same application for high-availability and load balancing requirements.

You have 2 options.

- You could either deploy a new pod in the same worker Node or in other worker Node inside your cluster.
- You could deploy a new container inside the existing pod. Now, the pod consists of 2 python application containers.

It is recommended that you use the first approach to scale your application. Although, it is possible to add a new container inside the existing pod, it goes against the principle of containerization which states that a container should contain only minimal application/services that can be scaled independently.

When you add a new instance of the application to an existing pod, you are effectively creating a monolithic service, which can make it difficult to manage and scale the application. This also increases the risk of downtime, as any issues with one application can affect all applications in the pod.

Your application container and pod usually have a 1:1 relationship i.e. 1 pod only has 1 application container.

**Creating a Pod**

We can create a pod by running this command.

```shell
kubectl run nginx --image=nginx
```

`--image` flag is used to provide the image name. By default, kubernetes uses dockerhub as the registry.

This command did following steps:

- Scheduler assigned this task to one of the node in the cluster. As this is a single node cluster, it is assigned to the host machine itself.
- The host is also a worker node. So, it contains kubelet which will identify that a task has been assigned. It will pull the image, creates a container and starts a container inside the pod.

You can view all the running pods by running this command

```shell
kubectl get pods
```

The command will show some basic information about the pod. Each pod also gets a Internal IP address inside the cluster. You can view that by supplying `-o wide` flag to the above command.

To view the detailed description of pods and all the events that occurred in the pod, run this command

```shell
kubectl desribe pod nginx
```

### YAML files

Instead of using Command Line to define pods and other resources, we can list all the requirements inside a YAML file. There are four properties which are must in YAML file irrespective of any resource you create. They are

- apiVersion
- kind
- metadata
- spec

![yaml file description](./assets/YAML%20file%20description.png)

**apiVersion:** With each update of kubernetes, the number of resources available in kubernetes might change. Some resource could have new properties added or existing properties removed. This affects the way you define your resources in YAML file. So, you need to specify which version of kubernetes to use for create resources. This is in the string format.

**kind:** You define the type of resource to create in this field. This is in the string format.

**metadata:** You can define metadata related to the resource being created such as name, labels etc. This is in the dictionary format.

**spec:** We list all the specification regarding the object we want to create. This is going to be different based upon the resource. This is in dictionary format.

We can create resources based upon this YML file by running this commad

```shell
kubectl create -f pod-defination.yml
```

### Label/Selector

A label is a key value pair assigned to a resource. The sole purpose of label is to organize multiple resources into groups. We could deploy hundreds of pods and assign different pods different labels to group them. Pods containg frontend application could have a label `tier:frontend` and Pods containing bakend application could have a label `tier:backend`.

### Replication Controller

Replication Controller is a process used to monitor pods inside a cluster. Replication Controller makes sure that at any given point of time, x number of pods are always running in the cluster. There are multiple scenarios where replica controller helps.

- **Saves Time:** If we want to deploy multiple copies of a pod, we can use replica controller to deploy all the pods with a single command.
- **Ensures High availability:** Lets say we have 1 pod running in the cluster. If that pod goes down, our users will complain. Replica Controller automatically detects when the pod goes down and creates a replacement pod.
- **Ensures Load Balancing:** Lets say we have 2 pods running for load balancing needs. If one the pod goes down, the load on remaining pod grows. Replica Controller automatically detects when the pod goes down and create a new pod as a replacement.

  **Behaviour of a Replication Controller**

When we apply a replication controller, it does following steps:

- First it looks at the desired replica number supplied by the user.
- It then identifies how many containers are running currently that has the same labels specified by user in replica controller's YML file.
- It then figures out how many containers it has to create/stop to match the running containers to desired replica number.

Lets see it using few scnearios.

Scenario a) There are already 10 pods running. 2 of them have `tier: backend` as labels and one of them has `tier: web server` as labels. User wants to run 4 pods. User has supplied a label of `tier: backend` to apply to pods.

- Desired replica amount: 4
- Already existing containers that matches user label: 2
- New containers to start: 4-2 = 2

Scenario b) There are already 10 pods running. 6 of them have `tier: backend` as labels and one of them has `tier: web server` as labels. User wants to run 3 pods. User has supplied a label of `tier: backend` to apply to pods.

- Desired replica amount: 3
- Already existing nginx containers that matches user label: 6
- Containers to remove: 6-3 = 3

To run a replication controller, run the following command

```shell
kubectl apply -f replicationcontroller-defination.yml
```

To view the information regarding replication controller, run the following command

```shell
kubectl get replicationcontroller
```

**Label/Selector for Replication Controller**

We could have hundreds of pods running at a time. A Replication Controller needs labels to identify which pods it needs to manage. Mentioning Labels for Replication controller is optional.

If Label is not provided, it will use labels of the pod specified under template section. Using that label, it will figure out if there are any running pods which matches this label. Then, it will decide the number of containers it need to create/destroy.

If the existing container that matches the labels where launched using seperate image, replication controller will still consider it. However, if any of the managed container gets destroyed, newly created container will use the image mentioned in replica controller's template section.

### Replica Set

Replica Set is a modern version of Replication Controller. The major difference between the both is that mentioning Lables is compulsory for Replica Set.

Replica Set doesnot use the labels of pod under template section just like Replication Controller does. You have to explictly mention it.

To run a replica set, run the following command

```shell
kubectl apply -f replicaset-defination.yml
```

To view the information regarding replication controller, run the following command

```shell
kubectl get replicasets.apps
```

To run a replication controller, run the following command

```shell
kubectl apply -f replicationcontroller-defination.yml
```

To view the information regarding replica set, run the following command

```shell
kubectl get replicationcontroller
```

**Differences in Replication Controller and Replica Set**

The difference in both comes on how they treat already running pods.

When defining YAML file with kind as Replica Set, need to compulsorily define a selector. The selector has labels. This label is used to identify already running pods.

Lets say you specify to run a nginx image with 3 replicas in YAML file. You also specified a selector as `tier:backend`. When you run the replica set, kubernetes will first check if there is any running pod with the same label `tier:backend`. Lets say 1 pod exists with this label. Replica set will then only spin 2 new pods and use the existing pod to fulfill desired 3 replicas.

## Scaling Replica Set

We can scale number of containers maaged by replica set with different ways. Some of the way are:

- Modifying the replicas field in the file and running replace command

  ```shell
  kubectl replace -f rs.defination.yml
  ```

- Modifying the replicas field in the file and running scale command

  ```shell
    kubectl scale --replicas 6 -f rs.defination.yml
  ```

  Using this approach, you will scale your replicas but in your file replicas attribute will be the same. So, you should also update the file.

### Deployment Strategy

Lets say we want to run 5 pods with nginx:1.5 image. This are all the steps we will take

- Create a replica set yaml file with appropriate configurations.
- Run the following command to create a replica set object which then deploys the pods.

  ```shell
  kubectl apply -f replicaset.yml
  ```

Now, lets say we want to update all the pods to run with nginx:1.6 image. We can perform this deployment in 2 ways.

- Recreate approach

  - First destroy all the running pods. We can delete the replica set which deletes all the pods.

    Run the command to delete replica set.

    ```shell
    kubectl delete replicasets.apps myapp-repliaset
    ```

  - Now, update the repliaset.yml file with new image name.
  - Run the following command to create a replica set object which then deploys the pods.

    ```shell
    kubectl apply -f replicaset.yml
    ```

This approach is fairly easy to understand and implement. This approach has a major disadvantage. After you delete all your pods, your users will not be able to access the application untill you deploy new pods.

- Rolling Update Approach

  - First destroy one running pod. Run the following command to delete one pod.

    ```shell
    kubectl delete pods myapp-repliaset-56878
    ```

  - Now, update the repliaset.yml file with new image name.
  - Run the following command to create a new pod object.

    ```shell
    kubectl apply -f podconfiguration.yml
    ```

  - Repeat the steps untill all pods are updated.

The second approach seems nice but it has two problem.

When we run this command `kubectl delete pods myapp-repliaset-56878`, the pod gets deleted. However as the pod is managed by replica set, replica set will automatically create a replacement pod with the same image. Even if we update the `replicaset.yml` file, replica set will still use the old image. This is because, Kubernetes stores the cofiguration file for the replica set in memory. Kubernetes doesnot use the replica set file from host file path.

- Third approach

  - Create a new replica set with the updated image name.
  - Deploy the new replia set with the following comand.

    ```shell
    kubectl apply -f new_replicaset.yml
    ```

  - Delete the first created replica set which deletes all the pods with nginx:1.5 image

    ```shell
      kubectl delete replicasets.apps myapp-new_repliaset
    ```

This approach seems nice but has few problems.

When we run this command ` kubectl apply -f new_replicaset.yml`, we are deploying additional pods without deleting any existing pods. So, the toal number of pods have doubled. This might cause hardware resources limitations issues across multiple nodes.

When we run this command ` kubectl apply -f new_replicaset.yml`, we are deploying pods in a new replica set. If we did any kind of configuration in existing replica set (networking, storage etc), we also have to repeat that in new replica set so that all new pods behave as existing pods.

What if the recent update caused some issues and you want to roll back to previous version? What if you want to change the underlying resource allocation as the new version is more heavier in terms of RAM uage? What if you want all your newly ugraded applications to be rolled out together to users? There are a lot of questions.

So, instead of performing all above commands one after another to perform deployments, kubernetes allows you to perform multiple kinds deployments with rollback support, resource allocation etc.

### Deployments

Deployments is a object in kubernetes which wraps around replica sets. A deployment might contain multiple replica sets.

We can use this deployment object to perform multiple operations regarding deployments. We can use deployments to perform deployments through various strategies, perform rollbacks, pause and resume the changes so that all the applications can be released to users at once, etc.

As creating a replica set/replication contoller automatically creates pods and manage them, creating Deployment will automatically create replica set and manage replica sets.

To create a deployment, run the following command

```shell
kubectl create -f deployment_defination.yaml --record
```

This command will automatically create a replica set. Replica set will then automatically create pods. Run the following command to view all the kubernetes resources/objects created

```shell
kubectl get all
```

So far, all the operations done by deployment object can be achieved by just creating replica set as well. This is because the true power of deployment object comes while we perform updates/rollback to our pods.

When we create a deployment, we are creating a `rollout`. This means we are rolling our application to the nodes.

To check the rollout status of a deployment, run following commands

```shell
kubectl rollout status deployments myapp-deployment
```

The output will tell you either your deployment rollout has successed or failed.

In order to perform any kind of rollback, we also need to track the history/revision of all the rollouts performed. Kubernetes deployment object tracks all the history/revision of all the rollouts performed and uses the revision to perform rollbacs.

To view all the revision history of deployment, run following commands

```shell
kubectl rollout history deployments myapp-deployment
```

Kuberentes can perform deployments with multiple deployment strategies such as Rolling Update, Recreate etc. By default, kubernetes uses Rolling Update Strategy.

**Upgrading the pods**

Upgrading application can mean multiple things. We might want to update the docker image, name, tags, number of replicas etc. We will modify whatever changes we need in the `deployment_defination.yaml` file and run the following command to perform upgrade.

```shell
kubectl apply -f deployment_defination.yaml
```

The command will analyze the deployment_defination file. Deployment object will then create a new replica set. Deployment object will then delete one existing pod and replace it with new pod created from new replica set.

You can view all the events that occured in the deployment object while preforming deployments with

```shell
kubectl describe deployments myapp-deployment
```

When all the pods are replaced, you can run following command

```shell
kubecl get all
```

You would see a newly created replica set. You would also see that old replica set now has 0 pods in all desired, current and ready state.

**Why kubernetes doesnot update existing replica set and instead create a new one?**

The reason why Kubernetes creates a new replica set instead of updating the existing replica set is to allow the possible rollback to the previous application version in case something goes wrong. To roll back to previous version, we need to have replica set that created previous version of application.

Lets say we created a deployment with as nginx. If we change nginx to apache and run `kubectl apply -f deployment.yaml` file, a new replica set will be created. However if we change image back to nginx and run the command again, a new replica set will not be created. Kubernetes will use already exising replica set.

**Rolling Back**

Lets say you ran a deployment creating 5 replicas of nginx image. You then updated the file and set image to be httpd. You ran `kubectl apply -f deployment.yaml` command. Deployment object then created a new replica set. You were using Rolling Update Strategy. So, Deployment object took one container off from First Replica and Created another container in Second Replica. It did this untill all containers were removed from First Replica and Second Replica had same pods as replica amount.

You realized that httpd image has problems and want to fix those problems. But you first want to rollback to previous replica till you fix the problem. As discussed above, Deployments object doesnot override the replica but instead creates a new one. Inorder to rollback to previous replica, run the following command

```shell
kubectl rollout undo deployment myapp-deployment
```

### Networking in Kubernetes

All nodes in a kubernetes have a IP address assigned to them. Example: 192.168.1.0, 19.168.1.1 etc.
All these nodes are running kubernetes. Kubernetes by default creates a virtual network with IP 10.244.0.0.
In kubernetes, container doesnot get any IP address assinged to it. Instead, Pod get a IP address.
When we create a Pod in a node, the pod gets a IP address assigned to it from 10.244.0.0 network Pool. Example: 10.244.0.3, 10.244.0.4 etc.
Using this IP address, Pods can communicate with each other in a single host. In case of multiple hosts communication this will cause issues as all the nodes in the cluster have the same network IP i.e. 10.244.0.0. So, the network traffic is routed within the same host and never leaves the host.
Kubernetes expects user to manage all the problems related to networking on their own. There are builtin solutions/addons on top of kubernetes to manage networking between multiple nodes. They are cilium, flannel, Vmware NSX etc.

So, the main issue in networking is to find a way so that all pods in all nodes can communicate with all other pods in all other nodes.

## Networking Inside Minicube

When you run a local instance of kubernetes using minikube, minikube runs kubernetes either inside a docker container or inside a virtual machine. Lets assume we are running kubernetes inside docker container. These are the steps you need to follow to connect with the container.

a) First, look for a docker container named minikube.

```shell
docker container ps | grep minikube
```

b) To send a request in minikube container, you have 2 options, IP address or Docker exec.

**Use IP address**

a) Get the IP address of the docker container minikube

```shell
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' minikube
```

b) Kubernetes listens at port 8443. Send a request to the container at port 8443.

```shell
curl [minikube container Ip address]:8443
```

**Use Docker exec**

a) Use docker exec command to execute a command inside docker container.

```shell
  docker exec minikube curl localhost:8443
```

You should get a response back from kubernetes in both ways.

Now lets deploy a pod with nginx image in the current host. Then we will communicate with the pod using its Internal IP address.hese are the steps you need to follow to connect with the pod.

a) First, run a pod with nginx image.

```shell
kubectl run nginx --image nginx
```

b) Get the IP address of the pod.

```shell
kubectl get pods -o wide | grep nginx | awk '{print $6}'
```

c) The pod is in the network 10.244.0.0 which is a Private IP address assigned by kubernetes. To access the pod you have to be in the same network. You can also access the pod if you are inside minikube container as the virtual network is created in minikube container.

```shell
docker container exec minikube curl [Pod IP address]
```

### Services

Services are kubernetes objects that let pods communicate between multiple hosts. Lets first see the problem that exists in kubernetes networking.

**Problems**

First, lets get our basics clear regarding kubernetehttp://192.168.49.2:30008s IP address. When kubernetes gets installed on a host, it creates a internal virtual network with IP 10.244.0.0. This is a private network which can be accessed only from the node. All the resources deployed in the node will be assigned a IP address from this pool.

Lets say I have a 1 node cluster. I then deploy a web server application pod in the node. The pod gets assigned a IP address of 10.244.0.50. If I want to access my node from Internet, I can use its IP address to do so. But how do I access my pod? It is running on Internal IP address which cannot be accessed from Internet.

**Solution**

Thats where the concept of services comes in. Services will bind the IP address of my pod to one of the port in the host machine.

Lets say I bind my port to Ip address of 3004. Now, when I send a request to IP address of host at port 3004, the request gets redirected to the pod. This way I can communicate with my pod even if it is running in private network.

This also means pods deployed in different hosts can also communicate with each other if all of them are bind to a port in their respective host.

This type of service is known as NodePort service because the service listens to a port in host machine and forwards the request to the pod.

**Types of Services**

There are total of 4 services.

- Cluster IP
- NodePort
- Load Balancer

**Cluster IP**: Cluster IP service creates a virtual IP address inside the cluster and assigns them to resources deployed in the cluster. This allows resources to communicate with each other within a single host.

**NodePort**: NodePort service maps a port on the host machine to a resource inside the cluster. This way a resource can communicate with external traffic.

**Load Balancer**: Load Balancer service provisions a load balancer to distribute load across multiple pods in cloud environment. You can provision a load balancer to distribute loads across all the pods running webserver.

**Services In Depth**

A Service is actually a server which acts like a proxy. It will listen for a request and forward that request to a kubernetes resource. Kubernetes resource will then process the request and respond back to the service. Service will then respond back to the IP which sent the original request.

a) **Node Port**

There are 3 ports involved in NodePort.

- The host port where the service listens to
- The services port where the traffic redirects from the host port.
- The pod port where service forward the request.

So a service is not related to any resources of kubernetes. It just acts like a reverse proxy.

**Creating a Node Port service**

this is a file called service-defination.yml

```shell
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  type: NodePort
  ports:
    - targetPort: 80
      port: 90
      nodePort: 30008
  selector:
    app: myapp
    tier: backend
```

You can create a node port service by running following command

```shell
kubectl apply -f service-defination.yml
```

**Explaination of the command**

In this Kubernetes manifest, the port field in the port section specifies the port number that will be opened in the service. You could configure a service to listen on multiple ports (80, 400) etc and forward the request to different endpoints in the pod (80->80, 400->100) etc. This is useful if you have 2 applications in the pod listening to 2 different ports (80, 100).

The targetPort field specifies the port number on which the Pods targeted by this Service are listening. In this case, the Pods should be listening on port 80.

The nodePort field specifies the port number that will be opened on all the cluster nodes, which can be used to access the service from outside the cluster. In this case, the node port is 30008.So, request coming to port 30008 on host will be forwarded to port 90 on service.

The selector field specifies a set of labels that should match the labels defined in the metadata.labels field of the Pods targeted by this Service. In this case, the Service targets Pods with app=myapp and tier=backend labels.

As a Node Port service has a IP address, you can directly send request to the IP address on port 90. Node Port service will forward the request to the pod and return the response.

If you have multiple pods in a single host that match the label defined in the service cconfiguration file, then the service will act as a load balancer and distribute the load to one of the servers using random load balancing algortithms.

**Example :**

Lets say we have 5 pods with nginx image in a single node. All 5 pods have a label `tier: webserver`. Lets say we create a service where we specify the selector to match all resources with label `tier:webserver`.

When the service starts, it looks for all the resources with label of tier:webserver. It finds 5 pods that match the label. It then registers all 5 pods. In this case service also acts as a built in load balancer. Any request coming to the service will be forwarded to one of the pods. The algorithm that determines the pod is a random load balancing algorithm.

If we have multi node cluster, kuberenetes will automatically span the service across all the nodes and adjust the port configuration acorss all the nodes. You dont have to make any additional changes.

**Traffic Flow of a service**

So, to clarify the traffic flow:

- The client sends a request to the virtual IP address of the service, which is the IP address of the service.

- The request arrives at the node that kube-proxy is running on.

- kube-proxy uses the IPTables rules to select one of the available endpoints for the service (i.e. one of the selected pods) to forward the traffic to, based on the load balancing algorithm.

- The traffic is forwarded to the selected endpoint (i.e. pod).

- The pod processes the request and sends the response back to the client, which goes through the same process in reverse.

In the case of a NodePort service, a port is opened on each node in the cluster (e.g. port 30000), and any traffic sent to that port is forwarded to the virtual IP address of the service.

The traffic flow for a NodePort service is similar to that of a ClusterIP service, with the only difference being that the traffic is first directed to the NodePort on the node, which is then forwarded to the virtual IP address of the service

**Is Service a server ?**

In a way, you could say that a service behaves like a server. It listens for incoming requests and forwards them to the appropriate pods, using the load balancing algorithm configured for the service.

The service's IP address and port number can be used by clients to connect to the service, just like they would with a server. The service then uses the selected load balancing algorithm to determine which pod to forward the rIs it because I can configure multiple port forwarding rules in a single service based upon the request service receivesequest to.

So, in summary, a Kubernetes service behaves like a server in that it listens for incoming requests and forwards them to the appropriate backend pods using load balancing. However, it is important to note that a service is not a server in the traditional sense, as it does not host any application code itself, but rather acts as a layer of abstraction over the pods that actually host the application code.

b) **Cluster IP Service**

Cluster IP Service is used to group multiple pods so that they can be accessed through a single interface. You can group 5 different nginx pods into a single cluster IP service called `web-server`. The service will have its own internal private IP address as it is a kubernetes resource. When you send request to web-server service, the service will forward the request to one of 5 nginx pods. The service also acts like a load balancer and can use various algorithms to balance the load.

**Practical Example :**

Lets say you have 2 pods running nginx web servers, 5 pods running frontend application, 5 pods running backend application and 3 pods running database. You have labelled web server pods as `tier:webserver`, frontend pods as `tier:frontend`, bakend pods as `tier:backend`.

You will first create a NodePort service called `webserver` and group all pods with label `tier:webserver`. The service will have its IP address in the cluster as discussed above. You will expose port 80 on the service. You will configure the service to map port 80 of the host machine to port 80 of the pods. This is needed as nginx webserver listens at port 80 in the pod.

Lets say user John sends a request to the hostmachine at port 80. The request gets forwarded to the port 80 on the IP address where `webserver` service is running. Service forwards the request to one of the pods running nginx webserver using some kind of load balancing algorithm.

The purpose of nginx webserver is to act as a reverse proxy. It should forward the request to Frontend pods. Currently we have 5 frontend pods with following IP address, 10.244.0.207, 10.244.0.208, 10.244.0.209, 10.244.0.210 and 10.244.0.211.

The question is how do we configure nginx webserver to send request to these pods. We can't hardcode the IP address because of following reasons.

- Frontend Pods can be destroyed and recreated anytime. So, their IP address is not static.
- Even if the IP address of frontend pods was never to change, which Frontend pod's IP address will we hardcode on nginx web server? We have 5 frontend pods for the sake of load balancing and high availability.

So, currelty we need to solve 2 problems.

- We need to have a static IP address that never changes even if pods are recreated.
- We need to have some kind of load balancer between nginx webserver and frontend pods.

The solution to both problems is to create a Service for Frontend Application.

We will create a ClusterIP Service called `frontend` and group all pods with label `tier:frontend`. The service will have its IP address in the cluster as discussed above. You will expose port 5000 on the service. You will configure the service to forward all traffic to port 5000 of the pods. This is needed as frontend application listens at port 5000 in the pod.

We will now configure nginx webserver to forward requests to `frontend` service. When the user sends request to host machine, it first gets routed to nginx web server. nginx web server then forwards the request to `frontend` service.

This solves the first problem of not having a static IP address. `frontend` service will alwasy have a static IP address unless you delete the service manually. If you add or destory some frontend pods, `frontend` service will perform all necessary configurations to add and remove them from the service.

This also solves the second problem of Load Balancing. Just like `webserver` service, `frontend` service will also act as a Load Balancer. When `frontend` service recieves the request, it will forward them to frontend pods using one of many load balancing algorithm.

The purpose of frontend application is to communicate with backend application, get the appropriate data and send response back to user. Currenty, we have 5 backend pods running with Ip address of 10.244.0.50, 10.244.0.51, 10.244.52, 10.244.0.53 and 10.244.0.54.

The question is how do we configure frontend application to send request to these backend pods. Just like the frontend application, we have same 2 problems.

- Can't hardcode the IP address of backend pods as IP address can change if pods are recreated.
- Even if the IP address of backend pods was never to change, which Backend pod's IP address will we hardcode on fronend application? We have 5 backend pods for the sake of load balancing and high availability.

The solution to both problems is also creating a ClusterIP Service called `backend` and grouping all the pods with label of `tier:backend`. The service will have its own IP address. We will expose port 8000 on the service. We will configure the service to forward all traffic to port 8000 of the pods. This is needed as backend application listens at port 8000 in the pod.

This solves both the problem of static IP and load balancing. We will now configure frontend application to send request to IP address of `backend` service to establish communication.

Backend application also needs to communicate with database application. We face the same 2 problems of static IP and load balancing. We will use the same strategy of creating a `database` service, grouping all pods with label `tier:database`, configuring ports on the service and finally configuring backend application to send request to IP address of `database` service to establish communication.

c) **Load Balancer Service**

Load Balancer Service is used to configure a load balancer for all the nodes in the kubernetes cluster. If you have multiple nodes in your cluster running a web server pod, its better to provide a single Interface (Load Balancer) which routes all the request to nodes in the cluster.

Lets see with a practical example.

Lets say you have a kubernetes cluster spanning across 5 nodes. The IP address of those nodes are 15.206.93.156, 13.235.27.9, 14.12.67.234, 19.230.98.13, 20.158.278.34 and 14.234.23.2.

You then create a deployment object(`myapp-deployment`) with 5 replicas of a python web aplication. As you are deploying 5 replicas of the pod and we have exactly 5 nodes, each node will get 1 pod.

You then create a NodePort Service (`myapp-service`) and register it with `myapp-deployment`. When you register a service to a deployment, all the pods under the deployment will automatically be registered in the service. The service maps port 5000 on the host to port 5000 in the pod.

In order to access the application, you can send a request to one of the IP address at port 5000. You then decide to make this application publically available to users. Your user will expect a website URL to connect to the application. They donot care about remebering IP addresses and port.

To solve this Issue, you decide to create a Load Balancer and register all the Node's IP address to the load balancer. You will most probably create a seperate VM, install a lod balancer (example nginx), configure load balancer with all 5 nodes IP address and appropriate Port Number (5000). You will then get a DNS name for the load balancer. This solves your issues.

Lets say due to high number of load, you decided that 5 replicas are not enough. So, you scale your deployment to have 10 replicas. Turns out that scaling 10 replicas will need additional nodes. So, you will add 2 additional nodes with IP 16.9.75.23 and 19.18.22.38.

Now the issue occurs. There are few issues due to this approach.

- These new nodes are useless untill you register your nodes with the load balancer.
- Lets say you decide to change the exposed Port on the host from port 5000 to port 6000. You will make necessary changes in your NodePort service (`myapp-service`) configuration file. For this to work, you also need to make necessary changes to Load Balancer's configuration.

**Solution**

The solution to this Problem is a new service called LoadBalancer Service. When you create a Load Balancer service, it registers all your resources automatically in the load balancer. You dont need to make any changes to the load balancer even if you add/delete additional nodes.

Load Balancer service automatically creates a Node Port service. Load Balancer service is only available to cloud specific vendors like AWS, Azure etc. Trying to use Load Balancer service outside of Cloud Environment will only create NodePort service.

Lets see how above example plays out in this case.

Previously we created NodePort Service and registered it to `my-deployment` deployment object. This time, we will create a LoadBalancer Service and register it to `my-deployment`.

Creation of loadbalancer service will do following steps:

- Creates a NodePort service and register `myapp-deployment` to NodePort. This will make sure that when a request comes to host, it is mapped to pods running in private network inside host.
- Registers all the configuration of NodePort service such as Host's IP addresses, Port number etc to a load balancer. This way load balancer gets automatically configured. Load Balancer configuration gets automatically updated whenever new pods are added/removed.

You can view all the details in LoadBalancer Service object.

For a load balancer service to work, it needs to configure both load balancer and kubernetes cluster. The load balancer provided by cloud providers are already configured for such use cases. This is why, this service only works in cloud.

<!-- Deployment object will then remove pods from the current replica and use the previous replica to deploy new pods using Rolling Update Strategy. You can verify this by running `kubectl get replicasets.apps` command before and after the rollback.

have 2 replica sets A and B. You created replica set A

When we run this command `kubectl apply -f podconfiguration.yml`, a new pod will be created and deployed in one of the nodes. But this pod will not be managed by replica set. So, even if this pod fails in the future, we will not know anything.

Replica set will maintain the replica number number of pods with old image when we deployed it for the first time.

Another way to deploy the new pod is without messing with replica set. We can create configuration file for the pod `pod.yaml` and run the following command to deploy it.

So, although we can deploy the new pod with update image, we cannot delete existing pods.

one after another. Even if we manage to somehow deploy a new pod before replica set does, how do we configure replicaset to manage that newly created pod ? Replica Set has no idea about this newly create pod.

One solution might be to deploy a new pod with the same label as other pods deployed by replica set. If we could do this, replica set would take the new pod into consideration. We can depl

The conclusion is, Kubernetes will not modify the existing container.

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

<!-- ### Which is faster? Swarm or Kubernetes

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

There is a `default` namespace in kubernetes. If you donot create any other namespace, all your resources will run in default namespace. You can get all the namespaces using `kubectl get namespaces`. By default, kubernetes hides a lot of process that's running in the background. It does so by running those process in different namespace. To see all the processes in all namespaces, run `kubectl get all --all-namespaces` -->
