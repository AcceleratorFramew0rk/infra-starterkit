Phase 2 - Bootstrap
Phase 2 of the accelerator is to run the bootstrap. Follow the steps below to do that.

1 - Install the ALZ PowerShell module
The ALZ PowerShell module is used to run the bootstrap phase. It is available on the PowerShell Gallery. You can install it using the following steps:

Open a PowerShell Core (pwsh) terminal.

Double check you are running in a PowerShell Core terminal. Run $psversiontable to check.
Check if you already have the ALZ module installed by running Get-InstalledModule -Name ALZ. You’ll see something like this if it is already installed:

Version    Name                                Repository           Description
-------    ----                                ----------           -----------
1.0.0      ALZ                                 PSGallery            Azure Landing Zones Powershell Module
If the module is already installed, run Update-Module -Name ALZ to ensure you have the latest version.
If the module is not installed, run Install-Module -Name ALZ.
2 - Learn about the configuration
You are now ready to run the bootstrap and setup your environment.

If you want to use custom names for your bootstrap resources or automate the bootstrap, please refer to our FAQs section.
There are 3 sets of configuration that can be supplied to the accelerator to pre-configure it.

The available configuration inputs are:

Bootstrap Configuration File
Platform Landing Zone Configuration File
Platform Landing Zone Library (lib) Folder
Bootstrap Configuration File
This is the YAML file used to provide the configuration choices required to bootstrap your version control system and Azure.

We provide examples of this file for each version control system, which can be found in the relevant section for your chosen Infrastructure as Code (IaC) tool and Version Control System combination.

Some of this configuration is also fed into the starter module to avoid duplication of inputs. This includes management group ID, subscriptions IDs, starter locations, etc. You will see a terraform.tfvars.json file is created in your repository after the bootstrap has run for this purpose.
Platform Landing Zone Configuration File
This file is currently only required for the Terraform Azure Verified Modules for Platform Landing Zone (ALZ) starter module. Bicep, Terraform SLZ and Terraform FSI users can skip this section.
This is the tfvars file in HCL format that determines which resources are deployed and what type of hub networking connectivity is deployed.

This file is validated by the accelerator and then directly copied to your repository, so it retains the ordering, comments, etc. You will see the file is renamed to *.auto.tfvars, so that it is automatically picked up by Terraform.

We provide examples of this file for each scenario. These can be found in the Scenarios documentation.

Platform Landing Zone Library (lib) Folder
This folder is currently only required for the Terraform Azure Verified Modules for Platform Landing Zone (ALZ) starter module. Bicep, Terraform SLZ and Terraform FSI users can skip this section.
This is a folder of configuration files used to customize the management groups and associated policies. This library and its usage is documented alongside the avm-ptn-alz module. However, we cover a common customization use case in our Options documentation.

By default we supply an empty lib folder. This folder can be overridden with a set of files to customize Management Groups and Policy Assignments. Use cases include:

Renaming management groups
Customizing the management group structure
Removing policy assignments
Adding custom policy definitions and assignments
The detailed documentation for the library and it’s usage can be found here:

Platform Landing Zone Library Documentation
Azure Verified Module for Management Groups and Policy
3 - Choose your Infrastructure as Code tool and Version Control System
Bicep
Click through to the relevant page for detailed instructions:

Azure DevOps with Bicep
GitHub with Bicep
Local File System
Terraform
Click through to the relevant page for detailed instructions:

Azure DevOps with Terraform
GitHub with Terraform
Local File System with Terraform
Next Steps
Once the steps in the specific section are completed, head to Phase 3.

gdoc_arrow_left_alt
Authenticating via Service Principal
Azure DevOps with Bicep
gdoc_arrow_right_alt