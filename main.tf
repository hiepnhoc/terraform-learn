provider "aws" {
  region = "ap-southeast-1"
  #   access_key = "AKIAYQJPL33KEEFGFOUW"
  #   secret_key = "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"
}

# variable "vpc_cidr_block" {
#   description = "vpc cidr block"
# }

//use TF environemnt: export TF_VAR

# variable "subnet_cidr_block" {
#   description = "subnet cidr block"
#   default     = "10.0.30.0/24"
#   type        = string
# }


variable "vpc_cidr_blocks" {}
variable "subnet_cidr_blocks" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_blocks
  tags = {
    //Name : "vpc-dev"
    Name : "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_blocks
  availability_zone = var.avail_zone
  tags = {
    Name : "${var.env_prefix}-subnet-1"
  }
}

# resource "aws_route_table" "myap-route-table" {
#   vpc_id = aws_vpc.myapp-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.myapp-igw.id
#   }

#   tags = {
#     Name = "${var.env_prefix}-myapp-rtb"
#   }
# }

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name = "${var.env_prefix}-myapp-igw"
  }
}

# resource "aws_route_table_association" "myapp-rtb-subnet" {
#   subnet_id      = aws_subnet.myapp-subnet-1.id
#   route_table_id = aws_route_table.myapp-route-table.id
# }

resource "aws_default_route_table" "myapp-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "${var.env_prefix}-myapp-rtb"
  }
}

resource "aws_default_security_group" "myapp-sg" {
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    // cidr_blocks = [var.my_ip]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-myapp-sg"
  }
}

data "aws_ami" "lastest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "aws_ami_id" {
  value = data.aws_ami.lastest-amazon-linux-image
}

resource "aws_instance" "myapp-server" {
  ami           = data.aws_ami.lastest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_default_security_group.myapp-sg.id]
  availability_zone      = var.avail_zone

  associate_public_ip_address = true
  key_name                    = "SG-KP"

  tags = {
    Name = "${var.env_prefix}-myapp-instance"
  }
}

