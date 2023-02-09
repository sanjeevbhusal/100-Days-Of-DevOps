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
There are many distributions of kubernetes which are essentially extra features on top of the open source kubernetes version.

### How do you use Kubernetes

Kubernetes exposes APIs/CLI that can be used to manage containers.

### How do you install Kubernetes

You can install kubernetes on your local machine directly from Github's Repository. You can also install kubernetes provided by other vendors such as Rancher, Openshift, Vmware or cloud companies.

You should prefer to use vendors provided options rather that using the raw github's option. This is because you need to configure kubernetes with additional configurations, plugins etc to really make the best of it. With vendor specific version, a lot of these configurations are simplified.
