
Package Managers are used to manage the package in the system. 

A package is a archive that contains multiple files which work together to accomplish a goal. In other words, a package contains all the files needed for a software/process to run. For example to install GIMP (GNU Image manipulation), we can install a package called gimp.deb. This package contains all the binary files and configuration files needed to run GIMP. The package also contains metadata files that give information about the GIMP software contained in the package. 

There are hundreds of linux distributions out there. All of them are different from each other in terms of how the system should work. System programs, Available libraries, underlying linux kernel version etc will differ among all the distributions. This means the steps involved in successfully installing a software will differ in all the distributions.
To fix this problem, packages' metadata files include the steps involved in successfully installing the software. The most important part of the metadata is to make sure all the  dependencies of the package are available in the system. Each of the dependent packages might have their own dependencies. This makes installing package manually very tedious. That's exactly where package manager helps. 

A package manager will follow the steps in the metadata file and makes sure the package and its dependencies are installed in the system. You only have to run a single command and package manager will do the rest. A package manager will take care of installing a software, upgrading it, configuring it and deleting it. A package manager also verifies the authenticity of a downloaded software. It does so by taking the hash of the downloaded package and verifying it against the hash provided by the package publisher. When the authenticity is verified, it installs the software. 

Packages are hosted in software repositories. A package manager contains the information of multiple repositories and all their packages. 

Most of the Linux distributions can be classified into 2 categories. 

- Debian Distributions (Operating System that fall under debian distribution: Debian, Ubuntu, LinuxMint etc)
- Red hat Distributions (Operating System that fall under red hat distribution: Redhat Enterprise Linux, CentOS etc)

Both of these distributions vary in terms of system programs, available libraries, underlying linux kernel version etc. Both of the distributions have their own package manager software. 

- Debian distributions uses package managers such as dkpg, apt or apt-get.
- Red hat distributions uses package manager such as rpm, yum or dnf.
 
