provider "azurerm" {
  features {}
}

# Configure Terraform backend
terraform {
  required_version = "~> 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.105"
    }
  }
  backend "azurerm" {}
}
