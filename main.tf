provider "aws" {
  region     = "ap-southeast-1"
#   access_key = "AKIAYQJPL33KEEFGFOUW"
#   secret_key = "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"
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
}

//use TF environemnt: export TF_VAR
variable "avail_zone" {}

variable "subnet_cidr_block" {
  description = "subnet cidr block"
  default     = "10.0.30.0/24"
  type        = string
}

variable "cidr_blocks" {
  description = "cidr block for vpc and subnut"
  //type        = list(string)
  type = list(object({
      cidr_block =string
      name =string
  }))
}


variable "environment" {
  description = "environment deployment"
}

resource "aws_vpc" "development-vpc" {
  //cidr_block = "10.0.0.0/16"
  //cidr_block = var.vpc_cidr_block
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    //Name : "vpc-dev"
    Name: var.cidr_blocks[0].name
  }
}

//create new resource
resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  //cidr_block        = "10.0.10.0/24"
  //cidr_block        = var.subnet_cidr_block
  cidr_block        = var.cidr_blocks[1].cidr_block
  //availability_zone = "ap-southeast-1a"
  availability_zone = var.avail_zone
  tags = {
    Name : "subnet-1-dev"
  }
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id            = aws_vpc.development-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name : "subnet-2-dev"
  }
}


# variable "vpc_id" {}

# data "aws_vpc" "selected" {
#   id = var.vpc_id
# }

# //query existing resouce with filter
# data "aws_vpc" "selected" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "dev-subnet-2" {
#   vpc_id            = data.aws_vpc.selected.id
#   availability_zone = "ap-southeast-1a"
#   cidr_block        = "10.0.1.0/24"
#   tags = {
#       Name: "subnet-2-dev"
#   }
# }

output "dev-vpc-id" {
  value = aws_vpc.development-vpc.id
}

output "dev-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
}
