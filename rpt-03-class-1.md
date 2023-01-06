## Install pre-requisites software on Developer system  
#### Software installed on Developer system 
1.	Java
2.	Maven
3.	Mobaxterm / putty
4.	Git
5.	VS code
6.	Terraform
7.	AWSCLI

### Java installation 
1. Install java pacakge from **[here](https://www.oracle.com/java/technologies/downloads)**

   In this project, we are using [java-19](https://download.oracle.com/java/19/latest/jdk-19_windows-x64_bin.exe)
   `Note: If you are unable to install java just check your antivirus or firewalls to allow it` 

1. Setup environment variables 
1. Start searching “system environment variables” in the Environment Variables window, under the System variables category, `click the New…` button to create a `new variable`.

## Maven installation 
Have a JDK installed on your system. Either set the JAVA_HOME environment variable pointing to your JDK installation or have the java executable on your PATH.

Download and install [git bash](https://git-scm.com/downloads)

1.	Install terraform
2.	Install visual studio code
3.	Add terraform plugin
4.	Create an IAM user with programmatic access (copy or download credentials)
5.	Install awscli 
6.	aws configure --profile valaxy
7.	git clone https://github.com/ravdy/valaxy-rtp.git
8.	Add profile name in aws-provider.tf
9.	Create a keypair pem key in aws (key name: prd01)

