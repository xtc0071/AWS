# 🚀 AWS Infrastructure Deployment with Terraform

This project automates the deployment of a fully functional AWS infrastructure using Terraform. It includes a VPC, subnets, an internet gateway, route tables, EC2 instances with Apache installed, S3 backend for state management, and dynamic security groups.

---

## 📌 Features

- ✅ VPC and subnet creation
- ✅ Internet Gateway and routing
- ✅ Dynamic security group rules (HTTP, HTTPS, SSH, etc.)
- ✅ S3 remote backend for storing Terraform state
- ✅ EC2 instance with Apache web server (via `user_data.sh`)
- ✅ Automated infrastructure deployment with reusable Terraform code

---

## 🛠️ Getting Started

### 📋 Prerequisites

Make sure you have the following installed:

- [Terraform](https://www.terraform.io/downloads)
- [AWS CLI](https://aws.amazon.com/cli/)
- AWS account with proper permissions

### 🔧 Configuration

**Ensure your AWS CLI is configured:**

```aws configure```


## 📁 Clone the repository

bash
```git clone https://github.com/xtc0071/AWS.git```
cd AWS

🔧 Configure AWS CLI
aws configure

☁️ Create an S3 bucket
Make sure you have a bucket ready in AWS (create via AWS Console or CLI). Example CLI command:

```aws s3 mb s3://your-bucket-name```

bash
Копировать
Редактировать



```terraform init
terraform plan
terraform apply -auto-approve```


- ✅ **VPC** with custom CIDR: `10.0.0.0/16`
- ✅ **Subnets**:  
  - 🟦 **Production**: `10.0.1.0/24`  
  - 🟥 **Development**: `10.0.2.0/24`
- ✅ **Internet Gateway** with proper routing
- ✅ **Dynamic Security Groups** allowing ports: *22*, *80*, *443*, *8080*
- ✅ **Apache** installation via *user data* script
- ✅ **Remote backend** using an S3 bucket


🔐 Security Group Configuration
- **Type**: Dynamic ingress rules
- **Allowed Ports**: 
  - _22_ - SSH
  - _80_ - HTTP
  - _443_ - HTTPS
  - _8080_ - Custom HTTP port
- **CIDR**: `0.0.0.0/0`

🧪 **Testing Instructions**
### 🧪 Testing the Infrastructure

After `terraform apply`, follow these steps:

1. Go to the AWS EC2 dashboard.
2. Find the **public IP address** of your instance.
3. Open your browser and navigate to:

**Example**
http:\\public ip :port



