## Setup Jenkins pipeline job
As part of jenkins pipeline job, 1st we are going to pull the code and build it in the slave system for this
1. Add GitHub credentials 
1. Write jenkinsfile for pipeline job

### Add GitHub credentials 
    Manage Jenkins --> manage credentials --> System --> Global credentials --> add credentials --> username and password 

    `Note:`Make sure you have generated a secret key in the GitHub account to add these credentials   
   *to generate*
    goto github.com --> setting --> Developer settings --> Choose job style Personal access token --> tokens (clasic)

### Create a jenkins job   
   In Jenkins home page 
   new iteam --> item name "Twittertrend_pipeline" --> pipeline  
   ![i1](https://user-images.githubusercontent.com/100523955/213704518-d21827fb-ebe6-497a-a1df-d3e25268c1e2.PNG)
   Under pipeline 
   Pipeline script from SCM  
   SCM --> Git  
   Repository URL --> https://github.com/ravdy/twittertrend.git  
   Credentials --> chose credentials added in the above step  
  
  ![i2](https://user-images.githubusercontent.com/100523955/213705133-1f150598-ca3b-4a49-acfa-25eb05330f27.png)
  Branches to build --> main or master   
  Script Path --> Jenkinsfile   
  
  ![i3](https://user-images.githubusercontent.com/100523955/213705411-c470897a-d9b0-4ea5-8363-fb926dbe7201.png)
  This Jekins file should have only build step as mentioned below :

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

  above script is committed as [v1-jenkinsfile](https://github.com/ravdy/RTP-03/blob/main/jenkins/v1-Jenkinsfile) in RTP-03 repo

## Let's create multibranch pipeline 
To create multibranch pipeline 
1. Create new job  
   new item --> item name "Twittertrend_Multibranch_pipeline" --> Choose job style Multibranch pipeline  
   
   <img width="429" alt="i1_4" src="https://user-images.githubusercontent.com/100523955/213706321-d20cefc3-a77f-4d77-ab65-d7758e32935f.PNG">

  Note: make sure you have more then 1 branch in the GitHub  
  
  <img width="471" alt="i2_4" src="https://user-images.githubusercontent.com/100523955/213706701-2989a32e-0241-4110-9036-5677a66dbf4b.PNG">
  
  <img width="235" alt="i3_4" src="https://user-images.githubusercontent.com/100523955/213707045-23b71379-4867-4a90-aeec-4db24db448f5.PNG">
    
  Branch: Git  
  Project Repository: https://github.com/ravdy/twittertrend.git    
  Credentials: ec2-user  
  
  ![i2_1](https://user-images.githubusercontent.com/100523955/213714973-0e7958d1-1f74-42e7-b003-a72ad777908e.png)
  
    Build Configuration :     
    Mode:  by Jenkinsfile               
    Script Path: Jenkinsfile               

### Enable webhook

1. Install "multibranch scan webhook trigger" plugin   
     From dashboard --> manage jenkins --> manage plugins 
   
     ![i4](https://user-images.githubusercontent.com/100523955/213715783-d1cf7636-5bd3-43b3-8d9a-e32a3b7dadb2.png)


1. Go to multibranch pipeline job    
     job --> configure --> Scan Multibranch Pipeline Triggers --> Scan Multibranch Pipeline Triggers
     
     ![i5](https://user-images.githubusercontent.com/100523955/213716091-46deac59-4caf-44a5-adb7-4e040daf4e53.png)

1. Add webhook to GitHub repository   
   Github repo --> settings --> webhooks --> Add webhook    
     
   ![i6](https://user-images.githubusercontent.com/100523955/213716214-3ce54b96-77b7-4141-80e1-5490e49027df.png)
     
    _Payload URL:_ JENKINS_URL/multibranch-webhook-trigger/invoke?token=[Trigger token]      
     _Example:_ http://13.233.42.142:4000/multibranch-webhook-trigger/invoke?token=rtp-03     
     _Content type:_ application/json         
     
     Upon successfully configuring webhook it should look like below:
     
   ![i7](https://user-images.githubusercontent.com/100523955/213716440-93026a92-b50f-4029-9aa0-d194c5fd05e6.png)


## Integrate sonarqube with Jenkins  
We need a SonarQube scanner on the Jenkins server (CI server) to analyze code and send reports. 

1. Create an account at https://sonarcloud.io    
1. create a token to authenticate with sonarqube
   Goto my account  → Security --> Generate token    
   ![i8](https://user-images.githubusercontent.com/100523955/213718918-7674a65e-2f10-45c2-966a-dff81bcb0793.png)

1. Create credentials for token in the Jenkins   
   Manage Jenkins → Manage Credentials → Global Credentials →  
   _Kind:_ secret text   
   _Secret:_ SonarQube token   
1. Download “sonarqube scanner for Jenkins” plugin on jenkins    

   ![i9](https://user-images.githubusercontent.com/100523955/213719462-ea51acc4-2703-46be-9201-c16d8bbe216c.png)

1. Configure Sonarqube server    
   Manage Jenkins → Configure System → SonarQube Server           
   Add sonarqube server       
   _Server:_ https://sonarcloud.io/      
   _Token:_ Select token which added in the above step 
   ![i9](https://user-images.githubusercontent.com/100523955/213720468-1585d0d2-0b89-4795-a6a8-c381eb99efbf.png)

1. Add sonarqube scanner to jenkins     
    Jenkins Dashboard --> Manage Jenkins --> Global Tool Configuration     
  
   ![i13](https://user-images.githubusercontent.com/100523955/213722228-60d574e0-df95-4b60-adf8-455325a3b2ca.png)      
  
1. Import project from Github onto sonarqube     
   Dashboard --> account --> My Organizations     

   ![i11](https://user-images.githubusercontent.com/100523955/213722552-de6aed53-0b63-4ced-ab05-0d9cc4c96768.png)
  
    Chose GitHub → select repository → import project     
    ![i12](https://user-images.githubusercontent.com/100523955/213727994-9b76fc41-72a0-46a6-b0fe-0939bf35c02d.png)

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

1. Add sonarqube stage in the Jenkinsfile and run the job   
   ```sh 
      stage ("Sonar Analysis") {  
       environment {    
          scannerHome = tool 'Valaxy-SonarScanner'  //scanner name configured for slave    
           }   
       steps {   
          echo '<--------------- Sonar Analysis started  --------------->'   
              withSonarQubeEnv('Valaxy-SonarQube') { 
               //sonarqube server name in master   
                   sh "${scannerHome}/bin/sonar-scanner"   
                   }   
                 echo '<--------------- Sonar Analysis stopped  --------------->'   
               }   
           }  
    ```  

## Enable quality gates    
Now its time to enable quality gates      
for this, we should do below steps      
1. create a quality gate     
2. create a webhook     
3. update jenkins file to wait for the quality gate result    
  

### create a quality gate   
on Sonarclould.io     
go to project --> administration --> quality gates --> "the Quality Gate definition"   
![i14](https://user-images.githubusercontent.com/100523955/213728368-b5ca410c-282e-4d2a-8c10-d3f72f5c9232.png)
  
create a quality gate   
  
![i15](https://user-images.githubusercontent.com/100523955/213728424-050feb97-3632-408e-8582-553dc2b5d8b1.png)
  
The following conditions can be choosen in the quality gate  
Code Smells are greater then 5    
Major Issues are greater than 5    

The quality gate fails the analysis.

### create a webhook   
The quality gate report can be sent back to jenkins.For this a webhook must be created   
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
