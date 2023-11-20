# terraform-local.ps1

if ((terraform workspace select aws-ec2-deployment-stack-local 2>$null) -eq $null) {
} else {
    terraform workspace new aws-ec2-deployment-stack-local
}
cd terraform

terraform apply --var-file=./workspaces/local.tfvars --var='profile=' --auto-approve

