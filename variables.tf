variable "service_plan_name" {
  type        = string
  description = "The name which should be used for this Service Plan."
}

variable "service_plan_sku" {
  type        = string
  description = "The SKU for the plan. Possible values for logic app include WS1, WS2, WS3"
  default     = "WS1"
}

variable "service_plan_ostype" {
  type        = string
  description = "The O/S type for the App Services to be hosted in this plan."
  default     = "Windows"
}

variable "logic_app_name" {
  type        = string
  description = "The name of the logic app to create"
}

variable "use_existing_storage_account" {
  type        = bool
  description = "Use existing storage account for standard logic app?"
  default     = false
}

variable "use_existing_la" {
  type        = bool
  description = "Use existing log analytics to enable app insights for standard logic app?"
  default     = false
}

variable "la_name" {
  type        = string
  description = "Name of log analytics workspace"
  default     = null
}

variable "app_insights_name" {
  type        = string
  description = "Name of app insights to enable"
}

variable "workspace_id" {
  type        = string
  description = "The log analytics workspace id to enable app insights"
  default     = null
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group where the resources should be created"
}

variable "sa_name" {
  type        = string
  description = "The name of the storage account to create"
}

variable "sa_key" {
  type        = string
  description = "The access key which will be used to access the backend storage account for the Logic App"
  default     = null
}

variable "location" {
  type        = string
  description = "The location of the resouces that will be created"
  default     = "eastus"
}

variable "account_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
  default     = "LRS"
}

variable "tags" {
  type        = map(any)
  description = "Mapping of Tags"
}

variable "cross_tenant_replication_enabled" {
  type        = bool
  description = "Should cross Tenant replication be enabled?"
  default     = false
}

variable "enable_https_traffic_only" {
  type        = bool
  description = "Boolean flag which forces HTTPS if enabled"
  default     = true
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "Allow or disallow nested items within this Account to opt into being public"
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether the public network access is enabled?"
  default     = false
}

variable "network_acls" {
  type = object({
    bypass_services_info        = list(string)
    default_action              = string
    allowed_ips                 = list(string)
    service_endpoint_subnet_ids = list(string)
  })
  description = "Network & Firewall settings for storage account"
  default     = null
}

variable "blob_versioning_enabled" {
  type        = bool
  description = "Is blob versioning enabled"
  default     = false
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Details of the subnet id where the private endpoint needs to be configured"
  default     = null
}

variable "is_manual_connection" {
  type        = string
  description = "Does the Private Endpoint require Manual Approval from the remote resource owner?"
  default     = false
}

variable "private_endpoint_sa_subresource_names" {
  type        = list(string)
  description = "A list of subresource names which the Private Endpoint is able to connect to."
  default     = null
}

variable "container_info" {
  type = map(object({
    access_type = string
  }))
  description = "Details about the containers that needs to be created"
  default     = {}
}

variable "private_dns_zone_info" {
  type = object({
    dns_zone_name = string
    dns_zone_ids  = list(string)
  })
  description = "Details about DNS zones"
  default     = null
}