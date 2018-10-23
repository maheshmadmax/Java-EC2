## AWS provider configuration
provider "aws" {
  profile		= "aws"
  region		= "us-east-1"
}

## VPC selection, needed for subnet_ids
data "aws_vpc" "default" {
  default		= true
}

## Subnet_ids selection
data "aws_subnet_ids" "all" {
  vpc_id 		= "${data.aws_vpc.default.id}"
}

## EC2 instance specification
data "aws_ami" "ubuntu_linux" {
  filter {
    name		= "image-ids"
    values		= ["ami-01f77b0e5db3bd6fb"]
  }
}

## Security group for EC2 instance
module "security_group" {
  source		= "terraform-aws-modules/security-group/aws"
  name			= "awsservers"
  description		= "Security group for EC2 instances created with terraform"
  vpc_id		= "${data.aws_vpc.default.id}"
  ingress_cidr_blocks	= ["0.0.0.0/0"]
  ingress_rules		= ["http-80-tcp", "all-icmp"]
  egress_rules		= ["all-all"]
}

## EC2 instance creation
module "ec2_cluster" {
  source			= "terraform-aws-modules/ec2-instance/aws"
  instance_count		= 1
  name				= "auto-tomcat"
  ami				= "${data.aws_ami.ubuntu_linux.id}"
  instance_type			= "t2.micro"
  associate_public_ip_address	= true
  subnet_id			= "${element(data.aws_subnet_ids.all.ids, 0)}"
  tags = {
    Type			= "tf-tomcat"
  }
}