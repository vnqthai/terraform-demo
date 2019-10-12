Use Terraform to configure AWS

## Install Terraform

Find a package [here](https://www.terraform.io/downloads.html) corresponding to your OS.

Extract and install it into one of directories in your `PATH`

Run

```
$ terraform
Usage: terraform [-version] [-help] <command> [args]
...
```

to verify installation.

## Install and configure AWS CLI

### Python

[Create](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/) and log in to AWS account if you do not have one.

Check Python installation

```
$ python --version
Python x.x.x
```

If your laptop does hot have Python installed, please download and install it [here](https://www.python.org/downloads/)

### AWS CLI

Run these commands

```
$ curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
$ unzip awscli-bundle.zip
$ sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
```

Verify

```
$ aws --version
aws-cli/x.x.x Python/x.x.x ...
```

### Configure

Open [My security credentials](https://console.aws.amazon.com/iam/home?#/security_credentials) page on your browser.

Click "Create access key" button. Follow instruction, and download secret key file.

Run

```
$ aws configure
```

Enter required data:

* Access Key ID
* Secret Access Key (downloaded)
* Default region name ([Supported Regions and Countries](https://docs.aws.amazon.com/sns/latest/dg/sns-supported-regions-countries.html))
* Default output format (`json`)

Your credentials are now saved in `~/.aws/credentials`

## Prepare Key Pair

Run

```
$ ssh-keygen
```

Enter file in which to save the key: `/Users/name/.ssh/kp_devops`

Copy content of `Uers/name/.ssh/kp_devops.pub` file to `public_key` argument in `example.tf`.

## Configure and Apply Terraform

Create a Terraform file: see `example.tf`.

The `profile`=`default` refers to the AWS Config File in `~/.aws/credentials` that we setted up above.

Run

```
$ terraform init
Initializing the backend...
Initializing provider plugins...
```

to initializes various local settings and data that will be used by subsequent commands.

Run

```
$ terraform apply
```

Input `yes` when a question prompt on screen. It may take 30 seconds to 1 minute to apply resources to AWS.

Last lines of input will look like

```
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

eip_public_ip_addr = <ip_address>
```

Save the `<ip_address>` output for next step.

You can run

```
$ terraform show
```

to inspect the current state.

## SSH to EC2 instance

Run

```
$ ssh -i /Users/name/.ssh/kp_devops root@<ip_address>
```

Input `yes`. Now you are in the EC2 instance on AWS.

You can also go to AWS EC2 Dashboard, VPC Dashboard, Subnets, Route Tables, Internet Gateways, Elastic IPs, Security Group, Key Pairs pages to see your resources status and configurations on AWS.

## Clean up

You can run

```
$ terraform destroy
```

to clean up AWS resources which was started by this Terraform configuration. Input `yes` when required. It may also take about 30 seconds to 1 minute. The last line of output would look like:

```
Destroy complete! Resources: 9 destroyed.
```

## Output

```
$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_eip.lb will be created
  + resource "aws_eip" "lb" {
      + allocation_id     = (known after apply)
      + association_id    = (known after apply)
      + domain            = (known after apply)
      + id                = (known after apply)
      + instance          = (known after apply)
      + network_interface = (known after apply)
      + private_dns       = (known after apply)
      + private_ip        = (known after apply)
      + public_dns        = (known after apply)
      + public_ip         = (known after apply)
      + public_ipv4_pool  = (known after apply)
      + vpc               = true
    }

  # aws_instance.ec2_devops will be created
  + resource "aws_instance" "ec2_devops" {
      + ami                          = "ami-6966b80a"
      + arn                          = (known after apply)
      + associate_public_ip_address  = (known after apply)
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t2.micro"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = "kp_devops"
      + network_interface_id         = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_internet_gateway.gw will be created
  + resource "aws_internet_gateway" "gw" {
      + id       = (known after apply)
      + owner_id = (known after apply)
      + vpc_id   = (known after apply)
    }

  # aws_key_pair.kp_devops will be created
  + resource "aws_key_pair" "kp_devops" {
      + fingerprint = (known after apply)
      + id          = (known after apply)
      + key_name    = "kp_devops"
      + public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCeMm7/ZvQ7noM8eodbNnk2R7Yyd4Fq8QXQ3rPP9WnB9PWfBe91y3QyYKfRZCXyLXFIAHmk87OGhriMM7LDZ8vKWfOCED7a18yxXE3WK8C8H+H8w97BDA4dSxqxnvMdICUVaneFhfv92qpJx5VmaIPDxoBrG+YpEADIhmhVSUKWtNKxbHIf/8zvA3ptnUDIrhdJ0w4zrVSNS6dCL93vAn5w+NLylT9NV6eD2zbA0TwtBeHdAhZ4/lBFbpTRpIhzJzFZYjSGpQ46oxxCrHCdojLRsT3a7XLRl0YGVTnjxZXz5eb7PtY1XnUcJze24yKZPbhKQbU7O6hHSuhx14GHv5gR thai@Thais-MacBook-Pro-2018.local"
    }

  # aws_main_route_table_association.rtb_assoc will be created
  + resource "aws_main_route_table_association" "rtb_assoc" {
      + id                      = (known after apply)
      + original_route_table_id = (known after apply)
      + route_table_id          = (known after apply)
      + vpc_id                  = (known after apply)
    }

  # aws_route_table.rtb will be created
  + resource "aws_route_table" "rtb" {
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + cidr_block                = "0.0.0.0/0"
              + egress_only_gateway_id    = ""
              + gateway_id                = (known after apply)
              + instance_id               = ""
              + ipv6_cidr_block           = ""
              + nat_gateway_id            = ""
              + network_interface_id      = ""
              + transit_gateway_id        = ""
              + vpc_peering_connection_id = ""
            },
        ]
      + vpc_id           = (known after apply)
    }

  # aws_security_group.sg_devops will be created
  + resource "aws_security_group" "sg_devops" {
      + arn                    = (known after apply)
      + description            = "Allow SSH and HTTP inbound traffic for all IPs"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
        ]
      + name                   = "allow_ssh_http"
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + vpc_id                 = (known after apply)
    }

  # aws_subnet.sub_public_devops will be created
  + resource "aws_subnet" "sub_public_devops" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = (known after apply)
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "10.0.1.0/20"
      + id                              = (known after apply)
      + ipv6_cidr_block                 = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = true
      + owner_id                        = (known after apply)
      + vpc_id                          = (known after apply)
    }

  # aws_vpc.vpc_devops will be created
  + resource "aws_vpc" "vpc_devops" {
      + arn                              = (known after apply)
      + assign_generated_ipv6_cidr_block = false
      + cidr_block                       = "10.0.0.0/16"
      + default_network_acl_id           = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_group_id        = (known after apply)
      + dhcp_options_id                  = (known after apply)
      + enable_classiclink               = (known after apply)
      + enable_classiclink_dns_support   = (known after apply)
      + enable_dns_hostnames             = (known after apply)
      + enable_dns_support               = true
      + id                               = (known after apply)
      + instance_tenancy                 = "default"
      + ipv6_association_id              = (known after apply)
      + ipv6_cidr_block                  = (known after apply)
      + main_route_table_id              = (known after apply)
      + owner_id                         = (known after apply)
    }

Plan: 9 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```
