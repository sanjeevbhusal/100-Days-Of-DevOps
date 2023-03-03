
We can deploy a single container through docker using the following command

```shell
docker run -d -p 80:80 nginx
```

 Lets say our application is growing and now we need more than one instance of the container. We can do this by running the same command again. Now, we need to set some kind of load balancer to sit infront of the instance. we then register both the instances to the load balancer. Now, all our user requests shoudl be sent to load balancer which automatically forwards them to one of the underlying instance.  Lets assume that user load has incerased and 2 instances are not enough. We then have to run the command again to deploy more instances and register them to load balancer. 
 
 Lets assume that the load is still increasing and we need to deploy at least 2 new instances of the container. We also realize that we have used all our hardware resource and can't deploy a new container on the same machine. In such scenario, we will first create a new virtual machine and install docker on it. We will then pull the image and run the command twice to run 2 containers. We will then register both the containers with the load balancer. 

 Lets assume for some reason our new virtual machine has failed. This means both the containers running on the new instance have also failed. This creates 2 problems. 
 
 - The load balancer will still send request to the failed containers as we have not removed the containers from load balancer.
 - Lets assume that the load balancer is smart enough to figure out that 2 containers have failed and de-registers those instances on its own.  Now there are only 2 containers(from the first machine) registered to the load balancer. So, all of the traffic will be forwarded to those 2 containers.

We can solve this issue if we can automatically detect if any of our containers or virtual machine has failed. We can then deregister failed containers from load balancer, run new containers on the same virtual machine or new virtual machine and finally register new containers to load balancer.  Having someone continuous monitor all the virtual machines and containers can help us detect the issue. But if there are 1000's of containers across 100's of host, doing it manually is impossible. 

We could do these by creating some kind of script that monitors the containers and notifies us if containers become unresponsive. This will allow us to remove unresponsible containers, de-register them from load balancer, run new containers as replacmenets and register them to load balancer. The script should also monitor if load has increased on the containers and notify us. This will allow us to run new containers and register them to load balancer.

This is precisely what container orchestration does. We can do these with either Docker Swarm or Kubernetes. 

### Docker Swarm

In Docker Swarm, we can manage multiple virtual machines together as a cluster. The only requirement is that all the virtual machines must have docker installed. From this cluster of machines, we need to make one of the virtual machine as manager. This manager machine will manage the deployments of containers across all other machines. All the other machines are also known as worker nodes or slaves. The key component of docker swarm is service.

Service is one or more instances of a container running on one or more hosts. Service will let us run multiple replicas of a container that are distibuted across all the worker nodes. Service will provide us a single endpoint to acess all the containers. This means service also acts as a load balancer. If one of the instance fails, service will automatically run another instance as replacement. As service is acting as a load balancer, we need to de-register the failed instance from the service(so that it doesnot receive any traffic) and register the new instance to the service (so that it receives traffic). We dont need to do this manually as this is done automatically by Service.

We can create a service with this command

```shell
docker service create --replicas=5 my-web-server
```

We can update the number of replicas of a service with this command

```shell
docker service update --replicas=10 my-web-server
```


Having a single manager node is not recommended. If it goes down, you can no longer manage the cluster. So, you should have multiple manager nodes.
However, this might also cause conflicts. If a manager node updates something in worker node, the information has to be propagated to all the manager nodes. If propagating information takes time, and in between you also updated same worker node through another master node, this will result in conflicts. To prevent this, swarm only allows one manager node to manage the cluster at any given time. This manager node is called `Leader`.

However, Leader cant make a decision on its own. The decision has to be agreed by all the manager nodes or atleast majority of the manager nodes. This is important so that all manager nodes are aware of the decision taken by leader node. Example: If a leader node added a new worker node in the cluster and failed to inform other manager nodes for whatever reason, other manager node would be unaware of the new worker node. If any of the manager node had to deploy a new container, they would not take this new node into consideration. This mechanism of accepting a certain change by multiple entities is known as `Distributed Consesnsus Mechanism`. 

