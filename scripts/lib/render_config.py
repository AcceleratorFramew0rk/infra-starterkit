


import csv
import sys
import os
import yaml
import ipaddress
from jinja2 import Environment, FileSystemLoader, select_autoescape
import json

def get_config(input, solution_accelerator, landingzone_type):

    CONFIGURATION={"services": [
        {"name": "acr", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "ai_foundry_enterprise", "subnet": "AiSubnet_address_prefixes"},
        {"name": "aks_avm_ptn", "subnet": ["SystemNodePoolSubnet_address_prefixes", "UserNodePoolSubnet_address_prefixes", "UserNodePoolIntranetSubnet_address_prefixes"]},
        {"name": "apim", "subnet": "ApiSubnet_address_prefixes"},
        {"name": "app_service", "subnet": ["AppServiceSubnet_address_prefixes", "WebSubnet_address_prefixes"]},
        {"name": "app_service_intranet", "subnet": ["AppServiceIntranetSubnet_address_prefixes", "WebIntranetSubnet_address_prefixes"]},
        {"name": "app_service_windows", "subnet": ["AppServiceSubnet_address_prefixes", "WebSubnet_address_prefixes"]},
        {"name": "ai_search_service", "subnet": ["AiSubnet_address_prefixes", "ServiceSubnet_address_prefixes"]},      
        {"name": "container_app", "subnet": ["ContainerAppSubnet_address_prefixes", "ServiceSubnet_address_prefixes"]},  
        {"name": "container_instance", "subnet": "CiSubnet_address_prefixes"},
        {"name": "cosmos_db_mongo", "subnet": "CosmosDbSubnet_address_prefixes"},
        {"name": "cosmos_db_sql", "subnet": "CosmosDbSubnet_address_prefixes"},
        {"name": "data_explorer", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "event_hubs", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "iot_hub", "subnet": "WebSubnet_address_prefixes"},
        {"name": "keyvault", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "linux_function_app", "subnet": ["FunctionAppSubnet_address_prefixes", "ServiceSubnet_address_prefixes"]},        
        {"name": "logic_app", "subnet": ["LogicAppSubnet_address_prefixes", "ServiceSubnet_address_prefixes"]},     
        {"name": "mssql", "subnet": "DbSubnet_address_prefixes"},
        {"name": "notification_hub", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "postgresql", "subnet": "DbSubnet_address_prefixes"},
        {"name": "redis_cache", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "search_service", "subnet": "AiSubnet_address_prefixes"},
        {"name": "service_bus", "subnet": "ServiceBusSubnet_address_prefixes"},
        {"name": "storage_account", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "stream_analytics", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "vm", "subnet": "AppSubnet_address_prefixes"},
        {"name": "vmss_linux", "subnet": "AppSubnet_address_prefixes"},
        {"name": "vmss_windows", "subnet": "AppSubnet_address_prefixes"},
    ]}

    config_json = CONFIGURATION
    config_data = config_json # json.loads(config_json) if config_json else {}

    # Define subnet variables dynamically
    subnet_vars = {
        # global variables
        "subscription_id": "",
        "tenant_id": "",
        "prefix": "",
        "resource_group_name": "",
        "log_analytics_workspace_resource_group_name": "",
        "log_analytics_workspace_name": "",
        "settings_yaml_file_path": "",       
        "environment": "",
        # application landign zone
        "project_vnet_name": "",
        "devops_vnet_name": "",
        "project_vnet_cidr": "",
        "devops_vnet_cidr": "",
        # infra landing zone
        "hub_ingress_internet_vnet_cidr": "",
        "hub_egress_internet_vnet_cidr": "",
        "hub_ingress_intranet_vnet_cidr": "",
        "hub_egress_intranet_vnet_cidr": "",
        "management_vnet_cidr": "",
        "hub_internet_ingress_AzureFirewallSubnet_address_prefixes": "",
        "hub_internet_ingress_AgwSubnet_address_prefixes": "",
        "hub_internet_egress_AzureFirewallSubnet_address_prefixes": "",
        "hub_internet_egress_AzureFirewallManagementSubnet_address_prefixes": "",
        "hub_intranet_ingress_AzureFirewallSubnet_address_prefixes": "",
        "hub_intranet_ingress_AgwSubnet_address_prefixes": "",
        "hub_intranet_egress_AzureFirewallSubnet_address_prefixes": "",
        "hub_intranet_egress_AzureFirewallManagementSubnet_address_prefixes": "",
        "management_InfraSubnet_address_prefixes": "",
        "management_SecuritySubnet_address_prefixes": "",
        "management_AzureBastionSubnet_address_prefixes": "",
        # project
        "DbSubnet_address_prefixes": "",
        "CosmosDbSubnet_address_prefixes": "",
        "ServiceSubnet_address_prefixes": "",
        "SystemNodePoolSubnet_address_prefixes": "",
        "UserNodePoolSubnet_address_prefixes": "",
        "UserNodePoolIntranetSubnet_address_prefixes": "",
        "AiSubnet_address_prefixes": "",
        "CiSubnet_address_prefixes": "",
        "LogicAppSubnet_address_prefixes": "",
        "AppServiceSubnet_address_prefixes": "",
        "WebSubnet_address_prefixes": "",
        "AppSubnet_address_prefixes": "",
        "FunctionAppSubnet_address_prefixes": "",
        "ApiSubnet_address_prefixes": "",
        "LogicAppSubnet_address_prefixes": "",
        "ServiceBusSubnet_address_prefixes": "",
        "AiSubnet_address_prefixes": "",
        "WebIntranetSubnet_address_prefixes": "",
        "AppServiceIntranetSubnet_address_prefixes": "",
        "ContainerAppSubnet_address_prefixes": "",
        "ContainerAppIntranetSubnet_address_prefixes": "",
        "RunnerSubnet_address_prefixes": ""   
        
    }

    architype = "type7" # custom solution accelerator
    subscription_id = input.get("subscription_id")
    tenant_id = "00000000-0000-0000-0000-000000000000"
    prefix = input.get("prefix")
    resource_group_name = input.get("resource_group_name")
    log_analytics_workspace_resource_group_name = input.get("log_analytics_workspace_resource_group_name")
    log_analytics_workspace_name = input.get("log_analytics_workspace_name")
    settings_yaml_file_path = input.get("settings_yaml_file_path")
    environment = input.get("environment")

    project_vnet_cidr = input.get("vnets").get("project").get("cidr")
    devops_vnet_cidr = input.get("vnets").get("devops").get("cidr")
    internet_ingress_vnet_cidr = input.get("vnets").get("hub_ingress_internet").get("cidr")
    internet_egress_vnet_cidr = input.get("vnets").get("hub_egress_internet").get("cidr")
    intranet_ingress_vnet_cidr = input.get("vnets").get("hub_ingress_intranet").get("cidr")
    intranet_egress_vnet_cidr = input.get("vnets").get("hub_egress_intranet").get("cidr")
    management_vnet_cidr = input.get("vnets").get("management").get("cidr")

    project_vnet_name = input.get("vnets").get("project").get("name")
    devops_vnet_name = input.get("vnets").get("devops").get("name")
    internet_ingress_vnet_name = input.get("vnets").get("hub_ingress_internet").get("name")
    internet_egress_vnet_name = input.get("vnets").get("hub_egress_internet").get("name")
    intranet_ingress_vnet_name = input.get("vnets").get("hub_ingress_intranet").get("name")
    intranet_egress_vnet_name = input.get("vnets").get("hub_egress_intranet").get("name")
    management_vnet_name = input.get("vnets").get("management").get("name")

    subnet_vars["prefix"] = prefix
    subnet_vars["subscription_id"] = subscription_id
    subnet_vars["resource_group_name"] = resource_group_name
    subnet_vars["log_analytics_workspace_resource_group_name"] = log_analytics_workspace_resource_group_name
    subnet_vars["log_analytics_workspace_name"] = log_analytics_workspace_name
    subnet_vars["settings_yaml_file_path"] = settings_yaml_file_path
    subnet_vars["environment"] = environment

        
    # Define the desired subnet prefix length
    # Adjust the prefix length as needed (e.g., /24 for 256 IPs per subnet)
    subnet_prefix_length = 27

    # # init the ingress/egress, management vnets to nothing
    # internet_ingress_vnet_cidr = ""
    # internet_egress_vnet_cidr = ""
    # intranet_ingress_vnet_cidr = ""
    # intranet_egress_vnet_cidr = ""
    # management_vnet_cidr = ""

    if landingzone_type == "application":
    
        # project vnet
        if project_vnet_cidr != "":
            project_vnet = validate_cidr(project_vnet_cidr, "project_vnet_cidr")
            subnet_vars["project_vnet_cidr"] = project_vnet_cidr
            subnet_vars["project_vnet_name"] = project_vnet_name
            # Split the project VNet into subnets of the desired size
            subnets = list(project_vnet.subnets(new_prefix=subnet_prefix_length))
            # Ensure there are enough subnets available
            required_subnets = 8  # As per your requirements
            if len(subnets) < required_subnets:
                raise ValueError(f"Not enough subnets available in {project_vnet_cidr} to allocate {required_subnets} subnets with prefix /{subnet_prefix_length}")
            # Load settings YAML content
            solution_accelerator_data = solution_accelerator 
            # Retrieve the value of ACR
            count = 0
            # Process each service
            for service in config_data.get("services", []):
                service_name = service["name"]
                subnet_keys = service["subnet"]
                print("service_name" + service_name)
                # print("subnet_keys" + subnet_keys)
                # Convert single value to list
                if isinstance(subnet_keys, str):
                    subnet_keys = [subnet_keys]
                # Check if the service is enabled
                current_value = solution_accelerator_data["project"].get(service_name)
                print("current_value" + str(current_value))
                if str(current_value).lower() == "true":
                    
                    print("value is true")

                    for key in subnet_keys:
                        print("key" + key)
                        
                        if subnet_vars[key] == "":
                            subnet_vars[key] = str(subnets[count])
                            print("key" + key)
                            print("subnet_vars[key]" + subnet_vars[key])
                            count += 1

        # devops vent
        if devops_vnet_cidr != "":
            devops_vnet = validate_cidr(devops_vnet_cidr, "devops_vnet_cidr")
            subnet_vars["devops_vnet_cidr"] = devops_vnet_cidr
            subnet_vars["devops_vnet_name"] = devops_vnet_name       
            devops_subnet_prefix_length = 27
            required_devops_subnets = 2  # As per your requirements
            devops_subnets = list(devops_vnet.subnets(new_prefix=devops_subnet_prefix_length))
            if len(devops_subnets) < required_devops_subnets:
                raise ValueError(f"Not enough subnets available in {devops_vnet_cidr} to allocate {required_devops_subnets} subnets with prefix /{devops_subnet_prefix_length}")
            RunnerSubnet_address_prefixes = str(devops_subnets[0]) 
            subnet_vars["RunnerSubnet_address_prefixes"] = RunnerSubnet_address_prefixes
    
    else:
            
        # management vent
        if management_vnet_cidr != "":
            management_vnet = validate_cidr(management_vnet_cidr, "management_vnet_cidr")
            subnet_vars["management_vnet_cidr"] = management_vnet_cidr
            subnet_vars["management_vnet_name"] = management_vnet_name       
            management_subnet_prefix_length = 26
            required_management_subnets = 3  # As per your requirements
            management_subnets = list(management_vnet.subnets(new_prefix=management_subnet_prefix_length))
            if len(management_subnets) < required_management_subnets:
                raise ValueError(f"Not enough subnets available in {management_vnet_cidr} to allocate {required_management_subnets} subnets with prefix /{management_subnet_prefix_length}")
            management_AzureBastionSubnet_address_prefixes = str(management_subnets[0]) 
            management_InfraSubnet_address_prefixes = str(management_subnets[1]) 
            management_SecuritySubnet_address_prefixes = str(management_subnets[2])       
            subnet_vars["management_AzureBastionSubnet_address_prefixes"] = management_AzureBastionSubnet_address_prefixes             
            subnet_vars["management_InfraSubnet_address_prefixes"] = management_InfraSubnet_address_prefixes             
            subnet_vars["management_SecuritySubnet_address_prefixes"] = management_SecuritySubnet_address_prefixes

        # internet ingress vent
        if internet_ingress_vnet_cidr != "":
            internet_ingress_vnet = validate_cidr(internet_ingress_vnet_cidr, "internet_ingress_vnet_cidr")
            subnet_vars["hub_ingress_internet_vnet_cidr"] = internet_ingress_vnet_cidr
            subnet_vars["hub_ingress_internet_vnet_name"] = internet_ingress_vnet_name       
            internet_ingress_subnet_prefix_length = 26
            required_internet_ingress_subnets = 2  # As per your requirements
            internet_ingress_subnets = list(internet_ingress_vnet.subnets(new_prefix=internet_ingress_subnet_prefix_length))
            if len(internet_ingress_subnets) < required_internet_ingress_subnets:
                raise ValueError(f"Not enough subnets available in {internet_ingress_vnet_cidr} to allocate {required_internet_ingress_subnets} subnets with prefix /{internet_ingress_subnet_prefix_length}")
            hub_internet_ingress_AgwSubnet_address_prefixes = str(internet_ingress_subnets[0]) 
            hub_internet_ingress_AzureFirewallSubnet_address_prefixes = str(internet_ingress_subnets[1])     
            subnet_vars["hub_internet_ingress_AgwSubnet_address_prefixes"] = hub_internet_ingress_AgwSubnet_address_prefixes             
            subnet_vars["hub_internet_ingress_AzureFirewallSubnet_address_prefixes"] = hub_internet_ingress_AzureFirewallSubnet_address_prefixes     

        # intranet ingress vent
        if intranet_ingress_vnet_cidr != "":
            intranet_ingress_vnet = validate_cidr(intranet_ingress_vnet_cidr, "intranet_ingress_vnet_cidr")
            subnet_vars["hub_ingress_intranet_vnet_cidr"] = intranet_ingress_vnet_cidr
            subnet_vars["hub_ingress_intranet_vnet_name"] = intranet_ingress_vnet_name       
            intranet_ingress_subnet_prefix_length = 26
            required_intranet_ingress_subnets = 2  # As per your requirements
            intranet_ingress_subnets = list(intranet_ingress_vnet.subnets(new_prefix=intranet_ingress_subnet_prefix_length))
            if len(intranet_ingress_subnets) < required_intranet_ingress_subnets:
                raise ValueError(f"Not enough subnets available in {intranet_ingress_vnet_cidr} to allocate {required_intranet_ingress_subnets} subnets with prefix /{intranet_ingress_subnet_prefix_length}")
            hub_intranet_ingress_AgwSubnet_address_prefixes = str(intranet_ingress_subnets[0]) 
            hub_intranet_ingress_AzureFirewallSubnet_address_prefixes = str(intranet_ingress_subnets[1])     
            subnet_vars["hub_intranet_ingress_AgwSubnet_address_prefixes"] = hub_intranet_ingress_AgwSubnet_address_prefixes             
            subnet_vars["hub_intranet_ingress_AzureFirewallSubnet_address_prefixes"] = hub_intranet_ingress_AzureFirewallSubnet_address_prefixes     


    # updated subnet assignments
    print(json.dumps(subnet_vars, indent=2))
    cidr_mappings = subnet_vars # json.dumps(subnet_vars, indent=2)
    
    # Step 4: Apply the replacement and save the result
    config_yaml = render_config_yaml("template.jinja", cidr_mappings)

    return config_yaml

