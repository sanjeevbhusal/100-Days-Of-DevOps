IAM stands for Identity Acess Management. It is used to provide access to aws resources for different users. groups and roles. 

There all a lot of resources available in aws (ec2, s3, eks, etc). All of these resources have different functionality. For example
- Ec2 resource is used to create/update/delete ec2 instances.
- s3 resource is used to view/store static content.
- eks resource is used to manage containers.

We will have different users in our organization that interact with these services in different manner.
- some users might just need to view and report ec2 instance status, 
- some users  might need to create a new instance
- some users might need to view s3 resources
- some users  might need to create s3 resources etc.  

To manage all the users and permissions to perform actions on a resource, IAM is used.

## IAM policies

All the resources avaialble on aws have different policies/permissions attached to them. When a user tries to access a aws resource, the resource first checks if the user has appropriate permissions to access the resource.

S3 bucket has different policies to limit the power of a user. 
- Policy to view the objects
- Policy to create the new object

If you want to interact with a certain functionlity of S3, then you need to have that policy. 

AWS has features to grant policies to a user, group and role.  

## IAM terminologies

You can create the following through IAM

- users
- groups 
- roles. 

You can then assign policies to either of these and manage permissions to aws resource.

## Users

Users are of 2 types
- human users
- sytem users

human users are users in your organization that needs to access aws resources. They could be 
- developers (to host their application in aws ec2)
- testers (to fetch docker image from aws ecr and run it locally for testing) etc.

system users include other applications that  needs to perform some actions on aws resources. They could be
- Jenkins (Jenkins might need to push a docker image to aws ecr)
- Terraform (Terraform might need to create the needed infrastrasture) etc 

You will create different users and assign them different permissions based on users needs.

## Groups

Groups are collection of users managed together.  If you have a lot of users perform similar tasks on aws, you will notice that a lot of Policies are shared among those users.  With Groups, you can create a group and add all the users in the group. Then you can assign policies directly to the group, instead of individual user.

# Roles

Roles are needed for one aws service to interact with another aws service. AWS has multiple services which can interact with other aws services as if they were acting on your behalf.  

You might configure one aws service to create a ec2 instance. For this to happen, the service needs the permission to create ec2 instance. You cannot assing Policies directly to services. Instead you will aassign role to a service and then assign policies to that role.  