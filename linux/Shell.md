Shell is a program that lets user interact with Operating System. User can type commands which gets executed through operating system. 

There are 2 types of commands in the shell.

- Internal Commands: Built inside the shell. Doesnot have a binary file
- External Commands: Has a binary file located under /usr/bin. Can be installed by user.

Use `type [command name]` to see the type of command. 


Running cd from anywhere takes you to home directory.

Running cat > file1.txt will let you input text.

`whatis [command name]` prints a small description of the command's functionality. 

`chsh` command can be used to change the default shell for a user.

`alias a=b` command to set aliases

`env` command to see all the environment variables
environment variables set by the system and user is used by shell to customize the apperance and behaviour of shell. `PS1` environment variable customizes the prompt of bash shell.

When user types a external command into the shell, shell must first find the executable file associated with that command and then pass the file to operating system to execute. shell gets all the directories to look for through a system wide environmental variable called `PATH`. If the file is not found inside any of the directory mentioned in PATH variable, shell throws an error. 