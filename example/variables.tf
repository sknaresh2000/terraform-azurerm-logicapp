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
    nsgrules = map(object({
      priority                     = number
      direction                    = string
      access                       = string
      protocol                     = string
      source_port_range            = string
      destination_port_range       = string
      source_port_ranges           = list(string)
      destination_port_ranges      = list(string)
      source_address_prefix        = string
      destination_address_prefix   = string
      source_address_prefixes      = list(string)
      destination_address_prefixes = list(string)
    }))
  }))
  description = "Details of the subnets that is required to be created"
  default = {
    pe = {
      subnet_name        = "subnet-sa-eus"
      address_prefix     = "10.0.30.64/26"
      nsg_name           = "nsg-sa-eus"
      delegation_details = null
      nsgrules = {
        "Https-In" = {
          priority                     = 210
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          destination_port_range       = "443"
          source_port_ranges           = null
          destination_port_ranges      = null
          source_address_prefix        = "10.0.30.0/26"
          destination_address_prefix   = "10.0.30.64/26"
          source_address_prefixes      = null
          destination_address_prefixes = null
        }
        "Smb-In" = {
          priority                     = 220
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          destination_port_range       = "445"
          source_port_ranges           = null
          destination_port_ranges      = null
          source_address_prefix        = "10.0.30.0/26"
          destination_address_prefix   = "10.0.30.64/26"
          source_address_prefixes      = null
          destination_address_prefixes = null
        }
      }
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
      nsgrules = {
        "Https-Out" = {
          priority                     = 210
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          destination_port_range       = "443"
          source_port_ranges           = null
          destination_port_ranges      = null
          source_address_prefix        = "10.0.30.0/26"
          destination_address_prefix   = "10.0.30.64/26"
          source_address_prefixes      = null
          destination_address_prefixes = null
        }
        "Smb-Out" = {
          priority                     = 220
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          destination_port_range       = "445"
          source_port_ranges           = null
          destination_port_ranges      = null
          source_address_prefix        = "10.0.30.0/26"
          destination_address_prefix   = "10.0.30.64/26"
          source_address_prefixes      = null
          destination_address_prefixes = null
        }
      }
    }
  }
}