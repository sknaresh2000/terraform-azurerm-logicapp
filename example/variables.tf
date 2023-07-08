variable "logicapp_name" {
  type        = string
  description = "Name of Logic App to create"
  default     = "logicapp-module-eus"
}

variable "service_plan_name" {
  type        = string
  description = "Name of the service plan to create for logic app"
  default     = "sp-logicapp-eus"
}

variable "la_name" {
  type        = string
  description = "Name of the log analytics to be used for app insights"
  default     = "la-logicapp-eus"
}

variable "app_insights_name" {
  type        = string
  description = "Name of the app insights to be enabled for logic app"
  default     = "appinsights-logicapp-eus"
}

variable "sa_name" {
  type        = string
  description = "Name of the storage account to be created for logic app"
  default     = "salogicappeus001"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to create"
  default     = "rg-logicapp-module"
}

variable "vnet_address_prefix" {
  type        = string
  description = "The address prefix that will be used for the creation of VNET"
  default     = "10.0.30.0/24"
}

variable "vnet_name" {
  type        = string
  description = "Name of the VNET that will be created"
  default     = "vnet-logicapp"
}

variable "subnet_address_prefix" {
  type        = string
  description = "The address prefix of the subnet that will be created"
  default     = "10.0.30.0/26"
}

variable "subnet_name" {
  type        = string
  description = "The name of the Vault subnet"
  default     = "subnet-logicapp-eus"
}

variable "nsg_name" {
  type        = string
  description = "The name of the NSG that will be created"
  default     = "nsg-logicapp-eus"
}