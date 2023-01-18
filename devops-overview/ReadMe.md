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

[Click here for more information on Pillar 3 : Application Performance Management](./notes/pillar-3.md)

<hr>
<br>

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

DevOps engineering is absolutely crucial for a organization to ensure delivery of high quality applications **faster**.

Without having a strong idea of all 3 pillars, your application might face multiple issues resulting in the end user being disappointed.

There is no fixed answer for whether you need 1, 2 or 3 pillars of devops engineering. Mostly, as the product’s size grows, you will feel the need for investing in DevOps Engineering.
