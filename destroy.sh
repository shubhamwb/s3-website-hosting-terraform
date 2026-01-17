terraform destroy -auto-approve
rm -rvf Registration    # removing Git Directory
rm -rvf *.tfstate*      # removing terraform state file

ls -Rl
