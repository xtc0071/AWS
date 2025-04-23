# AWS
AWS Infrastructure with Terraform 🚀
Automated AWS cloud infrastructure deployment using Terraform, including VPC, Subnets, Security Groups, EC2 Instances, S3 Bucket for state storage, and Apache installation via User Data.
Project Overview
This Terraform-based setup creates:
✅ VPC with configured Route Tables and Internet Gateway
✅ 2-3 Subnets for network segmentation
✅ Security Groups with dynamic rules
✅ S3 Bucket for Terraform state storage
✅ 2 EC2 Instances with auto-deployment of Apache
✅ User Data Script for configuring an Apache web server

Getting Started
1️⃣ Prerequisites
Before running the Terraform code, ensure you have:
- Terraform installed
- AWS CLI configured with credentials
- Appropriate permissions to deploy AWS resources

2️⃣ Clone the repository git clone https://github.com/xtc0071/AWS
cd your-repo-name


3️⃣ Initialize Terraform
terraform init


4️⃣ Plan Deployment
terraform plan


5️⃣ Apply Terraform Configuration
terraform apply -auto-approve



Infrastructure Details
VPC and Subnets
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "Niko VPC" }
}

resource "aws_subnet" "production" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags = { Name = "Production" }
}

resource "aws_subnet" "development" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
  tags = { Name = "Development" }
}


Security Groups
resource "aws_security_group" "my_webserver" {
  name = "Dynamic SG Niko"
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "Dynamic Security Group", Owner = "Niko" }
}


User Data Script (Apache Installation)
#!/bin/bash
yum -y update
yum -y install httpd

cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="grey">
<h2><font color="blue">Build by Terraform <font color="red"> Version-2</font></h2></br></p>
<font color="green"> My Apache Server <br><br>
</body>
</html>
EOF

sudo service httpd start
chkconfig httpd on


Storing Terraform State in S3
terraform {
  backend "s3" {
    bucket = "niko-s3"
    key    = "ver1/terraform.tfstate"
    region = "us-east-2"
  }
}



Project Benefits
✅ Automated provisioning of AWS resources using Terraform
✅ Dynamic infrastructure with scalable components
✅ Secure access management with security groups
✅ State management stored in an S3 bucket


