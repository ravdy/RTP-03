## Setup Jenkins Environmentsetup Jenkins server using terraform
as we are setting up jenkins on docker we should install docker also we are exposing jenkins to external using nginx port number 4000

1. run jenkins post-install.sh file to setup docker, and docker compose
2. to provision jenkins and nginx as a container we should have docker-compose and nginx.conf files. clone this from rtp-03
3. run docker-compose up
  ```sh
   docker-compose up -d
   ```
4. expose port 4000 in the sg if you haven't done in the terraform code

### Setup Jenkins slave node
To setup we need java, docker, maven, and GitHub on salve system
1. clone slave-setup.sh from rtp-03
2. run it to setup salve system

### Setup jenkins master and slave
1. add credentials
2. add slave node

Note: remove this env if you wish to set up DevOps environment using ansible
### Setup jenkins environment using ansible

1. setup ansible, Jenkins master, and slave using terraform
2. install ansible server
3. create hosts file in /opt
4. create ansible.cfg file in the /opt
5. copy ssh private keys on /opt onto ansible
6. test the connection using
   ```ssh
     ansible all -m ping
  ```
7. clone ansible scripts from rtp-03/ansible
8. run jenkins post install.yml on jenkins master node
9. run slave-setup.yml on jenkins salve

### Setup jenkins master and slave
