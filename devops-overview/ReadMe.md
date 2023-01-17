## Resources Used

### [Devops Introduction Course](https://www.youtube.com/watch?v=j5Zsa_eOXeY&list=PLWKjhJtqVAbkzvvpY12KkfiIGso9A_Ixs&index=6)

<hr>
<br>

## DevOps Introduction

<br>

DevOps is a methodology that helps engineering teams to build software by continuously integrating user feedback.

However, whenever a company says they need a "DevOps Engineer", it means they need someone who knows how to automate multiple steps of software development/deployment life cycle. The ultimate goal of a devops enginner is to help build high quality software **faster**.

<hr>
<br>

## DevOps at the Organization level

<br>

The entire process of building a software is broken down into multiple steps.

This step include taking requirements, making a plan, coding, testing, deployment, monitoring and feedback.

[Click here for detailed information](./notes/organization-level.md)

<hr>
<br>

## DevOps from the perspective of Engineer / three Pillars of DevOps Engineer

<br>

A personal with the title of “DevOps engineer” has very little to do with planning or coding.

The main purpose of a devops engineer is to incorporate practices that helps to ship high quality bug free software quickly.

They achieve this goal by using these 3 pillars :

- Pull Request Automation
- Deployment Automation
- Application Performance Monitoring Automation

[Click here for more information on Pillar 1 : Pull Request Automation](./notes/pillar-1.md)

[Click here for more information on Pillar 2 : Deployment Automation](./notes/pillar-2.md)

<hr>

<!-- ## Pillar 2: Deployment Automation

<br>
The main purpose of deployment automation is to simplify the deployment strategies to reduce error prone steps. Using proper tools and configuring them to support our business needs, we can make sure that there is zero to very little custom code required for every deployment.

<br>

### What are the tasks that can be automated?

<br>

- Cannary Deployment: Deploying a feature to only a certain set of users as a final test before rolling the feature to all the users.
- Blue/Green deployment: Starting a new version of a service without causing any downtime.
- Roll Back: Rolling back to previous version in case something goes wrong.

This step is particularly important as it is very easy to over complicate deployment. Companies have internal platforms to make complex deployments possible.

<br>

## Pillar 3: Application Performance Management

The main purpose of application performance management is to make sure that the application is performing well in production.

<br>

### What are the tasks that can be automated?

<br>

- Logging: We should log all the details of how a process is happening. This might include data like the source IP, time of the request, time taken to response, etc.
- Metrics: We should keep track of key numbers affecting our application in production. This includes average response time, time taken to process a certain task, finite resources such as Memory usage (RAM), Available Storage etc.
- Monitoring: By analyzing data from logging and metrics, we create health reports. Based on the health reports, we need to find out if the application is down, is performing slower, if all the features are working etc.
- Alerting: If monitoring detects a issue, associated personal should be notified automatically. In case of feature errors or performance issues, tickets are created automatically.

<br>

# Day 3 of 100 Days Of DevOps

## Does Every Product Follow all 3 Pillars of DevOps Engineering?

<br>

Not all products require all 3 pillars of devops engineering. Here is more detailed breakdown for 3 kinds of products.

**A new startup with no users**

The first pillar is needed as it speeds up the development time. They don’t require Pillar 2 and 3. This is because even if the application goes down, there are not much users to be affected. Users are less so we don’t need to worry about region specific deployment or downtime issues.

**Medium Organization which have few Enterprise Customers**

The first pillar is needed as it speeds up the development time. Some parts of Pillar 2 and 3 are also required. Enterprise users cannot afford any downtime with new versions of application (Pillar 2).

You also need to constantly monitor the application to make sure there are no performance issues as you have enterprise users and alert enterprise users if some problem occurs (Pillar 3).

**Large Organizations with millions of users**

These kind of organization have to worry about all 3 pillars of devops engineering.

<hr>
<br>

## Conclusion

<br>

DevOps engineering is absolutely crucial for a organization to ensure delivery of high quality applications. Without having a strong idea of all 3 pillars, your application might face multiple issues resulting in the end user being disappointed.

There is no fixed answer for whether you need 1, 2 or 3 pillars of devops engineering. Mostly, as the product’s size grows, you will feel the need for investing in DevOps Engineering. -->
