
# Cloning the starter repository

The starter repository contains the basic configuration files and scenarios. It will allow you to compose your configuration files in the integrated environment.
Clone the repository using the following command:

```bash
git clone https://github.com/AcceleratorFramew0rk/starterkit.git
```
OR

Download the repo as a zip file.

* Open working folder with Visual Studio Code (Note: Reopen in container when prompt in VS Code)
  * (if required) Install VS Code Extension - Dev Containers
* Add a zsh terminal from VS Code
* Follow the steps in README.md file
  
# Deployment - For NEW deployment only.

- ** IMPORTANT: Edit the settings.yaml file to select which azure resources you want to deploy

- Execute the install script:
```bash
sudo chmod -R -f 777 /tf/avm/scripts
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration
# 0-1-2: 0-launchpad, landing zone and solution accelerator
cd /tf/avm/scripts/bin
./install.sh
# follow the instruction to enter PREFIX, PROJECT_VNET, DEVOPS VNET, ENVIRONMENT, Landingzone Type (app or infra)
```

  - If ran without options, the install script will first perform the infrastructure deployment through terraform using configuration in settings.yaml by default.



cd /tf/avm/scripts/bin
sudo mv terraform-init /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform-init