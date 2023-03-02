
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

Service will let us run multiple replicas of a container that are distibuted across all the worker nodes. Service will provide us a single endpoint to acess all the containers. This means service also acts as a load balancer. If one of the instance fails, service will automatically run another instance as replacement. As service is acting as a load balancer, we need to de-register the failed instance from the service(so that it doesnot receive any traffic) and register the new instance to the service (so that it receives traffic). We dont need to do this manually as this is done automatically by Service.

We can create a service with this command

```shell
docker service create --replicas=5 -p 8080:80 my-web-server
```


Having a single manager node is not recommended. If it goes down, you can no longer manage the cluster. So, you should have multiple manager nodes.
However, this might also cause conflicts. If a manager node updates something in worker node, the information has to be propagated to all the manager nodes. If propagating information takes time, and in between you also updated same worker node through another master node, this will result in conflicts. To prevent this, swarm only allows one manager node to manage the cluster at any given time. This manager node is called `Leader`.

However, Leader cant make a decision on its own. The decision has to be agreed by all the manager nodes or atleast majority of the manager nodes. This is important so that all manager nodes are aware of the decision taken by leader node. Example: If a leader node added a new worker node in the cluster and failed to inform other manager nodes for whatever reason, other manager node would be unaware of the new worker node. If any of the manager node had to deploy a new container, they would not take this new node into consideration. This mechanism of accepting a certain change by multiple entities is known as `Distributed Consesnsus Mechanism`. 

Docker uses `RAFT consensus algorithm` to manage distributed consensus mechanism. The consensus algorithm does the following
- decide who among the master nodes will be the Leader node. 
- making sure Leader node has enough votes from master nodes to make any decision.
- making sure the state change information is propagated to all master nodes.

Docker uses a database called `RAFT Database` to store all the information about the cluster. This includes information about worker nodes, manager nodes, leader nodes etc. All manager nodes have a copy of RAFT Database. This database is distributed meaning, any updates to database is performed on all the copies of database. This ensures that all manager nodes have the same state of the cluster.

If the Leader had to add a new worker node to the cluster, it will send a notification to all the worker nodes. Worker nodes will then respond to the notification by either accepting the change or rejecting the change. If `Quorum` is met, then the leader adds the new worker to the cluster.  It then updates its own Database as well as all other distributed databases stored by managers.  You can add as many manager nodes as you want but docker only recommends upto 7 manager nodes. 

#### Quorum

Quorum is defined as the minimum number of participants required to take a certain decision. In case of docker swarm, quorum will be the minimum number of manager nodes that have to approve the changes proposed by Leader Node.  The formula to calculate Quorum is (N + 1 / 2). 

Example: If there are a total of 6 manager nodes in the cluster, Quorum will be `(6 + 1 / 2 ) = 3.5`  . The decimal is ignored. So, the required Quorum is 3.   



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