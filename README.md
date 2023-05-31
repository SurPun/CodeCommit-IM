# CodeCommit-IM

A CodeCommit Repository with Branch Protection using IM Role

# Notes

-- Terraform Sensitive Output --

terraform output dev_1_id
terraform output dev_1_key

-- Git Config --

git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

-- Git Clone --

git clone https://git-codecommit.eu-west-2.amazonaws.com/v1/repos/YOUR_VALUESR
