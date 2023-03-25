
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


If you want to search for a file in linux, you can simply run `find [path of the directory] --name [filename]`

There are total of 3 data streams in linux. 

- Input Stream
- Output Stream
- Error Stream


You can use redirect command (>) to redirect data in a stream to be written to a file. In this command `echo "hello world" > file1.txt`, the data in output stream of echo command is redirected to be written to a file called file1.txt. If you want to redirect the data in error stream of a command, you can use `2>`. If you want to redirect the output/error stream so that it is printed on terminal but donot want to write to a file, you can redirect data to /dev/null.  

You can use pipe command ( | ) to pass the output of a command as a input to another command. In this command, `ls -l | sort -r ` the data in output stream of ls -l command is passed as a input to sort -r command. If ls -l command errors out and sends data through error stream, pipe command will not send that data as input to sort command. Instead, pipe command will fail and the error is printed to the terminal. You can pipe as many commands as you like.

>

