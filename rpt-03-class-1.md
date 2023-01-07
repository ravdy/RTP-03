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
1. Start searching “edit system environment variables” in the windows search, --> Environment variables --> under the System variables category, `click the New…` button to create a `new variable`.

Have a JDK installed on your system. Either set the JAVA_HOME environment variable pointing to your JDK installation or have the java executable on your PATH.

_Validate java verison_  
   ```sh 
    java -version
   ``` 

## Maven installation 

Download maven pages from https://maven.apache.org/download.cgi
we are using [Maven-3.8](https://dlcdn.apache.org/maven/maven-3/3.8.7/binaries/apache-maven-3.8.7-bin.zip)

Start searching “edit system environment variables” in the windows search, --> Environment variables --> under the System variables category, `click the New…` button to create a `new variable`.
Have a JDK installed on your system. Either set the MAVEN_HOME environment variable pointing to your maven installation or have the maven executable on your PATH.

_Validate java verison_
   ```sh 
    mvn -version
   ``` 
## Mobaxterm installation 

Download mobaxterm v22.3 [here](https://download.mobatek.net/2232022120824733/MobaXterm_Installer_v22.3.zip)

## Git bash installation 
Download and install [git bash](https://git-scm.com/downloads)

### Working with Source code 

1. Clone code
    ```sh
     git clone https://github.com/ravdy/twittertrend.git
     or 
     https://github.com/ravdy/loginapp.git
    ``` 
1. Build source code  
   ```sh 
    mvn clean install -Dmaven.test.skip=true  
   ```
1. Run java applicaiton   
   ```sh 
    cp /c/Users/valaxy/Desktop/Valaxy/loginapp-master/app/target/login-release.war 
    C:\Program Files\tomcat-9.0\apache-tomcat-9.0.70\webapps
   ```
1. To test our applicaiton we should download [postman from here](https://www.postman.com/downloads/)  if it is twittertrends
2. if it is login app use tomcat to test it 

####  
  
1.	Install terraform  
2.	Install visual studio code  
3.	Add terraform plugin  
4.	Create an IAM user with programmatic access (copy or download credentials)  
5.	Install awscli   
6.	aws configure --profile valaxy  
7.	git clone https://github.com/ravdy/valaxy-rtp.git  
8.	Add profile name in aws-provider.tf  
9.	Create a keypair pem key in aws (key name: prd01)  
10.	


