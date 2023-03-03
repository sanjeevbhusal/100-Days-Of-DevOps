Docker associates a container with one or more network. Each network has its own IP address just like a real network. Each network has a pool of IP address range allocated to it. When a container is assigned to a network, the container gets IP address from the IP address pool of the network.  By default, docker has 3 networks already created.

- bridge network
- host network
- null network

Lets see all the available docker networks on the system.

```shell
docker network ls
```

![[Pasted image 20230302073004.png]]

As you can see, we have 3 default networks on the system. Lets discuss about all 3 in detail.

## Bridge network

This is dockers default network. It is a interenal private network created on the host machine. This network gets a Internal IP address that is only reachable from the host.
The IP address of this network is `172.17.0.1`. If a container is not assigned a network when it is created, docker assigns it to bridge network. To access the container from outside, map port of the container to port on the host. The first container assigned to this network will get a IP address of `172.17.0.2`. All other containers will get subsequent IP address. The container running on the bridge network is not bind to host network automatically. So, inorder to access the container, you need to get its IP address. 

Lets see  a example of this network.

### Step 1 - Inspecting bridge network

As you can see above, the name of the bridge network is `bridge`. Lets inspect the network to see more details.

```shell
docker network inspect bridge
```

![[Pasted image 20230302073327.png|600]]

We can see many details of this network such as its Subnet, Gateway, configuration Options etc. Subnet determines its IP address. In this case, the subnet is `172.17.0.0/16`. This means all the containers on this network will have IP address within the range of `172.17.0.0` - `172.17.255.255` . The Gateway represents the IP address of the network itself.  

When you send a request to the IP address of the network `172.17.0.1`, it is actually being sent to the default gateway for the bridge network. Since the default gateway for the bridge network is set to the Docker host's IP address, the request is routed to the Docker host.  

No any containers are attached to this network. This is why `Contianers` option is empty. 

### Step 2 - Starting a container and inspecting it

Lets start a nginx container and see its configuration.

```shell
docker run -d nginx
```

![[Pasted image 20230302074144.png]]

We ran a nginx container named `nginx`. Now, if we inspect `bridge` network, we should see a container in the `container` section.  

```shell
docker network inspect bridge
```

![[Pasted image 20230302074404.png | 600]]

We can see a container with few properties such as `name`,  `MacAddress`, `Ipv4Address` etc. We can see that the container has a IP address of `172.17.0.2`. This IP address falls in the network's IP address pool as discussed above. 

Lets send a curl request to this IP address. As the container is listening on port 80, we should get a response back.

```shell
curl 127.17.0.2
```

![[Pasted image 20230302074724.png | 600]]

This proves that this container is accessible in `127.17.0.2` Internal IP address.  Now lets see more properties by inspecting the container.

```shell
docker container inspect nginx
```

The container will give a very huge output. Howerver, we are only intrested in the networking section. So, instead we can format the output with a `--format` flag. We will also use another command to preety print the outpur in terminal

```shell
docker inspect --format='{{json .NetworkSettings}}' nginx | jq .
```

![[Pasted image 20230302075226.png | 600]]

We can see multiple options such as Ports, IPAddress, Gateway etc. The Ports section specify which port is open in the container. As the container is a nginx container, port 80 is open by default. Networks section contains more details such as Gateway, Network ID, MacAddress etc. 

We can see a field called `bridge` under `Network`. That is the name of the network this container is connected to . As discussed above, a container can be connected to multiple networks. The Gateway is the container's network gateway, something we already discussed above. 


## Host Network

Host Network makes a docker container available directly to the host network. This means there is no Internal Docker network associated with Host network. You can acces the container directly through host machine's IP address. If a service is already listening to a port in host machine and your container is trying to listen to the same port, you will get an error.   

Lets see a example of this network. We will continue from above example where we already have a nginx container. 

### Step 1 - Inspecting  host network

Lets inspect the host network just like we did with bridge network

```shell
docker network inspect host 
```


![[Pasted image 20230302081049.png | 600]]


As you can see from the logs, there is no `Subnet` or `Gateway` option for this network type.  This is because all the containers in the network are listening directly on the host port. So, we dont need a Internal IP address to assign any container.

### Step 2 - Starting a container and inspecting it

Lets create a apache container and assign it to the host network

```shell
docker run --name apache --network=host -d httpd
```

![[Pasted image 20230302080543.png | 600]]

You will notice that `PORTS` section is empty for apache container. This is because the container is listening directly on host machine's port 80. So, it doesnot need to expose its own port just like nginx container does.  

Lets now inspect the host network and see what changed

```shell
docker network inspect host
```

![[Pasted image 20230302081336.png | 600]]


As you can see, we now have a container under `Containers` section. This container doesnot have `IPv4Address`, `MacAddress` etc. This is again because this container listens on host port and doesnot need its own IP.  

As we know that apache container always listens on port 80, lets send a request to hosts IP addreess on Port 80 using curl utility.

```shell
curl localhost
```

![[Pasted image 20230302081904.png | 600]]

this proves that we can reach container succesfully on port 80 of local machine. Now, lets inspect the container and see its properties and comapre it with nginx container. As the container gives very big output, we will use the `--format` flag as we did for nginx container. 

```shell
docker inspect --format='{{json .NetworkSettings}}' apache | jq .
```

![[Pasted image 20230302082204.png | 600]]

We can almost see all the options we did with nginx container. The difference is that  some of the options such as `Ports` , `IpAdress`, `MacAddress`  are empty. This is the expected behaviour for containers with host network. 
## Null Network