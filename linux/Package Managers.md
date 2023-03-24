
Package Managers are used to manage the package in the system. 2 of the most famous package managers are 

- Debian package managers such as dkpg or apt
- Red hat package managers such as rpm
 
 There are various linux distributions available today. Most of these distributions use one of the above two package managers. If a distribution uses Debian package manager, then the distribution can be said as a debian based distribution. If a distribution uses Red Hat package manager, then the distribution is said to be a red hat based distribution.
 Distribution such as Debian, Ubuntu, LinuxMint etc use debian package managers wheras Distributions such as Redhat Enterprise Linux, CentOS etc uses Red hat package manager.

A package is a archive that contains multiple files which work together to accomplish a goal. In other words, a package contains all the files needed for a software/process to run. For example to install GIMP (GNU Image manipulation), we can install a package called gimp.deb. This package contains all the binary files and configuration files needed to run GIMP. The package also contains metadata files that give information about the GIMP software contained in the package. 

There are hundreds of linux distributions out there. All of them are different from each other in terms of how the system should work. System programs, Available libraries, underlying linux kernel version etc will differ among all the distributions. This means the steps involved in successfully installing a software will differ in all the distributions.
To fix this problem, packages' metadata files include the steps involved in successfully installing the software. The most important part of the metadata is to include other libraries/dependencies of the package is installed

containof a package contains 

In order to run a software, we must make sure we install the software in a way the distribution expects.

This means a software might run in some distributions whereas it might not run in other distributions

itself  When installing a package, we need to make sure