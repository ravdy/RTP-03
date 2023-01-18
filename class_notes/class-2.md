## Terraform setup on windows  
##### Software installed on Developer system 
1. terraform
2. awscli
3. mobaxterm/putty 


## Install terraform
download terraform latest version from [here](https://developer.hashicorp.com/terraform/downloads) and install it.

1. Setup environment variable. 
    a. Start searching “edit system environment variables” in the windows search, under advance tab chose Environment variables --> under the System variables select `path` variable

    c. add terraform location in the path variable. 
    system variables --> select path -->  add new --> 
    <terraform_Path>
    _in my system this path location is C:\Program Files\terraform_1.3.7_

To validate java version, run below command. 
   ```sh 
      terraform -version
   ``` 
Output should be something like below 
  ```sh 
  Terraform v1.3.7
  on windows_386
  ```
  
  ### install mobaxterm 
   download and install mobaxterm from [here](https://mobaxterm.mobatek.net/download-home-edition.html)
   
 We are setting up DevOps environment in the AWS cloud so we should install AWSCLI to connect with AWS cloud from windows system 

 ## AWSCLI installation 
download AWSCLI latest version from [here](https://awscli.amazonaws.com/AWSCLIV2.msi) and install it.  
    or 
   Alternatively, you can run the msiexec command to run the MSI installer.
   ```sh 
   msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
   ```

## Connect with AWS cloud 
#### pre-requisites: 
 You should have AWS account 

to connect with AWS cloud we need programmatic access to AWS cloud. 
1. create an IAM programmatic user with administrator access  - (AWS cloud)
1. configure credentials - (user system)
   ```sh 
   aws configure --profile valaxy
   ``` 
1. Test the connection 
   ```sh 
   aws s3 ls 
   ```
   
   Now it’s time to create our EC2 instance. I have created 6 versions for terraform script to create ec2 instance
   1. [v1-ec2.tf](https://github.com/ravdy/RTP-03/tree/main/terraform/v1-EC2) - Just create an ec2 instance
   2. [v2-ec2_with_sg](https://github.com/ravdy/RTP-03/tree/main/terraform/v2-EC2_with_SG) - create an ec2 instance along with security group
   3. [v3-ec2_with_vpc](https://github.com/ravdy/RTP-03/tree/main/terraform/v3-EC2_with_VPC) - create an ec2 instance, security group, VPC, subnet, internet gateway and routetable
   4. [v4-ec2_with_variables](https://github.com/ravdy/RTP-03/tree/main/terraform/v4-EC2_and_VPC_with_Variables) - create an ec2 instance, security group, VPC, subnet, internet gateway and routetable. But values are picked by variables file 
   5. [v5-EC2_and_VPC_with_variables_foreach_and_public_ip](https://github.com/ravdy/RTP-03/tree/main/terraform/v5-EC2_and_VPC_with_variables_foreach_and_public_ip) - create VPC and spin up 2 EC2 instance (Jenkins master and slave). also assign a public IP address for the same 
   6. [v6-EC2_and_VPC_with_variables_and_outputs](https://github.com/ravdy/RTP-03/tree/main/terraform/v6-EC2_and_VPC_with_variables_and_outputs) - create VPC and spin up 2 EC2 instance (Jenkins master and slave). also assign a public IP address for the same. then retrieve values of vpc, public ips, security group and public subnet
