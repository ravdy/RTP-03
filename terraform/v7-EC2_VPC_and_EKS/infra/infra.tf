provider "aws" {
  region     = "ap-south-1"
  profile = "valaxy"
 }

 module "aws-vpc" {
    source = "../vpc"
}
module "sgs" {
    source = "../sg_eks"
    vpc_id  =  module.aws-vpc.VPC_name
}

module "eks" {
    source = "../eks"
    vpc_id  =  module.aws-vpc.VPC_name
    subnet_ids = [module.aws-vpc.public-subnet1,module.aws-vpc.public-subnet2]
    sg_ids = module.sgs.security_group_public
}
