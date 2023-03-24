When we start a computer, it goes through multiple stages to come to a state that is usable. Some stage are specific to operating system whereas some other state are general steps that occur in all the machines. Generally there are 4 steps,

- BIOS Post: BIOS runs a test called Power on Self test whose purpose is to make sure hardware devices attached to the computer are functioning. If the the test fails, that generally means that the computer doesn't have essential hardware required to function. Hence, the boot fails. This step is not specific to any Operating System.
- Boot Loader (GRUB2):  After successful BIOS Post, BIOS loads and executes the Boot code. One can have multiple boot system available (Ubuntu, Windows etc) in computer's inbuilt storage (hard drive) or any other external attached storage (Pen Drive). The Boot loader loads the code into RAM and provides a option to select the Boot system. For Linux, boot code is located inside /boot file system. One of the examples of boot loader used by almost all linux distributions is GRUB2.
- Kernel Initialization: The selected kernel then starts executing. The kernel then analyzes hardware, performs memory related tasks etc. 
- INIT Process (systemd): Once the kernel is set up, we now need to initialize processes and application specific to a user. This involves running the selected view (Command Line/ Graphical, mounting the right file system, initializing all the system files etc. One of the most famous init process is called systemd. To see the init process in your computer, run ls -l /sbin/init


## Run Level

Linux can run in multiple modes, most specifically CLI and GUI mode. When you reach level 4 (INIT Process) in the Boot Process, the init process (systemd) needs to know if you want to run CLI or GUI option. This is defined using something called Run Level. You can define different values in Run Level, each correspond to a specific mode. Run Level 5 corresponds to GUI Mode whereas Run Level 3 corresponds to CLI mode.  If your run level is set to 5, you need to make sure a display manager service is also available on the machine to render GUI.

If your Operating System uses systemd as init process, then Run levels are called targets. Run level 5 is called graphical target and Run level 3 is called multi-user target. To get run level of the system, run command runlevel. All  target files are located at /etc/systemd/system/. To get the selected/current target, run systemcl get-default. The default target file is located at /lib/systemd/system/default.target. It is a symbolic link file. 
