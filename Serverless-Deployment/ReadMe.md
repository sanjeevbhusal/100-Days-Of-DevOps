# Note

**This documetation builds upon concepts discussed in [Continuous Deployment](../Continuous-Deployment/)**.

<br>

# Serverless Deployment

Applications which are started and removed based upon certain trigger (request) can be deployed in a serverless manner. When you deploy your application using Serverless manner, you donot have to confgure any virtual machines.
When you send a request/trigger to your application, your application starts, process the request and gets destroyed.

<br>

### So, how is the application deployed if we donot rent Virtual Machines?

The cloud provider will deploy our application to the Virtual Machine of their like. We do not have any access to the virtual machine.

<br>

### Does the application always exist?

Our application doesnot exist untill a trigger.

<br>

### What kind of applications can be deployed to Serverless?

Applications which are very fast to start (100 ms) and are stateless (donot store any previous data) can be deployed on serverless.

These applications only have to exist whenever a request comes. Once the request is processed, applications can be destroyed.

<br>

# Working of Serverless with Example Application

We can deploy a web server in a serverless manner. The webserver doesnot have to exist untill a request comes. Once the request is processed, web server can be destroyed.

Or we could even deploy a notification service that sends notifications to a group of users. This service only has to stay active when a request comes.
