
Linux Kernel acts as a interface between applications/processes and physical hardware devices.

![[linux-kernel.png | 600]]

But why do we even need a kernel? Why not just let application access hardware resources on their own?

To understand this, lets use a analogy of a college library.

A college library will have a lot of books for all kind of subjects taught in the college. The purpose of this library is to let students borrow books to study. Lets imagine any student is free to take any kind of books. There is no one keeping track of it.

A single student takes multiple books, then there will be shortage of books for other students. The student also might not return the book in time as there is no one managing the return time.  A engineering student might take medical books and there is no one preventing him. 

If there exists a librarian who manages all the activities in library, we will not have such problems.  Librarian will make sure a student only gets fixed number of books, makes sure the books are returned in their due date etc, makes sure a engineering student only gets engineering related books etc. No student will be able to abuse library ensuring all students will be able to use library.

In this analogy, library refers to Linux Kernel, books refer to Hardware Resources and students refer to application.

![[linux-kernel-2.png | 600]]

Linux Kernel generally does 2 things
- Memory Management: It tracks memory usage for all the application/processes.
- Process Management: It tracks CPU usage for all the runninng applications.

Linux Kernel can extend its capabilities through dynamically loaded kernel files/modules.

To get information about the kernel, run `uname -a`

### Operating System

When we download any distribution of linux operating system, we are infact downloading linux kernel plus additional utilities. These additional utilities are softwares such as Graphical User Interface, package managers etc. 

When you use different kinds of utilities, you get a Operating System which looks different, feel different and have different features.


### Kernel and User space

Linux kernel is also a software. It also needs CPU, RAM, storage etc in order to run. Applications will then access the kernel for hardware resources. kernel manages resources allocated to a application to make sure single application doesnot consume all the resources. But linux kernel itself needs unrestricted access to hardware resources. 

There is a concept of kernel space and user space.

- kernel space: kernel space is a portion of memory in which the kernel executes and provides its services. If a process is running in kernel space it has unrestricted access to hardware resources. Hence it is reserved for kernel code only.
- user space: User space is a portion of memory in which additional applications executes. If a process is running in user space, it has restricted/limited access to hardware resources.  These application will make system calls to kernel to perform a task such as open a file, read direcory etc.


## Working with Hardware

### External Devices

Whenever you attach a external device such as pen drive, device driver detects this change. device driver is a part of kernel and resides in Kernel Space. device driver then generates an event called uevent which is then sent to a device manager residing on user space. This device manager is called udev. device manager then creates a file under /dev directory  representing the external attached device.


![[external-device.png|600]]


Ring Buffer is the area of the kernel that is used to store log messages. When Linux OS boots up, it generates a lot of logs related to the system. The command `dmesg` prints these log messages.

peripheral component interconnect (pci) devices are those devices which are attached to PCI slot in motherboard. Some examples of PCI devices are ethernet cards, video cards, radio controller, wireless adapter etc . `lspci` command displays all the pci devices available on the system. 

you might have a single storage disk on the system but you can still make logical seperations of the disk called partitions. `lsblk` lists all the block devices on the system. 

register is a location on CPU that stores some data and can be rapdly accessed by Processor. It loads data from memory (RAM). 

`lscpu` command lists all the important details about the CPU/processor. 2 Major types of CPU are 32 bit CPU and 64 bit CPU. A 32 bit CPU can store $2^{32}$  values in its registers and 64 bit CPU can store $2^{64}$ values in its registers. 32 bit CPU also has a maximum memory limitation of 4 Gigabytes. For 64 bit CPU, the memory limitation is 18 Excabytes. 

You cannot install 64 bit Operating System on a machine with 32 bit CPU but the other way around is possible. machine with 32 bit CPU can only install  softwares that can run on 32 bit CPU.

Sockets are physical slot on the motherboard where you can insert a physical CPU. Each physical CPU can have multiple cores and each core can run multiple threads at the same time. When you multiply total number of sockets, cores per socket and threads per core, you get total number of CPU's or Virtual CPU's in the machine. `total socket * core per socket * threads per core` 


![[virtualCPU.png|600]]


`lsmem --summary` displays the summary of memory on the machine. `free -m` displays total memory and used memory in megabytes.

`lshw` displays all the information about all the hardware on the system.