Docker uses `RAFT consensus algorithm` to manage distributed consensus mechanism. The consensus algorithm does the following
- decide who among the master nodes will be the Leader node. 
- making sure Leader node has enough votes from master nodes to make any decision.
- making sure the state change information is propagated to all master nodes.

Docker uses a database called `RAFT Database` to store all the information about the cluster. This includes information about worker nodes, manager nodes, leader nodes etc. All manager nodes have a copy of RAFT Database. This database is distributed meaning, any updates to database is performed on all the copies of database. This ensures that all manager nodes have the same state of the cluster.

If the Leader had to add a new worker node to the cluster, it will send a notification to all the worker nodes. Worker nodes will then respond to the notification by either accepting the change or rejecting the change. If `Quorum` is met, then the leader adds the new worker to the cluster.  It then updates its own Database as well as all other distributed databases stored by managers.  

Master nodes will always accept the change. In case master node goes down and doesnot respond to the leaders notification, leader consideres that the master node has rejected the changes.  You can add as many manager nodes as you want but docker only recommends upto 7 manager nodes. 

#### Quorum

Quorum is defined as the minimum number of participants required to take a certain decision. In case of docker swarm, quorum will be the minimum number of manager nodes that have to stay alive for the cluster to stay alive. 

In case of proposing the leaders change, quorum will be the minimum number of manager nodes that has to approve the changes proposed by Leader Node.  If Quorum is not met, the cluster fails. 

The formula to calculate Quorum is (N / 2) + 1  .  Example: If there are a total of 6 manager nodes in the cluster, Quorum will be `(6 / 2) + 1  = 3.5`  . The decimal is ignored. So, the required Quorum is 3.   

![[Pasted image 20230302155255.png | 600]]


#### Selecting Odd Number of Master Nodes

Docker recommends to select odd number of master nodes while designing the cluster.  There are mainly 2 reasons for this. Both have to do with making cluster more fault tolerant. 

**First Reason** : Lets say you choose total managers to be 4. According to Quorum you at least need 3 nodes to run this cluster. This means the fault tolerance is only 1 node. In case you select 5 manager nodes, you still need only 3 nodes to run the cluster. This means the fault tolerance is 2 nodes.  Hence, choosing 5 over 4 manager nodes increased the fault tolerance by 1 without increasing number of nodes needed to run the cluster.

**Second Reason**: For some reason, lets say the manager nodes got divided in 2 seperate networks. If we had 4 manager nodes, then each network will get 2 nodes each. As the minimum node required is 3, neither of the networks fulfill the criteria causing the cluster to go down. In case we had 5 manager nodes, then one network will get 2 node and another will get 3 node. The network with 2 nodes doesnot met the minimum node but the network with 3 nodes mets the minimum node criteria. This ensures that the cluster doesnot fail.


#### What happens when the cluster fails due to not meeting Quorum 

If there are not enough manager nodes to met the `Quorum`, then there wont be any kind of management tasks on the cluster. Some of the management tasks includes adding new worker nodes to the cluster, deploying new containers in worker nodes, preforming some configurations to worker nodes etc. However all the running Services, containers in worker nodes etc still run perfectly. 

Failing of cluster doesnot mean that our application is down. It just means that we wont be able to perform administrative/management tasks. 


#### Recovering from a failed cluster

The only way to recover from the failed cluster is to fix the broken manager nodes. If we manage to start broken manager nodes, then the cluster will met its `Quorum` and the cluster is healthy again. You might think that we can remove the existing manager nodes and add new manager nodes. This is not possible since every decision has to be approved by other manager nodes till `Quorum` is met.  We wont be able to met Quorum since the required number of manager nodes are not online.

