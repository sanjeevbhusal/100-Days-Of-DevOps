When we start a computer, it goes through multiple stages to come to a state that is usable. Some stage are specific to operating system whereas some other state are general steps that occur in all the machines. Generally there are 4 steps,

- BIOS Post: BIOS runs a test called Power on Self test whose purpose is to make sure hardware devices attached to the computer are functioning. If the the test fails, that generally means that the computer doesn't have essential hardware required to function. Hence, the boot fails. This step is not specific to any Operating System.
- Boot Loader (GRUB2):  After successful BIOS Post, BIOS loads and executes the Boot code. The Boot code is located in the hard drive. For Linux, it is insdie /boot file system. One can have multiple boot system available (Ubuntu, Windows etc) in computer's inbuilt storage (hard drive) or any other external attached storage (Pen Drive). The Boot loader loads the code into RAM and provides a option to select the Boot system. 
- Kernel Initialization
- INIT Process (systemd)


