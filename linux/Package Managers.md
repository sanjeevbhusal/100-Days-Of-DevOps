
Package Managers are used to manage the package in the system. 

A package is a archive that contains multiple files which work together to accomplish a goal. In other words, a package contains all the files needed for a software/process to run. For example to install GIMP (GNU Image manipulation), we can install a package called gimp.deb. This package contains all the binary files and configuration files needed to run GIMP. The package also contains metadata files that give information about the GIMP software contained in the package. 

There are hundreds of linux distributions out there. All of them are different from each other in terms of how the system should work. System programs, Available libraries, underlying linux kernel version etc will differ among all the distributions. This means the steps involved in successfully installing a software will differ in all the distributions.
To fix this problem, packages' metadata files include the steps involved in successfully installing the software. The most important part of the metadata is to make sure all the  dependencies of the package are available in the system. Each of the dependent packages might have their own dependencies. This makes installing package manually very tedious. That's exactly where package manager helps. 

A package manager will follow the steps in the metadata file and makes sure the package and its dependencies are installed in the system. You only have to run a single command and package manager will do the rest. A package manager will take care of installing a software, upgrading it, configuring it and deleting it. A package manager also verifies the authenticity of a downloaded software. It does so by taking the hash of the downloaded package and verifying it against the hash provided by the package publisher. When the authenticity is verified, it installs the software. 

Packages are hosted in software repositories. A package manager contains the information of multiple repositories and all their packages. 

Most of the Linux distributions can be classified into 2 categories. 

- Debian Distributions (Operating System that fall under debian distribution: Debian, Ubuntu, LinuxMint etc)
- Red hat Distributions (Operating System that fall under red hat distribution: Redhat Enterprise Linux, CentOS, Fedora etc)

Both of these distributions vary in terms of system programs, available libraries, underlying linux kernel version etc. Both of the distributions have their own package manager software. 

- Debian distributions uses package managers such as dkpg, apt or apt-get.
- Red hat distributions uses package manager such as rpm, yum or dnf.


Red hat Package Manager manages package with extension .rpm. You can perform 5 main operations using rpm.
- Installing
- Uninstalling
- Quering
- Upgrading
- Verifying

In order to install a package with rpm, you first need to download the package. Once the package is downloaded, you can install the package with `rpm -i [package name.deb]`. rpm will automatically place each files in their appropriate directory and make necessary configurations based upon the metadata in the package. rpm stores information about all the installed packages in a database located at /var/lib/rpm. It is important to note that RPM cannot download packages from internet. It can only install packages available locally on the system. To download packages from internet, we use another package manager called Yum. 

Yum is a package manager used in red hat based distributions. It provides features that are not available with rpm such as downloading software from Internet. However, it uses rpm in order to install/upgrade/manage packages on the local system. Once on top of rpm i.e. it extends features compared to rpm. It also deals with packages with .rpm extension. Under the hood, yum uses rpm to perform above operations on packages. The benefit of using yum is that yum can handle dependency resolution very well.  yum stores information about different packages from different repositories in its own database. Repositories information is located under /etc/yum.repos.d. You can add other repositories as well under /etc/yum.repos.d. `yum repolist` will show you all the repositories configured on the system.

When you try to install any package using yum, these are the steps that happens:

- Yum first checks if the package is already installed on the system. It will check its database where it stores all the information about the installed packages.
- If the package is available, yum will inform you and terminate the installation operation. If the package is not available, then yum will search for the package in its database. Yum stores information about all the packages available in all software repositories under /etc/yum.repos.d.
- If the package is not available, yum will inform you and terminate the installation operation. If the package is available, yum will gather all the information about the package mentioned in its metadata. 
- Yum also gathers information about all the dependency packages with their appropriate versions. These dependency packages might have their own dependency as well. So, yum will gather these information as well.
- Yum will then check if any of those dependent packages are installed on the system by going through the database mentioned in step 1.  
- If some of the dependent packages are installed in the system, yum will ignore them. Once Yum knows how many packages it needs to install, it prints the information on the screen, for user to confirm. 
- If a package was available on the system but with a different version, yum will not print the package information as a new install. It will instead treat the package installation as update. This means yum will delete the installed package and install the same package with different version .
- Upon confirmation by user, yum will install all the packages. 


As stated above, when you try to install a package, yum looks at its local database to check if the package is present. This local database contains packages that were present in the software repositories at /etc/yum.repos.d. Their might be a case when a package is removed from the software repository. As yum has not updated its database, yum will think that the package is available to install. But when it tries to download the package, it will error out as the package is no longer present in the repository. New packages are also constantly being added to the software repositories. The database should also be updated to contain new packages or newer version of old packages. The conclusion is that you update the database with real time data anytime you want to install / upgrade a package.  


