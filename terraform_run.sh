#!/bin/bash

# Source environment variables
. ./terraform_env.sh

# Change to the terraform directory
cd terraform

# Function to run Terraform init
terraform_init() {
    terraform init -reconfigure --backend-config=./backends/${TERRAFORM_CONFIG_FILE}
}

# Function to run Terraform plan for the local workspace
terraform_plan() {
    terraform workspace select ${TERRAFORM_ENVIRONMENT} || terraform workspace new ${TERRAFORM_ENVIRONMENT}
    terraform plan --var-file=./workspaces/${TERRAFORM_VARS_FILE} --var='profile='
}

# Function to run Terraform apply for the local workspace
terraform_apply() {
    terraform workspace select ${TERRAFORM_ENVIRONMENT} || terraform workspace new ${TERRAFORM_ENVIRONMENT}
    terraform apply --var-file=./workspaces/${TERRAFORM_VARS_FILE} --var='profile=' --auto-approve
}

# Function to run Terraform destroy
terraform_destroy() {
    terraform destroy --var-file=./workspaces/${TERRAFORM_VARS_FILE} --var='profile=' --auto-approve
}

# Check the input argument
case $1 in
    "init")
        terraform_init
        ;;
    "plan")
        terraform_plan
        ;;  
    "apply")
        terraform_apply
        ;;
    "destroy")
        terraform_destroy
        ;;
    *)
        echo "Invalid argument. Usage: $0 {init|plan|apply|destroy}"
        exit 1
        ;;
esac