There is however another way to recover from the failed cluster state. But this approach completely removes the current cluster and creates a new cluster. All the manager nodes that were running in failed cluster wil be part of this new cluster. All the worker nodes, containers and services that were running in failed cluster will also be part of this cluster. The information about the broken cluster is still intact as the raft database which held the information about the cluster was present with all the master nodes. Since all the master nodes didn't fail the database is still intact. Now we can add more manager nodes to the cluster or promote existing worker nodes to be manager nodes.  

We can use the following command to form a new cluster that includes information about existing cluster

```shell
docker cluster init --force-new-cluster
```

We can use the following command to promote a worker node to master node

```shell
docker node promote [nodeId]
```


#### Using master nodes as worker nodes

Although master nodes primary use case is monitoring/administion of worker nodes, we can use them as worker nodes as well. This means we can deploy containers, services etc to master nodes as well. However Docker recommends to only use master nodes for administrative/moinitoring purposes. 

By default, swarm includes manager nodes in the list of worker nodes. To disable this behaviour, run the following command

```shell
docker node update --availability drain [managerNodeId]
```

### Kubernetes

Kubernetes has all the features of docker swarm and some other features which makes it more powerful than docker swarm in a lot of scenarios. Kuberenets also has a master node and worker node concept. Master node watches the worker nodes and makes sure everything is working properly.  

kubernetes is made up of multiple components. Some of the major components are API server, Kubelet service, etcd database,  Container Runtime, Controllers, schedulers etc

- API server: It acts as a frontend for interacting with Kubernetes. All web applications, command line interface etc all communicate with API server to access kubernetes.
- Kubelet service: It is a agent that runs in the worker nodes. It is responsible to run containers on the worker node (when assigned by master node) and communicate their health information with master node.
- etcd database: This database stores all the information about workers, containers etc. This is a distributed database i.e. it is available to all master nodes. This ensures consistent data between master nodes.
- Container Runtime: This is used to run containers. Some of the container runtime are docker, Crio, etc
- Schedulers: Schedulers look for new containers to run and assign them to multiple worker nodes.
- Controller: Controller are brain of kubernetes. They are responsible for identifying that everything is working properly. In case they detect some problem, they take appropriate steps to resolve a problem. 

Not all nodes require all the components. Master node requires Control plane components to manage worker nodes.



**Kubectl** is a command line utility that can be used to interact with Kubernetes and get information regarding containers, nodes etc. 

In order to run a container in kubernetes cluster, run this command

```shell
kubectl run my-web-server
```

In order to get information about the cluster, run this command

```shell
kubectl cluster-info
```

In order to get all the nodes information, run this commad

```shell
kubectl get nodes
```


In order to run 1000 instances of a application, run this command

```shell
kubectl run --replicas=1000 my-web-server
```

You can scale this number with this command

```shell
kubectl scale --replicas=2000 my-web-server
```

You can also let kubernetes automatically create new containers based upon load i.e. Auto Scaling. This feature is not present in Docker Swarm. 

Lets say you have 2000 instances of your container running. You have released a new version of your application and want to replace all 2000 instances. You can do this by scaling down the current instances to 0. Then you can scale it up again to 2000 with a new image. 

```shell
kubectl scale --replicas=0 my-web-server
kubectl run --replicas=2000 my-web-server:2.0
```

Kubernetes also has a feature called rolling-update. This will delete one of your existing containers and replace it with a new container from a different image. This way you dont need to delete all the containers before updating with a new one.

```shell
kubectl rolling-update my-web-server --image=my-web-server:2.0
```

You can always rollback to your previous version if anything goes wrong

```shell
kubectl rolling-update my-web-server --rollback
```

You also have the option of only updating few containers to the new version. This can be useful if you are only deploying new features in a certain region.



### What happens when docker swarm initiates a service

Lets say we want to create a service to run 3 instances of nginx web server.  We have 4 virtual machines / host in out swarm cluster. One of them is a manager and rest are worker nodes. In order to create a service, we run the following command

```shell
docker service create --replicas=3 nginx
```

Docker swarm has 2 major components running on the manager node. 

- Orchestrator 
- Scheduler

