#!/bin/bash

# Path to Terraform
TERRAFORM_DIR="../infrastructure"

# Path to inventory
INVENTORY_FILE="../inventory/ec2.ini"

# Catch the DNS instance created by Terraform code
DNS=$(terraform -chdir="$TERRAFORM_DIR" output -raw dns)

# Create or overwhite the ec2.ini file
cat <<EOF > "$INVENTORY_FILE"
[webservers]
testserver ansible_host=$DNS ansible_user=ec2-user ansible_private_key_file=/home/renan/Área\ de\ trabalho/ansible-estudos/ansible_up_and_running/cap2/infrastructure/aws_ssh.pem
EOF

echo "The ec2.ini was successfully initialized with this DNS: $DNS"

