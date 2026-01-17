#!/bin/bash
set -e

# Define folder name where repo will be cloned
REPO_DIR="Registration"

if [ -d "$REPO_DIR/.git" ]; then
  echo "Updating existing website repo in $REPO_DIR..."
  cd "$REPO_DIR"
  git pull origin main
  cd ..
else
  echo "Cloning website repo into $REPO_DIR..."
  git clone https://github.com/shubhamwb/Registration.git "$REPO_DIR"
fi

#list file
ls -Rl
rm -rvf .git README.md 
echo "Hello"
#terraform
echo "############################################"
echo "Terraform initialization"
echo "############################################"
terraform init
echo "############################################"
echo "Terraform initialized"
echo "############################################"
terraform plan
terraform apply -auto-approve