Orchestrator decides how many new containers should be created in order to met the desired state defined for the service. In this case, the desired state is 3 containers. As we have just started the service, there are no running containers. 

Scheduler then schedules the containers on all the worker nodes.  Scheduler tries to distibute containers equally in all the worker nodes. In this case, we have 3 worker nodes and scheduler needs to schedule 3 containers. So, the best way to equally distribute containers is to schedule 1 container for each worker node. 


Docker swarm has a component that is responsible for running and monitoring containers on worker nodes. Thiis component is called Task. 

Task is a process that runs on worker nodes. Its job is to run the container and monitor its behaviour. Task communicates with manger node about the status of the container. A task has a one to one relationship with a container. This means that for each container, there exists a Task. This taks was responsible for starting the container and now is responsible for monitoring container and sending its logs to master nodes.

Above, I said that scheduler schedules containers to worker nodes. This is not true and was mentioned just for simplicity. Actually, the scheduler schedules a Task to the worker node. This task has all the information on how to start the container.  In case a container fails, the task associated with it also fails. The manager node no longer receives information about the failed container from its associated task. Manager node detects this and replaces the failed task with a new task. This new task then starts the new container. 

> [!info] 
> As Task and container are used Interchangebly, going Forward we will refer TASK as container for simplicity purposes

![[Pasted image 20230302220037.png | 600]]


#### What happens if there are more containers compared to worker nodes available

In such cases, scheduler will schedule multiple containers in a single node. Scheduler will make sure that all containers are distributed to worker nodes in a equal fashion.  

#### What happens if one of the worker node fails

If one of the worker node fails, then all the tasks running on the node also fails. manager node detects this failure and will identifies all the containers running on that node through its RAFT database.  Orchestrator then calculates the number of new containers that should be started to met the desired state.  Scheduler then schedules new containers in the available worker nodes while making sure containers are distributed across all nodes in equal fashion  . 

### Types of Services

There are 2 types of services available in docker swarm. 
- Replicated
- Global

#### Replicated

In Repliated service, we specify the total number of replicas that should be running at any given point without taking number of hosts avaiable into consideraion. Example: We might want to run a web server with 5 replicas. We dont care if we have 2 worker node or 20 worker nodes. This means if one of the web server goes down we should create a replacement of that webserver in one of the worker nodes. 

```shell
docker service create --replicas=3 my-web-server
```

#### Global

In Global service, we specify total number of container that should be running on all the worker nodes. Example: We might want to run a single instance of a antivirus application in all the worker node available. This means if one of the worker node goes down, we dont replace the antivirus container by creating a replacement in another node. But if the antivirus container goes down, we have to try to recreate the container in the same node. Another example of such service could be a monitoring application that collects logs of each worker nodes.

```shell
docker service create --mode global my-monitoring-agent
```

All the 

When we create a service with command `docker service create --replicas=3 nginx`, 3 nginx containers are deployed in the worker nodes. We can see the output using command `docker service ps`.  This doesnot displays the information about the container. Instead, it shows the information about Tasks. This makes sense as manager node assigns Task to the worker nodes. Inside worker node, if you run `docker ps`, you will see the information of container. You can verify this by looking at the name of the container. The name of the container will be in the format of `[TaskName].[TaskId]`

### Swarm networking

There are 3 kinds of network available in docker. 
- bridge network
- host network
- null network

We have already discussed swarm networking in detail [[Docker networking|previously]]  However here is the quick introduction about all 3 networks. 

The bridge network has a Private Internal IP address of `172.17.0.1/16`. When we deploy containers in the bridge network, they are assigned a internal IP address from this range. The containers are accessible through their Internal IP address from the host machine. However, as the containers are not running on the host network, they cannot be accessed through host network. This means the container can only be accessed if the request was made from the host machine itself. To make container accessbile to other users over Internet, we need to map the container to a host port. This way any request coming to a specific port in host machine will be forwarded to internal IP of container. 

