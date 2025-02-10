
# test environment - sandpit cep
# tenant id: goto Portal settings | Directories + subscriptions, look at Directory ID (Tenant id)

# ms non prod
az login --tenant 16b3c013-d300-468d-ac64-7eda0820b6d3 # ms non prod

az account set --subscription 7504c35e-077e-4b6a-b181-5d10324d02da # ms non prod


# sandpit
# [tenant id] e.g. htx sandpit ac20add1-ffda-45c1-adc5-16a0db15810f
az login --tenant ac20add1-ffda-45c1-adc5-16a0db15810f  

# cep
az account set --subscription 6f035180-4066-42f0-b0fa-5fbc1ae67500 

# gcclite
az account set --subscription 0b5b13b8-0ad7-4552-936f-8fae87e0633f 

# smartbfa
fa-sbfa

az account set --subscription 7c091085-02c7-4cd0-91ef-5c7d3595b8b6

App Registration: 
Application (Client ID): bde27af4-3768-48ce-97f6-053c89b1b708
Secret id: de0e3b2c-658c-4169-8f01-53e3408e8f65
Secret: JTf8Q~FCuwOl8L.S63l~jueljl9fgPNK015lNa~D

az account show
          
# MSDN
az login --tenant f0f45587-f234-460d-9571-d588eae95d23
az account set --subscription e22a351f-db36-4a02-9793-0f2189d5f3ab

SUBSCRIPTION_ID="e22a351f-db36-4a02-9793-0f2189d5f3ab"
export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"



# remove resource group for dso leave system
# ---------------------------------------------------------
PREFIX="aoaiuat"
az group delete --name "${PREFIX}-rg-launchpad" --yes -y

az group delete --name "${PREFIX}-rg-solution-accelerators-cosmosdbmongo" --yes -y
az group delete --name "${PREFIX}-rg-solution-accelerators-logicapp" --yes -y
az group delete --name "${PREFIX}-rg-solution-accelerators-appservice" --yes -y
az group delete --name "${PREFIX}-rg-solution-accelerators-keyvault" --yes -y

az group delete --name NetworkWatcherRG --yes -y

az group delete --name gcci-platform --yes -y
az group delete --name gcci-agency-law --yes -y

az group delete --name "${PREFIX}-rg-network-spoke-devops" --yes -y
az group delete --name "${PREFIX}-rg-network-spoke-project" --yes -y

# ---------------------------------------------------------

az group delete --name "${PREFIX}-rg-solution-accelerators-cosmosdbsql" --yes -y

az group delete --name "${PREFIX}-rg-solution-accelerators-storageaccount"

# end remove resource group for dso leave system

/subscriptions/6f035180-4066-42f0-b0fa-5fbc1ae67500/resourceGroups/osscuat-rg-ops-re1-gll/providers/Microsoft.OperationalInsights/workspaces/osscuat-log-agency-law-hto


az ad sp create-for-rbac --name <service_principal_name> --role Contributor --scopes /subscriptions/<subscription_id>

az login --service-principal -u "0854efab-9245-4e7e-997c-2c6efe5140fc" -p "ayC8Q~imqS054ta5lMBlb1Gmw03TCqE3ZHl_Mc60" --tenant ac20add1-ffda-45c1-adc5-16a0db15810f 

az account set --subscription 0b5b13b8-0ad7-4552-936f-8fae87e0633f


export ARM_SUBSCRIPTION_ID="0b5b13b8-0ad7-4552-936f-8fae87e0633f"
export ARM_TENANT_ID="ac20add1-ffda-45c1-adc5-16a0db15810f "
export ARM_CLIENT_ID="0854efab-9245-4e7e-997c-2c6efe5140fc"
export ARM_CLIENT_SECRET="ayC8Q~imqS054ta5lMBlb1Gmw03TCqE3ZHl_Mc60"



export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"


--subscription 

az login \
--service-principal \
-t <Tenant-ID> \
-u <Client-ID> \
-p <Client-secret>

az login --service-principal -u <app-id> -p <password-or-cert> --tenant <tenant>


# use container instance


az group create --name ignite-rg-launchpad --location southeastasia

RG_ID="/subscriptions/6f035180-4066-42f0-b0fa-5fbc1ae67500"

# RG_ID="0b5b13b8-0ad7-4552-936f-8fae87e0633f" 

# cep-vnet-am-devops-prd - recommended vnet name
az group create --name ignite-rg-launchpad --location southeastasia

RG_ID="/subscriptions/6f035180-4066-42f0-b0fa-5fbc1ae67500"

az container create \
  --name aci-platform-runner \
  --resource-group ignite-rg-launchpad \
  --image aztfmod/rover:1.6.4-2311.2003  \
  --vnet ignite-vnet-am-devops-uat \
  --vnet-address-prefix 192.200.1.96/27 \
  --subnet ignite-snet-aci  \
  --subnet-address-prefix 192.200.1.96/28 \
  --assign-identity --scope $RG_ID \
  --cpu 4 \
  --memory 16 \
  --command-line '"/bin/sh" "-c" "git clone https://github.com/mspsdi/caf-terraform-gcc-starter-kit.git /tf/caf; sudo chmod -R -f 777 /tf/caf/.devcontainer; cd /tf/caf/.devcontainer; ./setup.sh; sudo chmod -R -f 777 /tf/caf/ansible; sudo chmod -R -f 777 /tf/caf/definition; while sleep 1000; do :; done"'

