## Run NodeJs application in Jenkins

### Terminology
`Node.js:`  Node.js is the Javascript runtime environment to execute  Javascript files.

`node:` Node and Node.js both reference the Javascript runtime environment to execute the Javascript files.

`nvm:` Node Version Manager to install/upgrade/manage Node.js Runtime packager/software.

`npm:` Node Package Manager to install third-party libraries and supported plugins/packages to run the Javascript files on the node.js platform.

## Java vs. NodeJS
Purpose        | Java Application   | NodeJS Application
-------------- | ------------------ | -------------
package        | mvn clean install  | npm install
test           | mvn test           | npm test
sonar Analysis | mvn sonar:sonar    | npm run sonar
deploy app     | mvn deploy         | npm publish
dependences    | need pom.xml       | need package.json


### CI/CD pipeline for NodeJS

1. Install npm on the build server
2. clone the code from [here](https://github.com/ravdy/nodejs-project.git)
   ```sh
   git clone https://github.com/ravdy/nodejs-project.git
   ```
3. install nodejs plugin in Jenkins   
   Manage Jenkins --> install plugins --> 'node Js'

4. Configure nodejs in the Global tool configuration 
   Manage Jenkins --> Global tool configuration --> Nodejs
   `Name:` nodejs-16.6
   select install automatically

  `Note`: make sure you selected Amazon Linux supported version
  otherwise, you might encounter an error message like below
    ```sh 
    node: /lib64/libm.so.6: version `GLIBC_2.27' not found (required by node)
    node: /lib64/libc.so.6: version `GLIBC_2.28' not found (required by node)
    ```

   
5. Install npm
   ```sh 
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
   . ~/.nvm/nvm.sh
   nvm install 16
   ```
[source](https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/setting-up-node-on-ec2-instance.html)

5. Create pipeline line job 
   Write Jenkinsfile as mentioned [here](https://raw.githubusercontent.com/ravdy/nodejs-project/main/Jenkinsfile) and commit in the repository 
   ```sh
   def registry = 'https://valaxy02.jfrog.io'
   def imageName = 'valaxy02.jfrog.io/nodejs-docker/demo-nodejs'
   def version   = '2.0.2'
   pipeline{
      agent {
         node {
               label "valaxy"
         }
      }
      tools {nodejs 'nodejs-16'}

      stages {
         stage('checkoutcode'){
               steps {
                  git 'https://github.com/wardviaene/docker-demo.git'
            }
         }
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

