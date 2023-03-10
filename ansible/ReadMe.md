Ansible is a tool that helps you automate different IT task.
Ansible can be used to manage tasks on multiple servers.

If you have a application running in multiple macines and you want to update some software to all the machines, you could do that using ansible.

Other tasks such as Backups, system reboots, running some terminal commands etc can also be automated using ansible.

With Ansible,

- Instead of doing ssh into all the machines individually and performing commands manually , you can automate it through ansible.
- Instead of running multiple shell scripts and commands one by one, you can automate this process through a YAML file.
- If you want to create identical environments, you can use the same script in all the servers.
- It is more reliable and less prone to error.

Ansible supports all Operating system and all tasks including any IT/System Administration tasks.
Another advantage of ansible is that you dont need to install any softwares on the target machine. You only need to make necessary arrangements so that ansible can ssh into servers.

ansible works with modules. a module is a program that performs a very small task such as copying a file, installing a server, start a docker container etc.

ansible copies all the modules to the target machine and executes it. It then deletes the modules once the task is completed.

as module are very small, you will need a collection of modules grouped together in a certain sequence to perform a certain task.

a task is a group of modules aranged in a certain sequence. a module has a name, arguments and description.

![ansible playbook/task](./assets/ansible-playbook.png)

we should also specify the host and remote user to execute a task

![ansible playbook/task](./assets/ansible-playbook-host.png)

you can also define multiple variables inside ansible scripts and use them inside script.

the combination of which task, which host and which user formes a term called play. In a single YAML file, you can have multiple play, hence the file is also known as playbook.
![playbook image](./assets/playbook.png)

ansible has a file called hosts file. this file lists all the IP address of the server. The server are arranged in groups. We then refer to this group in a play. Tasks in a play gets executed in all the servers listed under the group.

You can either use IP addresses or DNS name to refer to the server. The server could be a database server, web server or any other server.

All the servers listed in this file are also called Inventory.

![ansible-inventory](./assets/ansible-inventory.png)

Ansible can manage both the application (dockerized/with-out dockerized) and host.

Ansible has a GUI interface called Ansible Tower created by Redhat. This interface is used to centrally locate all the automation tasks across all the teams, manage permissions to team members, manage inventory etc.

There are other alternatives of ansible such as Puppet or Chef.
ansible uses yaml syntax wheras puppet and chef use ruby.
ansible is agentless whereas puppet and chef require agent installtion on remote machine.

ansible is generally either installed on the local machine or is installed on one of the remote machines. if your servers are not connected to the internet and are in a private network, then you will need to install ansible in that same network. you would then manage this server through your local machine. the machine where you install ansible is called control node. control node will manage other servers known as managed nodes. managed nodes will need to install python to run ansible code.

Workflow

1. Create a hosts file and store the IP address of the servers.

   - The host file can be called anything you like.
   - You can categorize IP addresses in multiple groups.
   - You can also use domain name instead of IP addresses.

2. Specify the private key file to use for performing ssh into servers.

   - Each server might need a different ssh prvate key.
   - So, specify private key file path for each server.
   - The key to specify the file path is ansible_ssh_private_key_file=<filepath>

3. Specify the user to login to servers.

   - Each server might have different users configured.
   - So, specify user for each server.
   - The key to specify user is ansible_user=<username>

4. Use ansible cli to perform some commands on servers.

   - The pattern for command is `ansible -i [hostfile] [pattern] -m [module] -a "[module options]"`
   - `[hostfile]` means the file which contains inventory information.
   - `[pattern]` means the hosts against which command will be run.
     - You can either supply a single IP address or a group.
     - If you want to target all IP addresses, use `all`.
   - `[module]` refers to code files which perform a single task.
     - You can built your custom module or use prebuilt ones.
     - `ping` is a module which performs a ping command on the remote server.

5. Execution example.

   - The command used is `ansible all -i hosts.txt -m ping`.
   - Ansible will first search for a file called hosts.txt.
   - Then, ansible will identify the IP address to be targeted using pattern.
   - Then, ansible will search for a module called ping.
   - Then, ansible will ssh into the IP addresses and
     - find the python interpreter.
     - run the ping command code using interpreter.

6. Using variables to address redundency
   - Instead of using keys such as `ansible_ssh_private_key`, `ansible_user` etc for each hosts, you can create variables.
   - For a group called `ec2-instance`, you can create another group called `ec2-instance:vars`.
   - You can supply all the redundant variables in this group.

You can group inventory using their location such as region/avaiability zone etc, server-type such as database server, web server etc and type such as dev, test, prod etc.

In order to have communication between 2 servers, both server should give permission to each ohter. Giving permission means identifying the server you are trying to communicate with. When you perform ssh into a remote server, remote server needs to identify you and you also need to identify remote server. all this identification is done in a file called known_hosts located under ~/.ssh.

So, your physical machine needs to add the remote machine under ~/.ssh/known_hosts file to communicate with the remote machine. If you dont add the remote machine under known_hosts file, you will get a prompt while you try to ssh in the remote machine.

If you are trying to run the remote machine for a long time, you can simply perform a manual ssh and accept the prompt. This will add remote machine to kown_hosts. So, all other subsequent ssh wont require this prompt. So, you can run your automation script with ansible without any issues.

But if you are creating ephemeral/temporary servers for quick testing purposes, performing the manual ssh first will create a trouble. So, we need to somehow add the remote machine to known_hosts through automation first before we try to ssh.

The identification is not as simple as pasting the server's IP address inside known_hosts file. ssh uses a different format for indentifying known hosts. We need to use a cli tool called ssh-keyscan that comes bundled with ssh.

ssh-keyscan <Remote IP address> >> ~/.ssh/known_hosts

for authentication, ssh has a concept of public-private key. The remote server should have a public key under ~/.ssh/authorized_keys. The machine trying to ssh should send the private key. The remote machine will try to match the private key with the public key under ~/.ssh/authorized_keys.

You also have the option to login to your remote machine with password instead of ssh private-public key. But you have to authenticate yourself each time. So, in this case, you could generae a private-public ssh key on your host machine and copy public key to remote machine. This will allow you to use ssh without password. You can use a cli tool called ssh-copy-id

`ssh-copy-id [user]@[IP address]`

There is a option called `StrictHostKeyChecking` that you can use to ssh into a remote machine without adding it to known_hosts. This method is less secure but can be used when you are creating and destroying servers frequently.

ansible looks for a configuration file in one of 2 locations

- /etc/ansible/ansible.cfg
- ~/.ansible.cfg

In one of the files, you need to add the following

```vim
[defaults]
host_key_checking=False
```

You can also set this configuration based upon projects. In the directory where you execute ansible commands, create `ansible.cfg` file and paste the above contents.
5b47d40

When we create ansible playbook, we will use a different syntax to execute playbook.

The command is :

`ansible-playbook -i [host_file_path] [playbook_file_path]`

It will execute all the plays inside the playbook file.
Each play will always contain a default task called `Gathering Facts`. This task will verify if the server address is correct and also collect a lot of information regarding the server such as its Operating System, networking info etc.

a lot of modules inside ansible are idempotent. This means they will run if necessary. If a task specifies to install nginx, and if nginx is already installed, this task will not run.

Ansible has a conept of plugins. A plugin extends the functionality of ansible core or modules. You can create a plugin that extend the functionality of aws-ec2 module.

The combination of all the plugins, modules, documentation etc is called a collection. ansible has a builtin collection that includes a lot of builtin modules such as apt, yum etc.

all the collections are available on `ansible-galaxy` and you can install them using a cli called `ansible-galaxy`
