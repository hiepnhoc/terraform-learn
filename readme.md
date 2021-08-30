+ terraform plan                      : plan execute, show attribute object can output or get
+ terraform apply -auto-approve       : auto approve
+ terraform destroy                   : destroy all resource
+ terraform state                     : list object in file terraform tfstate

//use variable: 3 option
//1: input when applu
//2: below
//3: use varfile
+ terraform apply -var "subnet_cidr_block=10.0.30.0/24"

//user variable file depend on environemt, default load file "terraform.tfvars"
+ terraform apply -var-file terraform-dev.tfvars

//use global environment
+ $ export AWS_SECRET_ACCESS_KEY="AKIAYQJPL33KEEFGFOUW"
+ $ export AWS_ACCESS_KEY_ID="AKIAYQJPL33KEEFGFOUW"

+ env | grep AWS
+ aws configure

+ check ENV name such as: AWS_SECRET_ACCESS_KEY,AWS_ACCESS_KEY_ID in link "https://registry.terraform.io/providers/hashicorp/aws/latest/docs"

//user TF environment
+export TF_VAR_avail_zone="ap-southeast-1a"

+ terraform execute code reference dont depend on order code 

+ terraform state show aws_vpc.myapp-vpc
+ aws sts decode-authorization-message --encoded-message encoded-message