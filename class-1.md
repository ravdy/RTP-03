## Install pre-requisites software on Developer system  
Refer to this course in the [valaxy platform](https://www.valaxytech.com/course/devops-project-workshop)
### Software installed on Developer system 
1. VS code
1. Git bash 
1. Java
1. Maven
1. Tomcat

## Install Visual Studio Code
download vs code latest version from [here](https://code.visualstudio.com/download) and install it.

## Source code 
To build code on the local system we need source code. You can find login app source code [here](https://github.com/ravdy/loginapp)

## Git
To download source code from GitHub we should have git bash on local system 
download git bash from [here](https://git-scm.com/downloads) and install it. 

Now you can clone the code onto your system using git command 
```sh 
  git clone https://github.com/ravdy/loginapp.git
 ``` 
 
As it is java code, we should install Java and Maven to build and run this code. 

### Java installation 
1. Install java package from **[here](https://www.oracle.com/java/technologies/downloads)**

   In this project, we are using [java-19](https://download.oracle.com/java/19/latest/jdk-19_windows-x64_bin.exe)
   `Note: If you are unable to install java just check your antivirus or firewalls to allow it` 
   we should setup jdk path to find java 
1. Setup environment variable. 
    a. Start searching “edit system environment variables” in the windows search, under advance tab chose Environment variables --> under the System variables chose `new..` 
    b. in the dialog box 
     ```sh 
     Variable name: JAVA_HOME
     Variable value: <JDK_PATH>
     in my system jdk location is C:\Program Files\Java\jdk-19
     ```
     ok to save. 
    c. add same to PATH variable. 
    system variables --> select path -->  add new --> 
    <JDK_Path>\bin
    _in my system this path location is C:\Program Files\Java\jdk-19\bin_

To validate java version, run below command. 
   ```sh 
      java -version
   ``` 
Output should be something like below 
  ```sh 
  java version "19.0.1" 2022-10-18
  Java(TM) SE Runtime Environment (build 19.0.1+10-21)
  Java HotSpot(TM) 64-Bit Server VM (build 19.0.1+10-21, mixed mode, sharing)
  ```
## Maven installation 

Download maven packages from https://maven.apache.org/download.cgi  
 we are using [Maven-3.8.7](https://dlcdn.apache.org/maven/maven-3/3.8.7/binaries/apache-maven-3.8.7-bin.zip)

1. Setup environment variable. 
    a. Start searching “edit system environment variables” in the windows search, under advance tab chose Environment variables --> under the System variables chose `new..` 
    b. in the dialog box 
     ```sh 
     Variable name: MAVEN_HOME
     Variable value: <MAVEN_PATH>
     in my system jdk location is C:\Program Files\apache-maven-3.8.7
     ```
     ok to save. 
    c. add same to PATH variable. 
    system variables --> select path -->  add new --> 
    <MAVEN_Path>\bin
    _in my system this path location is C:\Program Files\apache-maven-3.8.7\bin

To validate java version, run below command. 
   ```sh 
      mvn -version
   ``` 
Output of above command should be like below 
  ```sh
   Apache Maven 3.8.7 (b89d5959fcde851dcb1c8946a785a163f14e1e29)
   Maven home: C:\Program Files\apache-maven-3.8.7
   Java version: 19.0.1, vendor: Oracle Corporation, runtime: C:\Program Files\Java\jdk-19
   Default locale: en_IN, platform encoding: UTF-8
   OS name: "windows 10", version: "10.0", arch: "amd64", family: "windows"
 ```
 
 ### Building java source code 

1. Build source code  
   go to source code folder and run below command 
   `Note: make sure you have pom.xml in the folder`
   ```sh 
    mvn clean install -Dmaven.test.skip=true  
   ```
 
 Once build is successful you can see 'target' directory in the same location. 
 find your war/jar/ear file inside target folder. 
 
 In this project we could see a war file (login-release.war) in the target folder. 
 
 To run war file we need Apache tomcat. Lets install Apache tomcat
 
 ### Install Apache tomcat on Windows 
 
 1. Download Tomcat from [tomcat website](https://tomcat.apache.org/download-90.cgi)
   In this project we are using the [tomcat 9.0.7](https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.70/bin/apache-tomcat-9.0.70-windows-x64.zip) version.

    Extract the files and start startup.bat file.
    `Note: You may get permission issue in case of using C:\Program Files. Better avoid this location`
    To start tomcat services 
    go to tomcat installation folder --> bin --> start.bat 
1. Access application from the browser
   Go to browser and type http://localhost:8080
1. It asks for username and password when you try to login to "manager app". to create users follow below steps 
  Update users information in the tomcat-users.xml file go to tomcat home directory and Add below users to conf/tomcat-user.xml file.
   ```sh 
    <role rolename="manager-gui"/>
    <role rolename="manager-script"/>
    <role rolename="manager-jmx"/>
    <role rolename="manager-status"/>
    <user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
    <user username="deployer" password="deployer" roles="manager-script"/>
    <user username="tomcat" password="s3cret" roles="manager-gui"/>
   ```
1. Restart service and try to login to tomcat application with the following credentials from the browser. use any credentials which is attached with _manager-gui_ role. This time it should be Successful
   ```sh 
    User:tomcat
    password:s3cret
   ```
1. Copy war file (login-release.war) on to webapps folder inside tomcat and reload tomcat services 
1. access application from the browser 
   ```sh 
    http://localhost:8080/login-release 
  ```
# Things observed in the 1st Lab session:
1.	Tomcat should be installed outside of “Program Files” to avoid permission issue while running startup.bat
2.	https://github.com/ravdy/loginapp.git is runs with Tomcat 9.0.7 or lower. It doesn’t run with tomcat 10
3.	mvn install should be from the location where pom.xml available  
4.	Maven “deploy” goal fails if remote artifact is not mentioned 
5.	You may get “connection refused” error if your firewall blocks the connection 
