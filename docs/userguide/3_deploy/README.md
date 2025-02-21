Phase 3 - Run
Phase 3 of the accelerator is to run pipeline. Follow the steps below to do that.

Deploy the Landing Zone
Now you have created your bootstrapped environment you can deploy you Azure landing zone by triggering the continuous delivery pipeline in your version control system.

If you encounter permission errors while running the pipelines, please note that it may take some time for permissions to fully propagate. Although the pipelines include retry logic to manage this, it can sometimes take up to 30 minutes for the permissions to take effect.
Azure DevOps
Navigate to dev.azure.com and sign in to your organization.
Navigate to your project.
Click Pipelines in the left navigation.
Click the 02 Azure Landing Zones Continuous Delivery pipeline.
Click Run pipeline in the top right.
Take the defaults and click Run.
Your pipeline will run a plan.
If you provided apply_approvers to the bootstrap, it will prompt you to approve the apply stage.
Your pipeline will run an apply and deploy an Azure landing zone based on the starter module you choose.
GitHub
Navigate to github.com.
Navigate to your repository.
Click Actions in the top navigation.
Click the 02 Azure Landing Zones Continuous Delivery pipeline in the left navigation.
Click Run workflow in the top right, then keep the default branch and click Run workflow.
Your pipeline will run a plan.
If you provided apply_approvers to the bootstrap, it will prompt you to approve the apply job.
Your pipeline will run an apply and deploy an Azure landing zone based on the starter module you choose.
Local file system
Follow the steps below to deploy the landing zone locally. If you want to hook it up to you custom version control system, follow their documentation on how to that.

Bicep
The Bicep option outputs a deploy-local.ps1 file that you can use to deploy the ALZ.

If you set the grant_permissions_to_current_user input to false in the bootstrap, you will need to set permissions on your management group, subscriptions and storage account before the commands will succeed.
Ensure you have the latest versions of the AZ PowerShell Module and Bicep installed.
Open a new PowerShell Core (pwsh) terminal or use the one you already have open.
Navigate to the directory shown in the module_output_directory_path output from the bootstrap.
Login to Azure using Connect-AzAccount -TenantId 00000000-0000-0000-0000-000000000000 -SubscriptionId 00000000-0000-0000-0000-000000000000.
(Optional) Examine the ./scripts/deploy-local.ps1 to understand what it is doing.
Run ./scripts/deploy-local.ps1.
A what if will run and then you’ll be prompted to check it and run the deploy.
Type yes and hit enter to run the deploy.
The ALZ will now be deployed, this may take some time.
Terraform
The Terraform option outputs a deploy-local.ps1 file that you can use to deploy the ALZ.

If you set the grant_permissions_to_current_user input to false in the bootstrap, you will need to set permissions on your management group, subscriptions and storage account before the commands will succeed.
Open a new PowerShell Core (pwsh) terminal or use the one you already have open.
Navigate to the directory shown in the module_output_directory_path output from the bootstrap.
(Optional) Ensure you are still logged in to Azure using az login --tenant 00000000-0000-0000-0000-000000000000.
(Optional) Connect to your target subscription using az account set --subscription 00000000-0000-0000-0000-000000000000.
(Optional) Examine the ./scripts/deploy-local.ps1 to understand what it is doing.
Run ./scripts/deploy-local.ps1.
A plan will run and then you’ll be prompted to check it and run the deploy.
Type yes and hit enter to run the deploy.
The ALZ will now be deployed, this may take some time.
Fin
This concludes the accelerator. You now have a fully deployed Azure landing zone. If you have any issues, please raise them in the GitHub issues.

gdoc_arrow_left_alt
Local File System with Terraform
Advanced scenarios
gdoc_arrow_right_alt