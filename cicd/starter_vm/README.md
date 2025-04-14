
# deploy runner (if required)

cd /tf/avm/cicd/starter_vm
./deploy-runner.sh

# login to vm using "azureuser" and cert "id_rsa" from local file.

# create a VM Ubuntu OS


sudo apt update

sudo apt install azure-cli
sudo apt install npm -y
sudo apt install nodejs


       
# indtall yq

# npm install yq

sudo snap install yq

# Define the desired Terraform version

TERRAFORM_VERSION="1.9.0"

# Download the Terraform binary
curl -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Unzip the Terraform binary
sudo apt-get install -y unzip
unzip terraform.zip

# Move the Terraform binary to a directory in your PATH
sudo mv terraform /usr/local/bin/

# Verify the installation
terraform -version

node -v
yq
az


sudo mkdir /tf
sudo mkdir /tf/avm

cd /tf/avm

sudo chmod -R -f 777 /tf/avm

git clone https://github.com/AcceleratorFramew0rk/infra-starterkit .


# Deploy the starter kit
## Login to Azure
```bash
az login --tenant xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # azure tenant id

az account set --subscription xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # subscription id

az account show # to show the current login account

SUBSCRIPTION_ID="xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx"
export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"

# ensure min "execute" right to script to avoid permission issue
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration


# continue with starter kit.