def validate_cidr(cidr, name):
    """
    Validate a CIDR block and return it as an IPv4 network object.
    """
    try:
        return ipaddress.ip_network(cidr)
    except ValueError as e:
        raise ValueError(f"Invalid {name}: {e}")

def validate_subnet_count(subnets, required, cidr, prefix_length):
    """
    Ensure the number of available subnets meets the required count.
    """
    if len(subnets) < required:
        raise ValueError(
            f"Not enough subnets available in {cidr} to allocate {required} subnets with prefix /{prefix_length}"
        )

def render_config_yaml(template_name: str, context: dict):
    # Set up the Jinja2 environment

    print(os.getcwd())

    env = Environment(
        loader=FileSystemLoader(searchpath="./../templates"),
        autoescape=select_autoescape(['jinja', 'html', 'xml'])
    )

    # Load the template
    template = env.get_template(template_name)

    print(template)

    # Render the template with the context
    rendered_content = template.render(context)

    return rendered_content

def save_yaml(content, output_path):
    with open(output_path, 'w') as file:
        yaml.dump(content, file)

def main():

    # Ensure the script is called with the YAML file path as an argument
    if len(sys.argv) < 2:
        print("Usage: python3 render_config.py <settings_yaml_file_path> <landingzone_type>")
        sys.exit(1)

    # Path to the YAML file
    input_yaml_file_path = './../config/input.yaml' # '/tf/avm/scripts/input.yaml'
    solution_accelerator_yaml_file_path =  sys.argv[1] # '/tf/avm/scripts/settings.yaml'

    landingzone_type =  sys.argv[2] # application or infrastrucutre'
    print("landingzone type: ", landingzone_type)
    if landingzone_type not in ["application", "infrastructure", "1", "2"]:
        print("Usage: python3 render_config.py <settings_yaml_file_path> <landingzone_type>")
        sys.exit(1)

    if landingzone_type == "1":
        landingzone_type = "application"

    # Read and parse the YAML file
    with open(input_yaml_file_path, 'r') as file:
        input_config = yaml.safe_load(file)

    # Read and parse the YAML file
    with open(solution_accelerator_yaml_file_path, 'r') as file1:
        solution_accelerator = yaml.safe_load(file1)

    config_yaml = get_config(input_config, solution_accelerator, landingzone_type)

    print(config_yaml)

    # # Open the file "config/output_config.yaml" in write mode ('w') and print to it
    # with open('./../config/output_config.yaml', 'w') as file:
    #     print(config_yaml, file=file)

    # Open the file "output/output_config.yaml" in write mode ('w') and print to it
    with open('./../output/output_config.yaml', 'w') as file:
        print(config_yaml, file=file)

if __name__ == '__main__':
    main()