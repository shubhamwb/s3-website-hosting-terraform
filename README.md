# s3-website-hosting-terraform

Here we are hosting static website on AWS S3 bucket using terraform

Tools use
- shell scripting
- AWS Cloud
- Terraform

Commands
checking git install or not

git --version

if Yes,
clone git directory

git clone https://github.com/shubhamwb/s3-website-hosting-terraform.git

Enter in directory

cd s3-website-hosting-terraform

change script file permission

chmod +x deploy.sh destroy.sh

deploy terraform script

./deploy.sh

you will get URL of static website check is it assible or not browser

For destroying created resources

./destroy.sh
