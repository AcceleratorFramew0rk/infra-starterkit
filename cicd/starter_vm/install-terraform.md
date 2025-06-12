# Define the desired Terraform version
# TERRAFORM_VERSION="1.5.6"
TERRAFORM_VERSION="1.12.1"

# Download the Terraform binary
curl -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Unzip the Terraform binary
sudo apt-get install -y unzip
unzip terraform.zip

# if unzip not working, use windows unzip

# Move the Terraform binary to a directory in your PATH
sudo mv terraform /usr/local/bin/

# Verify the installation
terraform -version