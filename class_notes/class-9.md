## Run NodeJs application in Jenkins

### Terminology
`Node.js:`  Node.js is the Javascript runtime environment to execute  Javascript files.

`node:` Node and Node.js both reference the Javascript runtime environment to execute the Javascript files.

`nvm:` Node Version Manager to install/upgrade/manage Node.js Runtime packager/software.

`npm:` Node Package Manager to install third-party libraries and supported plugins/packages to run the Javascript files on the node.js platform.

## Java vs. NodeJS
Purpose        | Java Application   | NodeJS Application
-------------- | ------------------ | -------------
Package        | mvn clean install  | npm install
Test           | mvn test           | npm test
Sonar Analysis | mvn sonar:sonar    | npm run sonar
Deploy app     | mvn deploy         | npm publish
Dependences    | need pom.xml       | need package.json


### CI/CD pipeline for NodeJS

1. Install npm on Build Server 
   ```sh 
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
   . ~/.nvm/nvm.sh
   nvm install 16
   ```
   Refer bleow document for more info - [source](https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/setting-up-node-on-ec2-instance.html)


1. Install nodejs plugin in Jenkins   
   Manage Jenkins --> install plugins --> 'node Js'

1. Configure nodejs in the Global tool configuration 
   Manage Jenkins --> Global tool configuration --> Nodejs
   `Name:` nodejs-16.6
   select install automatically

  `Note`: make sure you selected Amazon Linux supported version
  otherwise, you might encounter an error message like below   
   ```sh 
    node: /lib64/libm.so.6: version `GLIBC_2.27' not found (required by node)
    node: /lib64/libc.so.6: version `GLIBC_2.28' not found (required by node)  
   ```  
 
   `Check-point`: 
    1. Ensure you have installed 'docker pipeline' and 'nodejs' plugins  
    2. Create repo 'demo-nodejs' on Jfrog artifactory   
    3. add jfrog credentials (here we are using 'jfrog-access')  
1. Create Pipeline job for NodeJS and use below repository to get the code
   ```sh
   git clone https://github.com/ravdy/nodejs-project.git
   ```
   
   Write Jenkinsfile as mentioned [here](https://raw.githubusercontent.com/ravdy/nodejs-project/main/Jenkinsfile) and commit in the repository 
   ```sh
   def registry = 'https://valaxy02.jfrog.io'
   def imageName = 'valaxy02.jfrog.io/nodejs-docker/demo-nodejs'
   def version   = '1.0.0'
   pipeline{
      agent {
         node {
               label "valaxy"
         }
      }
      tools {nodejs 'nodejs-16'}

      stages {
         stage('build') {
               steps{
                  echo "------------ build started ---------"
                     sh "npm install"
                  echo "------------ build completed ---------"
         }
         }

         stage('Unit Test') {
               steps {
                  echo '<--------------- Unit Testing started  --------------->'
                  sh 'npm test'
                  echo '<------------- Unit Testing stopped  --------------->'
               }
         }

   stage(" Docker Build ") {
         steps {
         script {
            echo '<--------------- Docker Build Started --------------->'
            app = docker.build(imageName+":"+version)
            echo '<--------------- Docker Build Ends --------------->'
         }
         }
      }

      stage (" Docker Publish "){
         steps {
               script {
                  echo '<--------------- Docker Publish Started --------------->'  
                  docker.withRegistry(registry, 'jfrog-access'){
                     app.push()
                  }    
                  echo '<--------------- Docker Publish Ended --------------->'  
               }
         }
      }  
     }
   }
   ``` 

