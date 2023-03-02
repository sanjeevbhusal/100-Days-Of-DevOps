
We can use docker volumes to persist data between a host machine and container. You can save data created inside the container in the host machine. this will make sure even if the container is deleted, the data is saved in host machine. You can then create a new container and then use the data saved in the host machine.  

When we create volumes, it is stored under `/var/lib/docker/volumes` .

There are 2 types of volumes
- Mounted Volume
- Bind Mounting

## Mounted Volume: 

We can mount a directory present in the host to another directory inside a container. This will let docker acess all the data present in the mounted directory of host machine. Whenever docker makes any changes to the mounted directory of container, the changes are actually made in the host machine. 

Lets create a volume and mount it in a mysql container
1. Lets create a volume with this command. This comand will create a volume inside `/var/lib/docker/volumes` directory. The volume will be called `mysql-data` .

	``` shell
	docker volume create mysql-data
	```

2. Lets run a mysql container and mount this volume inside the container. Mysql stores all its data in `/var/lib/mysql`. 
	```shell
	docker run --name mysql -v mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:latest
	```
	
	 By mounting `mysql-data` with `/var/lib/mysql` , we did the following
- Any data inside `/var/lib/docker/volumes/mysql-data` will be available to access inside containers `/var/lib/mysql`.
- When mysql container stores its data under `/var/lib/mysql`, it will actually be stored under host's `/var/lib/docker/volumes/mysql-data`. 

---

## Bind Mounting

We can mount a custom directory to another directory inside a container. In this case, we will not create any directory uder `/var/lib/docker/volumes`. Instead, we can use any directory we want from the host machine.  This kind of mounting is useful when you want to mount a host directory that is constantly being changed.  

Example: If you are using docker in development, then you would like to mount your project directory as a volume. This will make sure that the application running inside the docker uses your project directory as the source code. So, if you make any kind of change in your project directory, it is instantly reflected inside docker.  Lets consider you are developing a react application on your machine. You have created a Dockerfile to dockerize the application. You will then create a docker image and run the container. Your application is live. Lets say you want to make a change in one your files in your project directory. In order for that change to be reflected in docker container, you have to rebuild your image and rerun the container. With bound mounting, you can mount your project directory in the container and have your local changes reflect instantly in the container.  

Lets create bind mounting and mount it in a react app

1. Lets run the react application and mount the current directory under `/app` directory in container. We have created our Dockerfile to use `/app` directory as the project directory. So, all the commands such as `npm start`, `npm test` etc gets executed under `/app` directory.
	```shell
	docker run --name react-app -v .:/app my-react-app:latest
	```

	All the project files including dependencies in node_modules folder are now available under `/app` directory in container. So, when we execute `npm start`  in the container, our application will be started. 


Bind Mount can also be used if we like to store the data somewhere else other thatn `/var/lib/docker/volumes`. In this example, we are mounting mysql data under `/home/sanjeev/my-database-data/`

```shell
docker run --name mysql -v /home/sanjeev/my-database-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:latest
```

---

### Extra

Docker uses storage drivers to facilitate all these storage related operations.  To know more about Storage Drivers, click [[Docker Storage Drivers |here]].

---
![[docker-volume.png | 800]]