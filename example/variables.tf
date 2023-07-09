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

variable "app_name" {
  type        = string
  description = "Name of the application for which the resources are being created"
  default     = "logicapp-module"
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

variable "subnet_prefixes" {
  type = map(object({
    subnet_name    = string
    address_prefix = string
    nsg_name       = string
    delegation_details = object({
      delegation_name = string
      service_name    = string
      actions         = list(string)
    })
  }))
  description = "Details of the subnets that is required to be created"
  default = {
    pe = {
      subnet_name        = "subnet-sa-eus"
      address_prefix     = "10.0.30.64/26"
      nsg_name           = "nsg-sa-eus"
      delegation_details = null
    }
    logicapp = {
      subnet_name    = "subnet-logicapp-eus"
      address_prefix = "10.0.30.0/26"
      nsg_name       = "nsg-logicapp-eus"
      delegation_details = {
        delegation_name = "serverFarms"
        service_name    = "Microsoft.Web/serverFarms"
        actions         = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}