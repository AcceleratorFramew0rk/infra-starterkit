cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/app_service_windows

terraform init  -reconfigure \
-backend-config="resource_group_name=uatgla-rg-launchpad" \
-backend-config="storage_account_name=uatglastgtfstatexbs" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-appservice-windows.tfstate"

terraform plan \
-var="storage_account_name=uatglastgtfstatexbs" \
-var="resource_group_name=uatgla-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=uatglastgtfstatexbs" \
-var="resource_group_name=uatgla-rg-launchpad"
