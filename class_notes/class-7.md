# Deploy using Jenkins job. 

So far, We ran manifest files directly on the build server for the deployment. Now let's set up a Jenkins job.

1. Commit namespace.yaml, secret.yaml, deployment.yaml, service.yaml files along with deploy.sh file in the repository 


1. Append the below stage to the existing Jenkinsfile  
   ```sh
   stage(" Deploy ") {
          steps {
            script {
               echo '<--------------- Deploy Started --------------->'
               sh './deploy.sh'
               echo '<--------------- Deploy Ends --------------->'
            }
          }
        } 
   ```

1. execute the job and access the application
   ```sh
   http://<Jenkins_IP>:30082/trends/?placeid=2295420&count=5
   ```

Troubleshoot: 

`issue 1:` The connection to the server localhost:8080 was refused - did you specify the right host or port?

   *Make sure to check the jenkins user should have access to the cluster. If you are using ec2-user, then setup Kubernetes credentials in the ec2-user account*

`Issue 2:` Got permission denied while connecting to the Docker daemon socket at unix:///var/run/docker.sock: Post 
  *Give full permissions to /var/run/docker.sock* 

`Issue 3:` home/ec2-user/jenkins/workspace/ttrend_pipeline_job@tmp/durable-7d91fc59/script.sh: line 1: ./deploy.sh: Permission denied
  Solutions: Commit deploy.sh file with execution in GitHub 
  ```sh 
   git update-index --chmod=+x deploy.sh - to change permissions
  ```

Same we can achieve with Helm

# helm setup 

1. install helm
 ```sh 
 curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
 chmod 700 get_helm.sh
 ./get_helm.sh
 ```
1. Validate helm installation 
   ```sh
   helm version
   helm list
   ```
1. Download .kube/config file to build the node 
   ```sh
   aws eks update-kubeconfig --region ap-south-1 --name ed-eks-01
   ```

1. Setup helm repo 
   ```sh 
   helm repo list
   helm repo add stable https://charts.helm.sh/stable
   helm repo update
   helm search repo <helm-chart>
   helm search repo stable
   ```

1. install msql charts on Kubernetes 
   ```sh 
   helm install repo stable/mysql 
   ```
1. To pull the package from repo to local 
   ```sh 
   helm pull stable/mysql 
   ```

  *Once you have downloaded the helm chart, it comes as a zip file. You should extract it.* 

  In this directory, you can find 
  templates
  values.yaml
  README.md
  Chart.yaml

  If you'd like to change the chart, please update your templates directory  and modify the version (1.6.9 to 1.7.0) in the chart.yaml

then you can run the command to pack it after your update
```sh
 helm package mysql
```

Could you make sure you have modified the version to keep it safe side?

to deploy helm chat
```sh 
 helm install mysqldb mysql-1.6.9.tgz
```

Above command deploy MySQL 
to check this 
```sh 
 helm list 
```
to uninstall 
```sh 
 helm uninstall mysqldb
```

to install nginx 
```sh 
 helm repo search nginx 
 helm install demo-nginx stable/nginx-ingress
```
===========================================

# create a custom helm chart

1. To create a helm chart template 
   ```sh 
   helm create ttrend
   ```

    by default, it contains 
    values.yaml
    templates
    Charts.yaml
    charts

2. Replace the template directory with the manifest files and package it
   ```sh
   helm package ttrend
   ```
3. Change the version number in the 
   ```sh 
   helm install ttrend ttrend-0.1.0.tgz
   ```

4. Create a jenkins job for the deployment 
   ```sh 
   stage(" Deploy ") {
          steps {
            script {
               echo '<--------------- Helm Deploy Started --------------->'
               sh 'helm install ttrend ttrend-0.1.0.tgz'
               echo '<--------------- Helm deploy Ends --------------->'
            }
          }
        }
   ```

5. To list installed helm deployments
   ```sh 
   helm list -a
   ```

Other useful commands
1. to change the default namespace to valaxy
   ```sh
   kubectl config set-context --current --namespace=valaxy
   ```