# Table of Contents

1. [Deployment Automation](#deployment-automation)

   - [multiple deployment strategies](#multiple-deployment-strategies)

     - [Green/Blue Deployment](#green-blue-deployment)
     - [Rainbow Deployment](#rainbow-deployment)
     - [Cannary Deployment](#cannary-deployment)

   - [Revert Strategies](#revert-strategies)

<br>

# Pillar 2: Deployment Automation <a name="deployment-automation"></a>

The main purpose of deployment automation is to simplify the deployment strategies to reduce error prone steps.

Using proper tools and configuring them to support our business needs, we can make sure that there is zero to very little custom code required for every deployment.

Deployment Automation consists of

- making multiple deployment strategies
- making revert strategies in case something goes wrong

<br>

## Making multiple deployment strategies <a name="multiple-deployment-strategies"></a>

Organizations use multiple deployment strategies to deploy their application.

The main factor that changes deployment strategies is the total users of the application.

Here are some of the deployment strategies organizations use

- Green/Blue Deployment
- Rainbow Deployment
- Canary Deployment

<br>

## Green/Blue Deployment <a name="green-blue-deployment"></a>

In this deployment, organizations keep 2 seperate clusters of servers. The same application is deployed in both clusters. These 2 clusters are called green and blue environments.

The difference is that both clusters contains different version of the application.

<br>

### Why 2 clusters are used ?

Using 2 clusters make deployment fairly easy.

One of the cluster is used in production wheras another cluster is used to deploy new version.

Whenever we deploy a new version of the application, we deploy it in the secondary cluster.

So, we end up with 2 clusters, one containing the old version (production server) and one containing the new version (upcoming production server).

<br>

### How does user routing works ?

All the user request goes to the web server. the web server routes the request to the current production cluster.

When we deploy a new version of the application in another cluster, we want that cluster to become the new production cluster.

So, we just change the route from the web server to instead go to the cluster containing new version.

<br>

### What about database ?

Both servers will connect to the same database.

This is because, even if we upgrade the version of the application, both version will use the same user data.

<br>

### Advantage of Blue / Green Deployment

- Very easy to understand and set up.
- There is almost neglible downtime while upgrading the application.

<hr>
<br>

## Rainbow Deployment <a name="rainbow-deployment"></a>

This is the extended version of Blue Green Deployment.

<br>

### So, what is the difference ?

Instead of only 2 clusters, we create multiple clusters.

Rainbow has 7 colors. In this scenario, rainbow represents multiple clusters.

<br>

### Why do we need more clusters ?

When we have more clusters we can deploy multiple version of our application at once.

One of the clusters will be used for production and other might be used for various scenarios.

### What kind of scenario might need multiple clusters ?

Lets say 1 cluster has the previous version of application and another cluster has the current version of application i.e. the production version.

If the production version has some issues, we want to fix that issue and deploy another version of application.

What if we dont want to remove the previous version for any reason ?

In such scenario, we would have to deploy the new version in the production cluster. For that, we need to shut the production cluster for some time untill we deploy the new version.

This will cause some downtime. Instead if we had other clusters available, we can solve this problem without causing downtime.

<br>

### Advantage over Blue / Green Deployment

- We have more clusters available. This can help in scenarios where we want to preserve the previous version of application but also want to deploy the new version without causing downtime.

<br>

### Disadvantage over Blue / Green Deployment

- More cluster means more cost.

<hr>
<br>

## Cannary Deployment <a name="cannary-deployment"></a>

We do cannary deplpyment to deploy our application to only few users.

<br>

### Why we deploy to only few users?

Deploying the application to only few users is done while we are still testing the application.

Whenever we create a new feature in the application, the feature might contain a lot of bugs.By deploying it to only few users, we aim to collect feedback to improve the feature.

<br>

### So, why not just release to all users and collect more feedback

Most of the user donot care about giving feedback. They just want the application bug free.

If we deploy the application to all users, we will receive a lot of complains as our feature might have a lot of bugs.

Its better not to add any feature to the application as compared to adding buggy feature.

So, we only deploy the application to few users, collect feedback, improve the application and release to all users.

This way, only few users experience isssues.

<br>

### How do we select the users to release the feature?

We can either create a signup form where intrested users will signup.

We can also release the application in a few specific countries.

<br>

### What does user gets from testing application and submitting feedback ?

The user gets to experience the feature before eveyone else.

We can also create a reward system to reward those users who submit feedback about the new feature.

<hr>
<br>

## Making revert strategies <a name="revert-strategies"></a>

We also need to make revert strategies in case something goes wrong with the application.

This applies to all kind of deployment strategies.

In case of Green/Blue and Rainbow Deployments, we always keep the old version of the application running in one of the clusters.

If new version experiences issues, we route users to old version. As both versions use the same database, we dont need to perform any database syncing.

In case of canary deployment, we want the user to report issues in the new version. But for some reason if the new version becomes really buggy, we can also perform blue green deployment i.e. route the user to old version.

Then we can fix the new version and again route those users to try new version.
