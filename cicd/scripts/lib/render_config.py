


import csv
import sys
import os
import yaml
import ipaddress
from jinja2 import Environment, FileSystemLoader, select_autoescape
import json

def get_config(input, solution_accelerator, landingzone_type):

    CONFIGURATION={"services": [
        {"name": "SqlServer", "subnet": "DbSubnet_address_prefixes"},
        {"name": "CosmosDB", "subnet": "CosmosDbSubnet_address_prefixes"},
        {"name": "MySql", "subnet": "DbSubnet_address_prefixes"},
        {"name": "Postgresql", "subnet": "DbSubnet_address_prefixes"},
        {"name": "StorageAccount", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "ServiceBus", "subnet": "ServiceBusSubnet_address_prefixes"},
        {"name": "EventHub", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "RedisCache", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "AKS", "subnet": ["SystemNodePoolSubnet_address_prefixes", "UserNodePoolSubnet_address_prefixes", "UserNodePoolIntranetSubnet_address_prefixes"]},
        {"name": "AppService", "subnet": ["AppServiceSubnet_address_prefixes", "WebSubnet_address_prefixes"]},
        {"name": "ContainerInstance", "subnet": "CiSubnet_address_prefixes"},
        {"name": "APIM", "subnet": "ApiSubnet_address_prefixes"},
        {"name": "LinuxFunctionApp", "subnet": ["FunctionAppSubnet_address_prefixes", "ServiceSubnet_address_prefixes"]},        
        {"name": "ContainerApp", "subnet": ["ContainerAppSubnet_address_prefixes", "ServiceSubnet_address_prefixes"]},        
        {"name": "LogicApp", "subnet": ["LogicAppSubnet_address_prefixes", "ServiceSubnet_address_prefixes"]},     
        {"name": "VM", "subnet": "AppSubnet_address_prefixes"},
        {"name": "IoTHub", "subnet": "WebSubnet_address_prefixes"},
        {"name": "DataExplorer", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "StreamAnalytics", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "AIFoundary", "subnet": "AiSubnet_address_prefixes"},
        {"name": "SearchService", "subnet": "AiSubnet_address_prefixes"},
        {"name": "ACR", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "KeyVault", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "NotificationHub", "subnet": "ServiceSubnet_address_prefixes"},
        {"name": "FrontDoor", "subnet": "ServiceSubnet_address_prefixes"},
        # {"name": "app_service_intranet", "subnet": ["AppServiceIntranetSubnet_address_prefixes", "WebIntranetSubnet_address_prefixes"]},
        # {"name": "app_service_windows", "subnet": ["AppServiceSubnet_address_prefixes", "WebSubnet_address_prefixes"]},
        # {"name": "azure_open_ai", "subnet": "AiSubnet_address_prefixes"},
        # {"name": "app_service_windows", "subnet": ["ContainerAppSubnet_address_prefixes", "WebSubnet_address_prefixes"]},        
        # {"name": "containter_instance_avm", "subnet": "CiSubnet_address_prefixes"},
        # {"name": "cosmos_db_mongo", "subnet": "DbSubnet_address_prefixes"},
        # {"name": "data_explorer", "subnet": "ServiceSubnet_address_prefixes"},
        # {"name": "vmss_linux", "subnet": "AppSubnet_address_prefixes"},
        # {"name": "vmss_windows", "subnet": "AppSubnet_address_prefixes"},
    ]}

    config_json = CONFIGURATION
    config_data = config_json # json.loads(config_json) if config_json else {}

    # Define subnet variables dynamically
    subnet_vars = {
        # global variables
        "subscription_id": "",
        "tenant_id": "",
        "prefix": "",
        "environment": "",
        # application landign zone
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
    environment = input.get("environment")

    project_vnet_cidr = input.get("vnets").get("project").get("cidr")
    print("project_vnet_cidr: " + project_vnet_cidr)
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
    subnet_vars["environment"] = environment

        
    # Define the desired subnet prefix length
    # Adjust the prefix length as needed (e.g., /24 for 256 IPs per subnet)
    subnet_prefix_length = 27
    devops_subnet_prefix_length = 27

    # init the ingress/egress, management vnets to nothing
    internet_ingress_vnet_cidr = ""
    internet_egress_vnet_cidr = ""
    intranet_ingress_vnet_cidr = ""
    intranet_egress_vnet_cidr = ""
    management_vnet_cidr = ""

    project_vnet = validate_cidr(project_vnet_cidr, "project_vnet_cidr")
    devops_vnet = validate_cidr(devops_vnet_cidr, "devops_vnet_cidr")

    subnet_vars["project_vnet_cidr"] = project_vnet_cidr
    subnet_vars["devops_vnet_cidr"] = devops_vnet_cidr


    # Split the project VNet into subnets of the desired size
    subnets = list(project_vnet.subnets(new_prefix=subnet_prefix_length))
    devops_subnets = list(devops_vnet.subnets(new_prefix=devops_subnet_prefix_length))

    # Ensure there are enough subnets available
    required_subnets = 8  # As per your requirements
    required_devops_subnets = 2  # As per your requirements
    if len(subnets) < required_subnets:
        raise ValueError(f"Not enough subnets available in {project_vnet_cidr} to allocate {required_subnets} subnets with prefix /{subnet_prefix_length}")

    if len(devops_subnets) < required_devops_subnets:
        raise ValueError(f"Not enough subnets available in {devops_vnet_cidr} to allocate {required_devops_subnets} subnets with prefix /{devops_subnet_prefix_length}")


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


    # devops
    subnet_vars["RunnerSubnet_address_prefixes"]  = str(devops_subnets[0]) 
    

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

    # # Ensure the script is called with the YAML file path as an argument
    # if len(sys.argv) < 2:
    #     print("Usage: python3 render_config.py <settings_yaml_file_path> <landingzone_type>")
    #     sys.exit(1)

    # Path to the YAML file
    input_yaml_file_path = './../config/input.yaml' # '/tf/avm/scripts/input.yaml'
    solution_accelerator_yaml_file_path =  './../config/settings.yaml' # sys.argv[1] # '/tf/avm/scripts/settings.yaml'

    landingzone_type =  "1" # sys.argv[2] # application or infrastrucutre'
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

    print(input_config)
    print(solution_accelerator)
    print(landingzone_type)

    config_yaml = get_config(input_config, solution_accelerator, landingzone_type)

    print(config_yaml)

    # Open the file in write mode ('w') and print to it
    with open('./../config/output_config.yaml', 'w') as file:
        print(config_yaml, file=file)
  
if __name__ == '__main__':
    main()