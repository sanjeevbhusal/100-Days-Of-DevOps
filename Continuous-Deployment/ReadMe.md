# Note

**This documetation refereneces some concepts discussed in [Deployment Automation](../devops-overview/notes/pillar-2.md)**.

<br>

# Continuous Deployment

Continuous Deployment is a way of deploying your application faster.

If you use Continuous Deployment, you will be deploying your application directly from a script instead of manual human work.

Continuous Deployment falls under 2nd Pillar of DevOps Enginner i.e. Deployment Automation.

<br>

## Ways of Deploying the application

You can either deploy your product manually or use a script that deploys your applicaton.

<br>

## Where do you write the script ?

We write the code to deploy our application in the same script we used to perform Continuous Integration. Combiningly it is called CI/CD script/pipeline.

<br>

## Benefits of Continuous Deployment

Continuous Deployment has few benefits such as:

- Deployment becones faster. We are running a script which automates deployment instead of doing all the steps manually.
- Deployment becomes error-free. We are doing same process again and again for deployment. Humans might miss some step or do some misconfiguration accidently.
- We can make scripts which deploy in multiple environments such as testing and production.

<br>

<br>

# Some Intresting Questions

### How Application are deployed after being developed?

Whenever you deploy your project, you generally have 2 Options. Either deploy your Project in your local data center or deploy your project using Cloud Providers.

Either way, you will create Virtual Machines to utilize your hardware resource in the best way. In the Virtual Machine, you can either deploy your application directly on the Virtual Machine or you will use Container Technologies to pack your application into a container and deploy that container.

<br>

### Which kind of deployment strategy we use with Continuous Development ?

We can use any kind of deployment strategy with continuous deployment. Of course, the script will differ for different deployment strategies.
