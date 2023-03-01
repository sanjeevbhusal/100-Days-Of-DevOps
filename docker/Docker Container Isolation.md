In docker, all the processes, network, etc are created within a namepsace. If a process wants to communicate with another process(interprocess communication), then both the processes should be within the same namespace.

Whenever linux boots up, it starts with a single process with a process ID 1. This process then spins up multiple child processes with process ID 2, 3, 4 etc. 2 processes cannot have same process ID.

We can view all of these process with command `ps aux`.


When we create a container, docker creates a sub system. This sub system has its own root process (Process with Id 1) and other processes that originates from root process. We know that containers use the underlying OS Kernel. This means the kernel has to know about the container and all the processes inside the container. This means there is no isolation between the host and docker containers. 

Whenever we run a process inside a container, we are actually running the process in the host OS. This process will have its own Process ID given by the host OS. Docker just takes this process and gives it a new Process ID. Docker does this through a concept called namespaces. With namespaces, a single process can have multiple process ID assigned to it. 

Docker then makes this process available inside the container. As this process is within a namespace, it can only acess those process available within the same namespace.


docker run nginx will start a nginx process in the host system. Lets say the process ID is 45398. The nginx process has also started other sub processes which are also running in the host OS. We can view this by running `px aux | grep nginx` command in the host. 

docker now creates a seperate system (container) and makes all these nginx processes available within the container. For this container to act completely isolated, it needs its own root process with a Process ID of 1. Docker will take the master nginx process and make it available in the container with a proccess Id of 1. By default, 2 processes cant have same Process ID. So, it is technically not possible to make this process available inside the container with a process ID of 1. This is because there already exists a root process with a process ID of 1 in the host system. And as all these nginx processes are managed by the host system, they need different process ID as discussed above (process ID 45398). To overcome this limitation, docker uses namespaces which allow to assign multiple process ID to a single process, even if there already exist other process with that processID.


As processes run directly on the host system and use all the host system resources, there is no limitation to how much memory, CPU these processes can take. However, docker has an option of limiting the resources a container takes. Docker uses a concept of `cgroups` to achieve this.


When we run nginx as a root process with process ID of 1, the container treats it as if no processes exists outside of it. This is the reason why any process inside docker container can only access process inside it. The container doesnot look outside of the root process.


![[docker-container-isolation.png | 1200]]