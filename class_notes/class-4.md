## Setup Jenkins pipeline job
As part of jenkins pipeline job, 1st we are going to pull the code and build it in the slave system for this
1. Add GitHub credentials 
1. write jenkinsfile for pipeline job

1. To add GitHub credentials 
   Manage Jenkins --> manage credentials --> System --> Global credentials --> add credentials --> username and password 

   `Note:`Make sure you have generated a secret key in the GitHub account to add these credentials 
   to generate goto github.com --> setting --> Developer settings --> Choose job style Personal access token --> tokens (clasic)

1. Create a jenkins job 
In Jenkins home page 
new iteam --> item name "Twittertrend_pipeline" --> pipeline
Under pipeline 
  Pipeline script from SCM
  SCM --> Git
  Repository URL --> https://github.com/ravdy/twittertrend.git
  Credentials --> chose credentials added in the above step
  Branches to build --> main or master 
  Script Path --> Jenkinsfile 
  this Jekins file should have only build step as mentioned below 

```sh 
  pipeline {
    agent {
       node {
         label "valaxy"
      }
    }
    stages {
        stage('Build') {
            steps {
                echo '<--------------- Building --------------->'
                sh 'printenv'
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo '<------------- Build completed --------------->'
            }
        }
    }
 }
```

above script is committed as v1-jenkinsfile in RTP-03 repo

# Let's create multibranch pipeline 
To create multibranch pipeline 
1. Create new job
   new iteam --> item name "Twittertrend_Multibranch_pipeline" --> Choose job style Multibranch pipeline

  Note: make sure you have more then 1 branch in the GitHub

  Branch: Git
  Project Repository: https://github.com/ravdy/twittertrend.git 
  Credentials: ec2-user
  Build Configuration : 
    Mode:  by Jenkinsfile
    Script Path: Jenkinsfile

  # Enable webhook

  1. Install "multibranch scan webhook trigger" plugin 
   From dashboard --> manage jenkins --> manage plugins 


  2. Go to multibranch pipeline job 
     job --> configure --> Scan Multibranch Pipeline Triggers --> Scan Multibranch Pipeline Triggers

  3. Add webhook to GitHub repository
     Github repo --> settings --> webhooks --> Add webhook 
     Payload URL: JENKINS_URL/multibranch-webhook-trigger/invoke?token=[Trigger token] 
     Example: http://13.233.42.142:4000/multibranch-webhook-trigger/invoke?token=rtp-03
     Content type: application/json 


# Integrate sonarqube with Jenkins
We need a SonarQube scanner on the Jenkins server (CI server) to analyze code and send reports. 

1. Create an account at https://sonarcloud.io
    Goto my account  → Security --> Generate token 
1. Create credentials for token in the Jenkins
   	Manage Jenkins → Manage Credentials → Global Credentials →
    Kind: secret text 
    Secret: SonarQube token 
1. Download “sonarqube scanner for Jenkins” plugin on jenkins
1. Configure Sonarqube server 
    Manage Jenkins → Configure System → SonarQube Server 
    Add sonarqube server 
    Server: https://sonarcloud.io/
    Token: <Select tolek which added in the above step>

1. Add sonarqube scanner to jenkins
    Jenkins Dashboard --> Manage Jenkins --> Global Tool Configuration 

1. Import project from Github onto sonarqube
    Dashboard --> account --> My Organizations   
    Chose GitHub → select repository → import project 

1. Create sonarqube.properites file 

   Add the following code in sonar.properties file:
   ```sh 
     sonar.verbose=true   
     sonar.projectKey=ravdy_ttrend            
     # go to project —> at the bottom left panel select information --> copy project key and organization key
     sonar.projectName=ttrend    #Project Key
     sonar.organization=ravdy  #Organization Key
     sonar.language=java
     sonar.sourceEncoding=UTF-8
     sonar.sources=.            #.means root of src
     sonar.java.binaries=target/classes
    ```
1. Add sonarqube state in the Jenkinsfile and run the job 

  stage ("Sonar Analysis") {
            environment {
               scannerHome = tool 'Valaxy-SonarScanner'  //scanner name configured for slave 
            }
            steps {
                echo '<--------------- Sonar Analysis started  --------------->'
                withSonarQubeEnv('Valaxy-SonarQube') {    
                    //sonarqube server name in master
                    sh "${scannerHome}/bin/sonar-scanner"
                }    
                echo '<--------------- Sonar Analysis stopped  --------------->'
            }   
        }

# Enable quality gates
Now its time to enable quality gates 
for this, we should do below steps
1. create a quality gate
2. create a webhook
3. update jenkins file to wait for the quality gate result 
  

### create a quality gate
on Sonarclould.io 
go to project --> administration --> quality gates --> "the Quality Gate definition"
create a quality gate
here chosen conditions as
Code Smells are greater then 5 
Major Issues are greater than 5 

The quality gate fails the analysis.


### create a webhook
same we can send it back to jenkins we should create a webhook
got to project --> administration --> webhooks --> create 
Name: jenkins 
URL*: http://35.154.179.94:4000/sonarqube-webhook/
secret: <leave_it_blank>

### update jenkins job
now its time to update the jenkins file with the below code
```sh 
          stage("Quality Gate"){
            steps {
                script {
                    echo '<--------------- Sonar Gate Analysis started --------------->' 
                    timeout(time: 1, unit: 'HOURS'){
                        def qg = waitForQualityGate()
                        if(qg.status !='OK'){
                            error "Pipeline failed due to quality gate failures: ${qg.status}"
                        }
                    }
                    echo '<--------------- Sonar Gate Analysis Completed --------------->'
                }
            }
        }

  ```

Now run the job 
