# JOURNEY OF 100 DAYS OF DEVOPS AND CLOUD LEARNING

[![devops picture](./assets/images/devops-software-development-concept-179685898.jpg)](https://thumbs.dreamstime.com/b/devops-software-development-concept-179685898.jpg)

🚧 = On Progress

✔️ = Completed
<br>
<br>

| Resources Used                                                                                                            | Status of Completion |
| ------------------------------------------------------------------------------------------------------------------------- | -------------------- |
| [Devops Introduction Course](https://www.youtube.com/watch?v=j5Zsa_eOXeY&list=PLWKjhJtqVAbkzvvpY12KkfiIGso9A_Ixs&index=6) | 🚧                   |
|                                                                                                                           |

<!-- | [DevOps Bootcamp](https://www.techworld-with-nana.com/devops-bootcamp)                                                    | 🚧                   |
| [AWS Cloud Practioner](https://digitalcloud.training/aws-certified-cloud-practitioner/)                                   | 🚧                   |
| [VPC Detailed Course](https://www.youtube.com/watch?v=g2JOHLHh4rI&t=1802s)                                                | ✔️                   | -->

<br>

# Note

DevOps is a more theoretial as compared to programming. So, all these devops notes will just be a summary of my understanding of devops concepts.

I will include code snippets whenever necessary.

<hr>
<br>
<br>

## DevOps Introduction

DevOps is a methodology that helps engineering teams to build software by continuously integrating user feedback. DevOps as a term defines a way of building software. “DevOps Engineer” role includes tasks which involves a lot of automation, with the end goal being building high quality software faster.

<hr>
<br>

## DevOps at the Organization level

<br>

The entire process of building a software is broken down into multiple steps.

1. The stakeholders first decide upon the feature that needs to be built.
2. Developers build the feature
3. The entire code is built into artifacts (containers, mobile apps, binary executable
4. Those artifacts are tested either with Automatic Testing or Manual Testing through QA engineers or both approach.
5. Once the artifact is sure to be error free, then a release version (1.4) is created and a release document is prepared illustrating all the changes in this artifact
6. The release is then distributed (mobile applications are published to app store, containers are deployed to servers and other files are hosted)
7. Now the application have to be monitored for any code errors or any scaling problems
8. Based upon monitoring metrics, new servers might be added or if there are any issues with the code, appropriate personals are notified.

<br>

Finally, the monitoring metrics and user feedback are incorporated into making a new planning phase and all the steps happens again.

<hr>
<br>

## DevOps from the perspective of Engineer / three Pillars of DevOps Engineer

<br>

A personal with the title of “DevOps engineer” has very little to do with planning or coding and more to do with the 3 pillars :

- Pull Request Automation
- Deployment Automation
- Application Performance Monitoring Automation

The main purpose of a devops engineer is to incorporate practices that helps to ship high quality bug free software quickly.

<br>

## Pillar 1: Pull Request Automation

The main purpose of pull request automation is to make sure the proposed code gets merged as fast as possible.

## Pillar 2: Deployment Automation

The main purpose of deployment automation is to simplify the deployment strategies to reduce error prone steps.

Using proper tools and configuring them to support our business needs, we can make sure that there is zero to very little custom code required for every deployment.

## Pillar 3: Application Performance Management

The main purpose of application performance management is to make sure that the application is performing well in production.

<hr>
<br>

# Pillar 1: Pull Request Automation

Pull Request Automation consists of running automated tests, performing code review and conducting creating ephemeral environments.

## Running Automated tests

Automated tests are tests that runs whenever a new pull request is submitted.

### Why do we need automated tests?

Whenever a developer proposes a new change i.e. files a pull request, the new change might create some problem to existing code base.

So, we run automated tests on the new proposed change to make sure there arent any problems.

### What if the automated test fails?

If the test fails, the pull request gets rejected. The script will automatically notify the developer.

### What does this tests contain?

This tests are noting but unit/integration/end-to-end tests which are written to test the project's functionality.

### Can't we run these tests locally?

Yes, a developer can run all the tests in their local development environment first. If all the test passes, then they can submit a pull request.

However, we can't be sure if all developer will do that. So it is better to set up automated tests.

### What are other tests that we can do?

We can also set up linting, formatting and security checks.

By Setting Linting Checks, we can reject those changes which contain any linting errors.

By Setting Formatting Checks, we can reject those changes which donot follow the predefined format.

By Setting Security Checks, we can reject those changes which may potentially introduce security issues.

<hr>

<br>

## Code Review

Code Review is a process of reviewing someone elses code.

### Why is Code Review Done?

Code Review is done to make sure the new changes complies with standards set by the organization.

### When is Code Review Done?

It is generally done when a developer submits a pull request.

### Who does Code Review?

The person reviewing the code in pull request is called `Code Reviewer`.

### Who can be a Code Reviewer?

Code Reviewer is usually another developer who has the knowledge of the codebase which has been changed.

For Visual Changes, the code also has to be approved by the designer who made the design specification.

However, In large Organizations other individuals are also involved in code review, such as product manager/engineering managers who are charge of the functionlality.

Sometimes, management also has to approve the changes. However, management people cannot understand code, so we create ephimeral environments.

<hr>

## Ephemeral Environments

Ephemeral environment is a temporary environment created to interact with the changes in the pull request.

### Why do we need Ephemeral Environment?

Whenever we review a pull request, we can only see the changes occurred in the pull request. We cannot interact with the application.

To interact with the appliation, we need to pull down the changes and run the application in the local server.

So, instead whenever user submits a pull request, we build the application from the latest commit of the pull request.

### How does Ephemeral Environment help?

Ephemeral environments lets us interact with the application which is built from the changed code.

We can then share the URL of the ephemeral environment and let the code reviewer see the application.

This saves time for the developer as we no longer need any kind of meeting to showcase the latest changes.

This also helps non-technical people understand what our code change did to the application.

We can also have QA Engineers do manual testing in this ephemeral environment.

### When should we close the ephemeral environment?

There are mulitple strategies one can use. But generaly, ephemeral environments should be closed once the pull Request has been merged.

The code Reviewer checks the application in our ephimeral environment and when satisfied merges the pull request.

### Drawbacks of ephemeral environment

Creation of each ephemeral environment costs money.

So, if we are taking a lot of time to merge a pull request, then creation of ephemeral environment will increase the deployment cost of the company multiple times.

<!-- <br>

### What are the tasks that can be automated?

<br>

The main goal of a devops engineer working on pull request automation is to increase the speed of the review process, from the moment code gets pushed till code gets reviewed. Some of the automation functionality that can be built are:

- Automated test running with a CI Provider: This gives developer confidence that their code changes does not break any existing functionality.
- Per-Change Ephemeral Environment: Creation of Temporary Environments per code change helps interested parties interact with the proposed change and make sure it solves all the required business goals.
- Automated security scanning: This makes sure that the proposed change do not introduce any security vulnerabilities in the product.
- Notifications to reviewers: Automatic notifications to reviewers to notify them for code review so that the reviewers can quickly request new changes to the pull request.

<br> -->

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