#   --command-line '"/bin/sh" "-c" "while sleep 1000; do :; done; git clone https://github.com/mspsdi/caf-terraform-gcc-starter-kit.git /tf/caf; sudo chmod -R -f 777 /tf/caf/.devcontainer; cd /tf/caf/.devcontainer; ./setup.sh"'


sudo chmod -R -f 777 /tf/caf/ansible
sudo chmod -R -f 777 /tf/caf/definition


  --command-line "/bin/bash -c 'mkdir test; touch test/myfile; tail -f /dev/null'"

# OR   --command-line "tail -f /dev/null"
# not working - "git clone https://github.com/mspsdi/caf-terraform-gcc-starter-kit.git /tf/caf"

az container show \
  --resource-group ignite-rg-launchpad \
  --name aci-platform-runner


SP_ID=$(az container show \
  --resource-group ignite-rg-launchpad \
  --name aci-platform-runner \
  --query identity.principalId --out tsv)

az container exec \
  --resource-group ignite-rg-launchpad \
  --name aci-platform-runner \
  --exec-command "/bin/zsh"


# git clone gcc starter kit to /tf/caf folder

git clone https://github.com/mspsdi/caf-terraform-gcc-starter-kit.git /tf/caf

# grant permission for execution

sudo chmod -R -f 777 /tf/caf/.devcontainer
sudo chmod -R -f 777 /tf/caf/ansible
sudo chmod -R -f 777 /tf/caf/definition

# execute setup.sh

cd /tf/caf/.devcontainer
./setup.sh

# login to azure - note: ensure dns is 8.8.8.8 

az login --tenant ac20add1-ffda-45c1-adc5-16a0db15810f  [tenant id] e.g. htx sandpit ac20add1-ffda-45c1-adc5-16a0db15810f

az account set --subscription 6f035180-4066-42f0-b0fa-5fbc1ae67500 # cep

# edit definition files with your subscription id

cd /tf/caf

vi /tf/caf/definition/config_gcc.yaml

# ignite code generation

rover ignite --playbook /tf/caf/ansible/gcc-starter-playbook.yml

sudo chmod -R -f 777 /tf/caf/gcc_starter_ignitexxx_uat

# OPTIONAL: Create GCC Development Environment
```bash
cd /tf/caf/gcc_starter_ignitexxx_uat/landingzone/configuration/gcc_dev_env

terraform init

terraform plan

terraform apply

cd ..

```

# execute script to run the all rover commands for the landing zone and solution accelerators

cd /tf/caf/gcc_starter_ignitexxx_uat

./deploy_platform.sh

# check results






# execute commands line by line

az login --identity

# ** IMPORTANT - set ARM_USE_MSI = true everytime you bring up the zsh terminal
export ARM_USE_MSI=true



# -------------------------------------------------------------------------

az login --tenant ac20add1-ffda-45c1-adc5-16a0db15810f  [tenant id] e.g. htx sandpit ac20add1-ffda-45c1-adc5-16a0db15810f

az account set --subscription 6f035180-4066-42f0-b0fa-5fbc1ae67500 # cep

   
3. azure container instance
```bash
az group create --name ignite-rg-launchpad --location southeastasia

RG_ID="/subscriptions/6f035180-4066-42f0-b0fa-5fbc1ae67500"

az container create \
  --name aci-platform-runner \
  --resource-group ignite-rg-launchpad \
  --image aztfmod/rover:1.6.4-2311.2003  \
  --vnet ignite-vnet-am-devops-uat \
  --vnet-address-prefix 192.200.1.96/27 \
  --subnet ignite-snet-aci  \
  --subnet-address-prefix 192.200.1.96/28 \
  --assign-identity --scope $RG_ID \
  --cpu 4 \
  --memory 16 \
  --command-line '"/bin/sh" "-c" "git clone https://github.com/mspsdi/caf-terraform-gcc-starter-kit.git /tf/caf; sudo chmod -R -f 777 /tf/caf/.devcontainer; cd /tf/caf/.devcontainer; ./setup.sh; sudo chmod -R -f 777 /tf/caf/ansible; sudo chmod -R -f 777 /tf/caf/definition; while sleep 1000; do :; done"'
```
goto azure portal resource group "ignite-rg-launchpad" and select container instance "aci-platform-runner". At the container instance page, open console with zsh terminal

rm /tf/caf/definition/config_gcc.yaml
rm /tf/caf/definition/config_solution_accelerators.yaml
rm /tf/caf/definition/config_application.yaml

cd /tf/caf/definition
ls

vi /tf/caf/definition/config_gcc.yaml
vi /tf/caf/definition/config_solution_accelerators.yaml
vi /tf/caf/definition/config_application.yaml




##### A2. execute rover ignite to generate the terraform configuration files
```bash
cd /tf/caf/ansible
rover ignite --playbook /tf/caf/ansible/gcc-starter-playbook.yml
sudo chmod -R -f 777 /tf/caf/{{gcc_starter_project_folder}}
cd /tf/caf
```

#### A3 Deploy the platform

To continue, goto README.md file 
/tf/caf/{{gcc_starter_project_folder}}/README.md


##### A3.1. OPTIONAL - Preparation - GCC simulator environment ** OPTIONAL

OPTIONAL - create development environment (only for your own test environment)
go to /tf/caf/{{gcc_starter_project_folder}}/gcc-dev-env/README.md and follow the steps


##### A3.2. Deploy the level0 launchpad, level3 networking and level4 solution accelerators 

execute the deploy_platform.sh under the working folder /tf/caf/{{gcc_starter_project_folder}}
```bash
cd /tf/caf/{{gcc_starter_project_folder}}
./deploy_platform.sh
```
