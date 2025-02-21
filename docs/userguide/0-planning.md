Process 0: planning

1. fill up the /tf/avm/scripts/config/input.yaml with the following information

# project subscription id
subscription_id: "0b5b13b8-0ad7-4552-936f-8fae87e0633f"
# naming convention and environment [dev, sit, uat, prd]
prefix: "abc-dev-sea"
is_prefix: false
is_single_resource_group: false
environment: "dev"
# virtual network name and cidr - leave blank if the virtual network does not exists
vnets:
  hub_ingress_internet: 
    name:   
    cidr: 
  hub_egress_internet:  
    name:   
    cidr: 
  hub_ingress_intranet:  
    name:  
    cidr: 
  hub_egress_intranet:  
    name:    
    cidr: 
  management:  
    name:     
    cidr: 
  project:  
    name: "gcci-vnet-project"
    cidr: "100.64.0.0/23"
  devops:  
    name: "gcci-vnet-devops"  
    cidr: "100.127.4.0/24"  

2. determine what azure resource you want to deploy in /tf/avm/scripts/config/settings.yaml

# Instructions:
# - Set a resource's value to `true` if you want it to be deployed.
# - Set a resource's value to `false` if you DO NOT want it to be deployed.

hub_internet_ingress:
  agw: false
  firewall_ingress: false
  frontdoor: false
hub_internet_egress:
  firewall_egress: false
hub_intranet_ingress:
  agw: false
  firewall_ingress: false
hub_intranet_egress:
  firewall_egress: false
management:
  bastion_host: false
  vm: false
devops:
  containter_instance: true
project:
  acr: true
  ai_foundry_enterprise: false
  aks_avm_ptn: false
  apim: false
  app_service: false
  app_service_intranet: false
  app_service_windows: false
  azure_open_ai: false
  container_app: false
  container_instance: false
  cosmos_db_mongo: false
  cosmos_db_sql: false
  data_explorer: false
  event_hubs: false
  iot_hub: false
  keyvault: false
  linux_function_app: false
  logic_app: false
  mssql: false
  redis_cache: false
  search_service: false
  service_bus: false
  storage_account: false
  stream_analytics: false
  vm: false

3. perform deployment

cd /tf/avm/scripts/bin

install.sh


