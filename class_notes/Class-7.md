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
  helm search repo <helm-chart>
  helm search repo stable
  ```

1. install msql charts on Kubernetes 
  ```sh 
  helm install repo stable/mysql 
  ``
1. To pull the package from repo to local 
  ```sh 
  helm pull stable/mysql 
  ```

  Once you have downloadedcan chart file downloaded as a zip file you should extract it. 

  in this directory you can find 
  templates
  values.yaml
  README.md
  Chart.yaml

  if you wish to modifiy the chart then update your templates directory 
  then modify version (1.6.9 to 1.7.0) in the chart.yaml



then you can run the command to pack it after your update
```sh
helm package mysql
```

Make sure you have modified the version to keep it safe side

to deploy helm chat
```sh 
 helm install mysqldb mysql-1.6.9.tgz
```

above command deploy msyql 
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

2. update charts with the configuration files

Create a jenkins job for the deployment 
```sh 
pipeline {
   agent any
  stages {
    stage('Build on k8 ') {
      steps {      
            sh 'pwd'
            sh 'cp -R helm/* .'
          sh 'ls -ltr'
            sh 'pwd'
              sh '/usr/local/bin/helm upgrade --install ttrend-app trend --set image.repository=valaxy02.jfrog.io/valaxy-docker-local/ttrend --set image.tag=2.0.2'
      }      
    }
  }
}

```sh
   containers:
   - name: petclinic-container
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
    imagePullPolicy: Always
```


http://54.90.72.20:30082/trends/?placeid=2295420&count=5