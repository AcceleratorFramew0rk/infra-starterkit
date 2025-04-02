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
  default = "ServiceSubnet"
}

# developer portal variables
# sku_name: Standard_D13_v2 (default Standard_D13_v2)
# sku_capacity: 4 (readonly)
# pep: yes (readonly)
# pte dns: yes (readonly)

variable "sku_name" {
  type        = string  
  default = "Standard_D13_v2"
}

variable "sku_capacity" {
  type        = string  
  default = "4"
}
