
Everything under Linux is represented as a file. There are 3 different kinds of files.
- Normal Files: These include text files, music files, images file etc.
- Directory: Directories are also represented as files. They are special kind of files that store other files and directories under them.
- Special Files: There are other 5 kinds of files under this category.
	- Character Files: These are files representing all external devices such as keyboard, mouse etc. They are located under /dev directory.
	- Block Files: These are files representing storage devices such as RAM, Hard disk. They are located under /dev directory. They can also be see with command lsblk.
	- Links: These are 2 or more files that point to same data on storage. There are 2 types of Links.
		- Hard Link: These are 2 or more files that point to same data on storage. If you delete one of the files, the data is also deleted.
		- Soft Link/Symlink: