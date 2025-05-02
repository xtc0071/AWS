#Creation of route table
resource "aws_route_table" "your_route_table" {
 vpc_id = aws_vpc.main.id
 tags = {
 Name = "Your Route Table"
 }
}
#Assocation off route table to our IG.
resource "aws_route" "internet_gateway_route" {
 route_table_id = aws_route_table.your_route_table.id
 destination_cidr_block = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.niko_ig.id
}
#Creata Internet gateway
resource "aws_internet_gateway" "niko_ig" {
 vpc_id = aws_vpc.main.id
 tags = {
 Name = "Niko_InternetGateway"
 }
}
#Create Vpc and subnets.
resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 tags = {
 Name = "Niko vpc"
 }
}
resource "aws_subnet" "production" {
 vpc_id = aws_vpc.main.id
 cidr_block = "10.0.1.0/24"
 tags = {
 Name = "Production"
 }
}
resource "aws_subnet" "subnet-Development" {
 vpc_id = aws_vpc.main.id
 cidr_block = "10.0.2.0/24"
 availability_zone = "us-east-2b"
 tags = {
 Name = "Development"
}
}
# Associate the Production subnet with the route table
resource "aws_route_table_association" "production_assoc" {
  subnet_id      = aws_subnet.production.id
  route_table_id = aws_route_table.your_route_table.id
}

# Associate the Development subnet with the route table
resource "aws_route_table_association" "development_assoc" {
  subnet_id      = aws_subnet.subnet-Development.id
  route_table_id = aws_route_table.your_route_table.id
}

############################################
terraform {
  backend "s3" {
    bucket = var.bucket_name
    key    = "ver1/terraform.tfstate"
    region = "us-east-2"
  }
}

#Get latest image of linux
data "aws_ami" "latest_amazon_linux" {
 owners = ["amazon"]
 most_recent = true
 filter {
 name = "name"
 values = ["amzn2-ami-hvm-*-x86_64-gp2"]
 }
}
output "ami_arguments" {
 value =(data.aws_ami.latest_amazon_linux)
}
#Create instance
resource "aws_instance" "tf-niko-production" {
 ami = data.aws_ami.latest_amazon_linux.id
 instance_type = "t2.micro"
 key_name = "niko2"
 subnet_id = aws_subnet.production.id
 associate_public_ip_address = true
 vpc_security_group_ids = [aws_security_group.my_webserver.id]
 user_data = filebase64("./user_data.sh")
 tags= {
 Name= "Niko TF"
 }
}
#Creation of dynamic SG For Every group
resource "aws_security_group" "my_webserver" {
 name = "Dynamic SG Niko"
 vpc_id = aws_vpc.main.id # Required since AWS Provider v4.29+
 dynamic "ingress" {
 for_each = ["80", "443", "8080", "22", ]
 content {
 from_port = ingress.value
 to_port = ingress.value
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 }
 egress {
 from_port = 0
 to_port = 0
 protocol = "-1"
 cidr_blocks = ["0.0.0.0/0"]
 }
 tags = {
 Name = "Dynamic SecurityGroup"
 Owner = "Niko"
 }
}
