# insert your variables here
variable "location" {
  type        = string  
  default = "southeastasia"
}

variable "vnet_id" {
  type        = string  
  default = null
}

variable "subnet_id" {
  type        = string  
  default = null
}

variable "log_analytics_workspace_id" {
  type        = string  
  default = null
}

variable "prefix" {
  type        = string  
  default = "aaf"
}

variable "environment" {
  type        = string  
  default = "sandpit"
}

variable "subnet_name" {
  type        = string  
  default = "AiSubnet"
}

# developer portal variables
# sku: "Standard" default (Premium) Possible values include basic, free, standard, standard2, standard3, storage_optimized_l1 and storage_optimized_l2
# PEP: yes (readonly)
# Pte DNS: yes (readonly)


variable "sku" {
  type        = string  
  default = "Standard"
}

