# tf-aws-infra

## Overview
This repository contains Terraform configuration files to set up a sample AWS infrastructure. The setup includes creating a Virtual Private Cloud (VPC), subnets, route tables, and an Internet Gateway across multiple availability zones. and also an EC2 instance which has the custom AMI built using the packer that has the running application

## pre requisites
1. **Terraform** (version >= 1.0)
2. **AWS CLI** with all the access configured for each profile and added access keys
then export the profile to be used using export AWS_PROFILE="profilename"

### 1. Download and unzip the folder
- Download the ZIP file containing the Terraform configuration.

### 2. Naviagte to the folder and initialize terraform setup
terraform init

### 3. Verify the resources to be created using the given code
terraform plan -var-file="filename"

### 4. Apply the resources to be created using the given code give yes when prompted
terraform apply -var-file="filename"

### 5. Destroy the resources if required
terraform destroy -var-file="filename"