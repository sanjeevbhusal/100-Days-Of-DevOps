
Everything under Linux is represented as a file. There are 3 different kinds of files.
- Normal Files: These include text files, music files, images file etc.
- Directory: Directories are also represented as files. They are special kind of files that store other files and directories under them.
- Special Files: There are other 5 kinds of files under this category.
	- Character Files: These are files representing all external devices such as keyboard, mouse etc. They are located under /dev directory.
	- Block Files: These are files representing storage devices such as RAM, Hard disk. They are located under /dev directory. They can also be see with command lsblk.
	- Links: These are 2 or more files that point to same data on storage. You can create links wherever you want. There are 2 types of Links.
		- Hard Link: These are 2 or more files that point to same data on storage. If you delete one of the files, the data is also deleted.
		- Soft Link/Symlink: These are files that point to another file. When you access these files, you are actually accessing the original file. These files behave as a pointer and deleting them wont delete data.
	- Socket files: These are special files that enable communication between 2 processes.
	- Named Pipes: These files pipe output of one process as input to another process. The data flow is unidirectional i.e. from first process to second.

You can view file type using command file [filename] or ls -l [filename]


![[Pasted image 20230317125250.png|400]]


If you want to install any 3rd party programs, you can put them under /opt.
/mnt is used to mount file systems temporarily.
/tmp is used to store temporary data
extra media devices such as pendrive is mounted under /media
`df` command (disk file) prints out details about all the file system mounted in the machine. If you have a USB device attached to the system, you will seee in the output, a filesystem mounted under /media.
/dev contains block device files and character device files.
basic programs and binaries are located under /bin path.
/etc stores most of the linux configuration file.
/lib and /lib64 stores files/libraries that are used/imported by other programs. 
/usr stores all the additional programs of the userland(used by a user).Example: Chrome, vi editor etc
/var stores all the logs of the system as well as cached data.
