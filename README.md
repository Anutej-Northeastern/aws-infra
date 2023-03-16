# aws-infra
We are using this repo to implement Infra for AWS upon which the resources will be deployed.

## Terraform 
1. We use HCL to write tf files which will be interacting with the cloud provider to allocate resources as per the specification in the tf files.
2. There are 4 steps involved in creating resources using terraform
   1. Terraform init: this command is used in the root folder where it is initialized `terraform init`
   2. Terraform plan: This command is used to display the list of resources that will be created.
   3. Terraform apply: This command is used to deploy and create the resources in the mentioned cloud provider.
   4. Terraform Destroy: This command checks the tfstate files to check what all resources are deployed and shows what resources will be destroyed.
3. As part of this assignment we are creating following resources:
   1. Create Virtual Private Cloud (VPC)Links to an external site..
   2. Create subnetsLinks to an external site. in your VPC. You must create 3 public subnets and 3 private subnets, each in a different availability zone in the same region in the same VPC.
   3. Create an Internet GatewayLinks to an external site. resource and attach the Internet Gateway to the VPC.
   4. Create a public route tableLinks to an external site.. Attach all public subnets created to the route table.
   5. Create a private route tableLinks to an external site.. Attach all private subnets created to the route table.
   6. Create a public route in the public route table created above with the destination CIDR block 0.0.0.0/0 and the internet gateway created above as the target.

## Notes:
1. We need to make sure that once we make changes to the region in the variable file we need to make changes to availability zones as well in the main and variables file.
2. To add variable while applying run in this format `terraform apply -var "var_name=value"`
3. to apply changes without approval `terraform apply -auto-approve`
4. to apply changes without approval `terraform destroy -auto-approve`