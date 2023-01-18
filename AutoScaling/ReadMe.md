# Auto Scaling

Auto Scaling is a concept used in deploying the application. Auto Scaling automatically adds or removes servers based upon the traffic.

<br>

## What triggers autoscaling ?

We can determine multiple factors which will be responsible for either adding or removing servers.

Some of the factors are :

- Increased Load: Whenever the incoming traffic increases, we should increase the server quantity and vice-versa.
- Network load: If we are sending/receiving a lot of network packets, we can increase the server quantity and vice-versa.
- CPU usage: If the servers CPU usage goes beyond a certain threshold, we can increase the server quantity and vice-versa.

<br>

## Benefits of Auto Scaling

The biggest benfit of auto scaling is scaling servers up and down based upon demand automatically. If a user had to do it manually, then a user has to constantly check the total traffic, CPU usage, Network Usage etc to decide if they should add or remove server.
A user also has to manually configure a server. This process will take a long time. This would affect user experience.

<hr>
<br>

# Intresting Questions

### How does auto scaling knows how to start and configure new server?

We have to tell auto scaling about how to spin up a new server. We should provide every information such as hardware/software configuration of this new virtual machine, commands to perform to install and configure the application etc.

### How does this new server receive traffic?

This server doesnot receive any request just yet. For that, we have to attach this server to a Load Balancer.

We can configure auto scaling to attach the server to a load balancer.

<br>

# Explain Auto Scaling with example

First, we set up autoscaling software and configure rules that determines how we should add /remove servers.

Then we tell auto scaling group about how to spin up a new server. We should provide every information such as hardware/software configuration of this new virtual machine, commands to perform to install and configure the application etc.

Then whenever any of the conditions meets, auto scaling group will spin up a new server. However,