Host network doesnot have a internal IP address. When we deploy containers in host network, they are not assigned any IP address. This is because unlike bridge network, host network doesnot have a IP address associated with it. So, containers deployed in host network also dont get any IP address.  This means you cannot access the container through its internal private IP address as you did with containers deploed in bridge network.  The continers are however accessible through the IP address of host machine itself. This is possible because host network deployes containers directly to host machines IP address. So, if the container was deployed on port 3000, it will be accessible on host machine's port 3000.

Null network doesnot have any IP address. When we deploy containers in the null network, they are not assigned any IP address.  This is because unlike bridge network, null network doesnot have a IP address associated with it. So, containers deployed in null network also dont get any IP address. This is similar to host network. But unlike host network, containers are not deployed to host's IP address. Because containers donot have their own internal IP address and they are also not deployed to the host IP, they cannot be accessed at all. However, containers will still be functioning and will perform the task assigned to it. Some of the task includes running a certain script once in a while, doing some monitoring and writing logs to a file etc.

In production environment, we deploy containers containing different kinds of application. These are some of the applications we will deploy in production

- Web server: This container will run a web server such as nginx.
- Frontend: This continer will run frontend application built with technologies such as React, Vue etc. 
- Backend: This container will run backend application built with technologies such as Node, Python etc.
- Database: This container will run database application built with technologies such as MySQL, PostgreSQL, MongoDB etc. 

This is how the data flow of the containers looks like.

- Users: The users will send their request to web serve container through a DNS name mapped to the  web server
- Web server: The web server will act as a reverse proxy to forward requests to Frontend container. 
- Frontend: The frontend container will process the request and sends back a static files such as html, css, javasscript, images etc. Frontend might communicate with backend application when request comes to some specific routes such as loading user account information.
- Backend: The backend container will process the request and sends back response to frontend. Backend will comuunicate with database to fetch informaton regarding users, posts etc.
- Database: The database container will process the query and sends back the response to backend.

Lets assume that we have 4 worker nodes in our cluster. We deploy each container in their respective hosts. So, web server container gets deployed to node 1, frontend to node 2, backend to node 3 and database to node 4. Based on our above discussion of data flow, lets see which network will be best to facilitate this data flow.

- Null network: Lets say all 4 containers are running on null network in their respective host/node. The containers cannot be reached through their host's IP address. So, comunication between containers is not possible.
- Bridge network: Lets say all 4 containers are running on bridge network in their respective host/node. The containers have a internal IP address associated with them. However we cannot access a container from its Internal IP address as it is not avaialble on Internet. So, we map the internal IP address of the all the containers with one of the Port of their respective host machines. Example: We map web server running on Internal IP `172.17.0.2` to port `80`  on host's IP. This way all containers can communicate with each other.
- Host network: Lets say all 4 containers are running on host network in their respective host/node. The containers donot have a internal IP address associated with them. However we can access a container from its Host machines IP address. Example: We run a web65.0.109.52 server on host's public IP `13.127.170.21` on port `80`. This way all containers can communicate with each other.

So, by above discussion, we are left with Bridge network and Host network. However neither bridge nor host network are perfect. Both have some problems as discussed below.

#### Problems with Bridge network and Host network

In the above discussed architecture, a container is accessing another container through its host IP address. Web server container is accessing frontend container by sending request to a specific port in frontend containers IP address. Now, lets assume the host running frontend container goes down. Web server container will no longer be able to reach frontend container. The entire data flow of the application is affected. So, our application has effectively broken. 

The next move will be to quickly start a new host and run a new instance of frontend container in that host. This will fix the data flow in some sense as frontend container is now able to reach backend container. But our application will still be broken. This is because web server is still sending request to host running original frontend container(a host that is broken). To completely fix the application, we need to configure web server to send request to new host machine.

#### Solution: DNS name to the rescue

You might think you can fix this by using dns name for container instead of using IP address. This way if a container goes down, we can create a new container and assign the same DNS name as previous container. Swarm server will then automatically update the DNS routing table. This approach works and this is what you should do. But you have one last problem

