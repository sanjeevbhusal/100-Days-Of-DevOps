
Docker uses storage drivers to manage all sorts of storage functionalites such as copy on write mechanism, maintaining layered architecture, volumes etc.  Some of the common storage drivers are AUFS, ZFS, BTRFS etc.  Different storage drivers use different techniques to manage above mentioned functionalities. 

Docker by default uses the storage driver that best suits your host OS.  In case of Ubuntu, default storage driver is AUFS. However this driver is not available in distrbutions such as Fedora. In such case, other drivers are used. 

To view the used storage driver, run this command

```shell
docker info | grep "Storage Driver"
```

There will be a folder with the storage driver name under `/var/lib/docker` directory. You can look in the directory to see how the storage is managed.


## Example 

Lets consider a fresh docker installation with no images and containers.  We will perform various steps to understand more about storage drivers.

1. First lets see the default driver used by docker for our operating system. 

	```shell
	docker info | grep -e "Storage Driver"
	```

	![[Pasted image 20230301202229.png]]
2. As we can see the default driver is `overlay2`. All the layers managed by this driver will be stored under `/var/lib/docker` directory. Lets verify that this directory exists.
	```shell
	sudo ls /var/lib/docker
	```
	
	![[Pasted image 20230301202815.png]]
3. As we can see `overlay2` directory exists. Now lets see the contents of the directory.

	```shell
	sudo ls/var/lib/docker/overlay2
	```

	![[Pasted image 20230301203108.png]]
4. The directory only contains a single directory called `l`. Lets see the size of the directory
	
	```shell
	sudo du -sh /var/lib/docker/overlay2/l
	```
  
  
	  ![[Pasted image 20230301203340.png]]

5. The directory is practically empty. This is because we donot have any images installed in the system. Lets install nginx image and see how this directory changes.
	```shell
	docker pull nginx
	```
  ![[Pasted image 20230301203741.png]]
  
6. Lets look inside `/var/run/docker/overlay2` directory.

	```shell
	sudo ls /var/lib/docker/overlay2
	sudo ls /var/lib/docker/overlay2/l
	```


	![[Pasted image 20230301204010.png]]

7. As we can see `/var/lib/docker/overlay2` directory now has 6 directories. `l` directory also has 6 new directories. The name of these directories looks like some kind of hash value.  If you see the installation logs of nginx image, you will see nginx image was built up of 6 layers. All these layers are downloaded individually as shown in the logs. The 6 new directories under `/var/lib/overlay` represent those layers. Lets look at the size of all these layers combined.

	```shell
	sudo du -sh /var/lib/docker/overlay2
	```

	![[Pasted image 20230301204831.png]]

8. The size of all the layers in `/var/lib/docker/ovveraly2`  is 150 MB. Lets look at the size of the downloaded nginx image

	```shell
	docker image ls nginx
	```

	![[Pasted image 20230301204942.png]]

9. As you can see the size of the downloaded nginx image is 142 MB which is very close to the size of `/var/lib/overlay2` directory. This proves that this directory is holding all these layers including some additional metadata that comprises remaining 8 MB. Lets look at the size of each layer involved in building nginx

	```shell
	docker history nginx
	```


	![[Pasted image 20230301205257.png]]

10. When nginx image was created from the source code, these were all the steps performed in the Dockerfile.  Each step created a layer.  As we know a layer just includes those files which changed compared to its previous layer. The command which created the biggest layer is the bottom most command. This command is copying the underlying operating system (ubuntu) in the image. All the above commands are setting adding nginx source code, adding environemt variables, installing some additional softwares, copying additional files etc.  
		
	 In total, there are 15 layers among which 9 layers are just some metadata that will only be used when a container is created from this image.   The biggest layer is of 80.5MB.   Lets see which directory under `/var/libs/docker/overlay2` represents this layer.

	```shell
	sudo du -h --max-depth=1 /var/lib/docker/overlay2
	```

	 ![[Pasted image 20230301211226.png]]

11. You can see the 6th directory in the output having a size of 88MB. This directory represents the biggest layer of nginx image with 80.5MB size. Lets look what this directory.

	```shell
	 sudo ls /var/lib/docker/overlay2/387d900679fc8aedcc13000ba20508a489dbdd0becdaba54be663c80e92ba66f
	```

	![[Pasted image 20230301211955.png]]

12. As you can seee this directory contains 3 sub directories. `committed` and `link` directory are empty. So, all 88MB is contained ins `diff` directory. Lets see the contents of `diff` directory. 
	```shell
	sudo ls -l /var/lib/docker/overlay2/387d900679fc8aedcc13000ba20508a489dbdd0becdaba54be663c80e92ba66f/diff
	```

	![[Pasted image 20230301212404.png]]

13. As you can see this layer has changes in multiple root level directories. This makes sense as these layer is the underlying system layer. This operating system doesnot contain any kernel code. This contains utilities, additional softwares, functionalities etc that uniquely identifies this operating system as ubuntu. The second most biggest layer was of 61.3 MB.  This layer represents nginx code itself. Lets see the `diff`  folder of the directory that represents this layer.
	```shell
	sudo ls -l /var/lib/docker/overlay2/191a89549bc6cca10e768ec897e0d4928f1007d96b68167b6533cf60150a96e1/diff
	```

	![[Pasted image 20230301214019.png]]
		
14.  As you can see only few directores are included in this layer. This is because the nginx code only modifies these directories and doesnot make any change in other directories.  