provider "aws" {
  region = "ap-southeast-1"
  shared_credentials_file = "~/.aws/credentials" # Default
  profile = "default"
}

# new VPC named "vpc_devops" with a Internet Gateway attached to it
resource "aws_vpc" "vpc_devops" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc_devops.id}"
}

resource "aws_route_table" "rtb" {
  vpc_id = "${aws_vpc.vpc_devops.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_main_route_table_association" "rtb_assoc" {
  vpc_id = "${aws_vpc.vpc_devops.id}"
  route_table_id = "${aws_route_table.rtb.id}"
}

# new public subnet named "sub_public_devops"
resource "aws_subnet" "sub_public_devops" {
  vpc_id = "${aws_vpc.vpc_devops.id}"
  cidr_block = "10.0.1.0/20"
  map_public_ip_on_launch = true
}

# new security group named "sg_devops" which allows access from "0.0.0.0/0" for SSH(22) and HTTP(80)
resource "aws_security_group" "sg_devops" {
  name = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic for all IPs"
  vpc_id = "${aws_vpc.vpc_devops.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# new EC2 key pair named "kp_devops"
resource "aws_key_pair" "kp_devops" {
  key_name = "kp_devops"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCeMm7/ZvQ7noM8eodbNnk2R7Yyd4Fq8QXQ3rPP9WnB9PWfBe91y3QyYKfRZCXyLXFIAHmk87OGhriMM7LDZ8vKWfOCED7a18yxXE3WK8C8H+H8w97BDA4dSxqxnvMdICUVaneFhfv92qpJx5VmaIPDxoBrG+YpEADIhmhVSUKWtNKxbHIf/8zvA3ptnUDIrhdJ0w4zrVSNS6dCL93vAn5w+NLylT9NV6eD2zbA0TwtBeHdAhZ4/lBFbpTRpIhzJzFZYjSGpQ46oxxCrHCdojLRsT3a7XLRl0YGVTnjxZXz5eb7PtY1XnUcJze24yKZPbhKQbU7O6hHSuhx14GHv5gR thai@Thais-MacBook-Pro-2018.local"
}

# new EC2 instance of type t2.micro of any linux distro named "ec2_devops", with security group "sg_devops", and accessible by SSH with "kp_devops"
resource "aws_instance" "ec2_devops" {
  ami = "ami-6966b80a"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sg_devops.id}"]
  subnet_id = "${aws_subnet.sub_public_devops.id}"
  key_name = "${aws_key_pair.kp_devops.key_name}"
}

# assign a static public IP to "ec2_devops"
resource "aws_eip" "lb" {
  instance = "${aws_instance.ec2_devops.id}"
  vpc = true
  depends_on = ["aws_internet_gateway.gw"]
}

# and expose this public IP as terraform output
output "eip_public_ip_addr" {
  value = aws_eip.lb.public_ip
}