#### Problem with DNS name

We should remeber that DNS server is specific to a network. DNS name can only be resolved if the container accessing DNS name and the container with the DNS name both fall in the same network. When a container A sends request to container B using DNS name of container B, DNS server of container A looks to resolve that DNS name in its network. As we are running all 4 containers in different hosts with different network, DNS server wont be able to resolve DNS name. 

#### Idea to solve DNS issue

By now, we have understood that accessing a container through its IP address is not a good idea. We should instead use DNS name to access the container. But as discussed above, we still have the different network problem that is preventing us to use DNS name. So, instead of creating individual networks for all the hosts, if we create a network that spans across the entire cluster, we will be able to resolve DNS name of any container. There will be a single DNS server that has the information about all the containers in the network.  

#### Swarm implementation for creating network that spans entire cluster

In order to create a new network that span entire cluster, swam introduces a new driver called `overlay`. Using this driver you can create a network that spans the entire cluster. The following code snippet creates a overlay network

```shell
docker network create --driver overlay --subnet 10.0.9.0/24 my-overlay-network
``` 


### Ingress Network

Lets say you have a swarm cluster with 1 single node. You want to run a nginx web server and make it avaiable to end users by mapping its port to port 80 on host. This is the command you will run

```shell
docker service create --replicas=2 -p 80:80 nginx
```

This will create a service which will run 2 replicas of nginx container in all the worker nodes. Since there is a single worker node, it will create both containers in the single node. The first container is created succefully and is also mapped to port 80 on the host. When swarm creates another container and tries to map it to port 80 on host, the mapping will be rejected. 

This is because you can map one port to only one container. To solve this issue, swarm creates a different kind of network called `Ingress`. Swarm actually maps this network to port 80 of the host. This means all the traffic coming to port 80 goes to this network. This network then redirects the traffic to one of the nginx containers. So, nginx containers are actually registered with this network instead of registering with host port. This network also acts as a load balancer to balancer load across all the registered containers. 

This entire process is done automatically by swarm with no extra efforts from the user.

![[Pasted image 20230303120914.png | 600]]

#### Mesh Benahviour of Ingress

Lets say you have a swarm cluster of 3 worker nodes. You run the following command to deploy 2 instances of nginx webserver in you cluster.

```shell
docker service create --replicas=2 -p 80:80 nginx
```

Swarm will deploy 2 instances of nginx in 2 different worker nodes (say worker node 1 and worker node 2). Now, in order to access the application, you can visit port 80 of worker node 1 or worker node 2. But if you visit port 80 of worker node 3, the application can still be accessed. This behaviour seems weird as no any containers are running in node 3.

This behaviour of docker swarm is possible due to the Mesh property of Ingress network. As we know, Ingress network spans across the entire cluster. When we publish a port, ingress network is actually the one that is listening on the port and containers are just attached to the ingress network. The traffic comes to ingress network which then gets forwarded to the containers with the help of builtin load balancer of ingress network. This load balancer has information about all the nodes in the cluster rather than nodes in the current host. 

So, when traffic comes to the service at node 3, the load balancer present in the service will forward the request to one of the containers in the cluster. This container could be in the current node or any other node in the cluster.  This allows users to access application using any of the node.

The DNS server that resolves the name always listens on `127.0.0.11`

![[Pasted image 20230303141600.png | 600]]

### Docker  stack

Docker stack is a group of interrelated services that together form a entire application. We could have 4 servies representing webserver, frontend application, backend application and database. These all services work together to make up a entire applicaton. 

##### Deploying a stack

We know that docker-compose.yml file is used to deploy multiple docker containers. We can actually use the same file to deploy multiple services as well. We can specify all sorts of details such as replicas, container's resource limitation , containers host preference etc.  We can then use the following command to deploy all the services.

```shell
docker stack deploy docker-compose.yml
```
