
## Building a Image

Docker uses Layered Architecture to build a image.  A image is a combination of multiple layers. Each layer represents a change compared to previous layer. 

Consider this Docker file

```Dockerfile
FROM Ubuntu
RUN apt-get update && apt-get install python -y
RUN pip install flask flask-mysql
COPY . /opt/source-code
ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run
```

We can build this dockerfile with this command.

```shell
docker build -t my-app my-custom-app
```

We have 5 different commands in the Dockerfile. This translates to 5 different layer. Docker will build following layer

- Layer 1 (FROM Ubuntu): This layer will represent the change caused by installing Ubuntu Base Image
- Layer 2 (RUN apt-get update && apt-get install python -y):  This layer will represent all the changes caused by updating softwares and installing python.
- Layer 3 (RUN pip install flask flask-mysql):  This layer will represent all the changes caused by installing flask and flask-mysql. 
- Layer 4 (COPY . /opt/source-code):  This layer will represent all the changes caused by copying a directory from host machine to the image.
- Layer 5 (ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run):  This layer will represent all the changes caused by defining a entrypoint in image.


As each layer has different changes, the size of the layer also differs. In this case, here are the sizes of each layer.

- Layer 1 : 120 MB
- Layer 2 : 306 MB
- Layer 3 : 6.3 MB
- Layer 4 : 4 MB
- Layer 5 : 0 MB

If you make any kind of changes to the Dockerfile and rebuild it again, docker will use all the available cached layers to build the image.  Lets consider this updated Dockerfile

```Dockerfile
FROM Ubuntu
RUN apt-get update && apt-get install python -y
RUN pip install flask flask-mysql
COPY . /opt/source-code-2
ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run
```

In this Dockerfile, the only change we have is a new directory called source-code-2. Instead of creating a directory called source-code1 and moving our application in source-code1 directory, we created source-code-2 and moved our application in source-code2 directory.

We didnt change the first 3 commands and the last command in the Dockerfile. This means docker will be able to use the previously created layers to build this image. When we build this image, Docker will build following layer.

- Layer 1 (FROM Ubuntu): This layer will be used from Cache.
- Layer 2 (RUN apt-get update && apt-get install python -y): This layer will also be used from Cache.
- Layer 3 (RUN pip  install flask flask-mysql): This layer will also be used from Cache.
- Layer 4 (COPY . /opt/source-code-2): This layer will be built from scratch as docker donot have any cached layer created using this command.
- Layer 5 (ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run): This layer will also be rebuilt.

The second image will take very less size as a lot of layers are reused. If you see the size of the image through `docker image ls` command, you will see that both images take up massive size. This is because this size actually represents the size of all the layers this image is built upon. So, if you see size as 450 MB, this is the total size of all the layers this image is built upon. If you were to push this image, docker will push multiple layers which total size will be  450 MB.  So, this doesnot mean that this image is taking 450 MB size on disk.  If you run command `docker system df`, you can see the total size images are taking on your local system. You will realize the total size to be close to 450 MB. This means both the images are sharing multiple layers but when shown with `docker image ls` command, displays the entire image size. 
use `-v` flag with `docker system df` to see the breakdown.


Layer 5 will also be rebuilt although it has not changed. This is because docker builds all the subsequent layers after a layer has been changed.  Here layer no 4 was changed, so all the layers below it will be rebuilt. To view all the layers of a image, we can run the following command 

```shell
docker history [imageid]
```

![[docker-layered-architecture-image.png | 600]]



Once a Image is built, it cannot be edited. Images are read only files. But when we build a container through that image, we can make changes to that container. Lets understand container layered architecture.

---


## Building a Container

We build a container from a Image.  A Image can be used to create as many containers as we want. Docker guarentees that all the containers created from a Image will always be same. This means we cant edit a Image. When we create a container through a Image, we can do all sort of changes in the container. How is it possible that we can make changes to container but not affect the undelying Image.

When we build a container, we actually create a new layer on top of existing Image layer. Lets call this layer as container layer. This layer stores all the changes we make in the container.  If I want to make any changes to a file that is part of image, docker will copy the file and make it available in the container layer.  This makes sure that the file in the image is not affected.

In the above example, lets say I create a container from my docker image by running the following command

```shell
docker run -d my-custom-app
```


Lets say I want to try changing the source code inside the container and play around with it. When I change a file in the source code, docker will make a copy of that file available in the container layer. Further modfications of the file is done in container layer. This mechanism is known as `copy on write` mechanism.

When we delete the container,  docker will also delete the container layer.  To save the changes in the container layer, we can create a mounted volume and mount it to the container. 

![[docker-layered-architecture-container.png | 600]]