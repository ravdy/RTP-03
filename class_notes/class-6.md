## Setup Kubernetes cluster using terraform 
1. eks module code is available over [here](https://github.com/ravdy/RTP-03/tree/main/terraform/v7-EC2_VPC_and_EKS/eks)  
   Through this eks module we are creating  
    Master node: ed-eks-master  
    IAM policy: AmazonEKSClusterPolicy  
    IAM policy: AmazonEKSServicePolicy  
    IAM policy: AmazonEKSVPCResourceController  
    work node: ed-eks-worker  
    Cluster: ed-eks-01  

1. Copy eks and sg_eks modules onto terraform folder  
2. Create vpc folder and move existing files inside to this  
ec2_instance.tf 
output.tf  
provider.tf  
security_group.tf  
terraform.tfstate  
terraform.tfstate.backup  
variables.tf  
vpc.tf

3. Add one extra subnet in vpc.tf file

```sh
   // Create a Subnet
   resource "aws_subnet" "rtp03-public_subnet_02" {
      vpc_id = "${aws_vpc.rtp03-vpc.id}"
      cidr_block = var.subnet2
      map_public_ip_on_launch = "true"
      availability_zone = "ap-south-1b"
      tags = {
           Name = "rtp03-public_subnet_02"
        }
    }
``` 

4. Add additional subnet association 

```sh 
    resource "aws_route_table_association" "rtp03-rta-public-subnet-2" {
    subnet_id = "${aws_subnet.rtp03-public_subnet_02.id}"
    route_table_id = "${aws_route_table.rtp03-public-rt.id}"

    }
```

5. Add subnet cidr in the variables file 
```sh 
    variable "subnet2" {
      default = "10.2.3.0/24"
    }
``` 

6. dd sg_eks module and eks modules in the vpc.tf file 
```sh 
     module "sgs" {
       source = "../sg_eks"
       vpc_id     =     aws_vpc.rtp03-vpc.id
    }

     module "eks" {
          source = "../eks"
          vpc_id     =     aws_vpc.rtp03-vpc.id
          subnet_ids = [aws_subnet.rtp03-public_subnet_01.id,aws_subnet.rtp03-public_subnet_02.id]
          sg_ids = module.sgs.security_group_public
    }
```

====================================================================

## Integrate build server with Kubernetes cluster 

1. setup kubectl   
   ```sh 
     curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.9/2023-01-11/bin/linux/amd64/kubectl
     chmod +x ./kubectl
     mv ./kubectl /usr/local/bin
     kubectl version
   ``` 

1. Make sure you have installed awscli latest version. If it has awscli version 1.*.* then remove it and install awscli 2  
    ```sh 
     yum remove awscli 
     curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
     unzip awscliv2.zip
     sudo ./aws/install --update
    ```

1. configure awscli to connect with aws account  
    ```sh 
     aws configure
     Provide access_key, secret_key
    ```

1. Download Kubernetes credentials and cluster configuration (.kube/config file) from the cluster  

   ```sh 
    aws eks update-kubeconfig --region ap-south-1 --name ed-eks-01
   ```

## Integrate Jfrog with Kubernetes cluster

1. Create deployment, namespace, and service files   
1. Create a dedicated user to use for a docker login   
     user menu --> new user  
     `user name`: jfrog_docker  
     `email address`: valaxytech@gmail.com  
     `password`: <passwrod>  

1.  `optional` To pull an image from jfrog at the docker level, we should go into jfrog using username and password   
```sh 
 docker login https://valaxy02.jfrog.io
``` 
1. Kubernetes uses credentials as part of the deployment process to pull the image; for this, we must create a secret at the Kubernetes level   
```sh 
   kubectl create secret docker-registry privatecred \
   --docker-server=valaxy02.jfrog.io \
   --docker-username=kubernetes_admin \
   --docker-password=Valaxy@123 \
   --docker-email=arsravis@gmail.com \
   -n valaxy
``` 

  alternatively, you can also run the below command to create secret file   
  ```sh 
   kubectl create secret generic regcred --from-file=.dockerconfigjson=/root/.docker/config.json --type=kubernetes.io/dockerconfigjson -n valaxy -o yaml > secret.yaml
  ```

  anotherway is, genarate encode value for ~/.docker/config.json file 
  ```sh 
   cat ~/.docker/config.json | base64 -w0
   ```
   
`Note:` For more refer to [Kuberentes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/   
Make sure secret value name `regcred` is updated in the deployment file.  

1. To test the deployment, you should run the below command 
   ```sh 
    kubectl apply -f namespace.yaml
    kubectl apply -f secret.yaml
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml
   ```

1. We should use above credentials to use it later through manifest files. For that, take password 
```sh 
  cat /root/.docker/config.json 
  `copy auth value to encode`
  cat ~/.docker/config.json | base64 -w0
  `use above command output in the secret`
```

### Other commands:
1. To decode value 
   ```sh
   echo -n '<encode_value>' | base64 --decode
   ```
1. use blue ocean plugin to get a nice view of logs

1. To know cluster info 
   ```sh 
    kubectl cluster-info
   ```

1. Create secrete through command line 
   ```sh 
    kubectl create secret generic <secret-name> --from-literal=<key>=<value>
    kubectl create secret generic app-secret --from-literal=DB_Host=mysql
     --from-literal=DB_User=mysql
     --from-literal=DB_Password=paswrd

     kubectl get secrtes
     kubectl describe secrets
     kubectl get secrete app-secret -o yaml
   ```
### Troubleshoot: 
Issue 1:
  ```sh
   #aws eks update-kubeconfig --region ap-south-1 --name ed-eks-01
   Unable to locate credentials. You can configure credentials by running "aws configure".
   ```
   `Ensure sure you have setup AWS credentials in the build server`

Issue 2. 
  ```sh
   #kubectl get all
   error: exec plugin: invalid apiVersion "client.authentication.k8s.io/v1alpha1"
  ```
   `Ensure latest version of awscli is installed and remove old awscli version`

Issue 3: 
  ```sh 
  [ec2-user@ip-172-31-49-102 ~]$ kubectl version
  error: exec plugin: invalid apiVersion "client.authentication.k8s.io/v1alpha1"
  ```
  use lower kubectl version then kubernetes verison to address this issue
