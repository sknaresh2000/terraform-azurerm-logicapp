resource "azurerm_service_plan" "logicapp-plan" {
  name                = var.service_plan_name
  location            = var.location
  resource_group_name = var.rg_name
  sku_name            = var.service_plan_sku
  os_type             = var.service_plan_ostype
  tags                = var.tags
}

resource "azurerm_logic_app_standard" "logicapp-standard" {
  name                       = var.logic_app_name
  location                   = var.location
  resource_group_name        = var.rg_name
  app_service_plan_id        = azurerm_service_plan.logicapp-plan.id
  storage_account_name       = var.sa_name
  virtual_network_subnet_id  = var.logic_app_subnet_id
  storage_account_access_key = var.use_existing_storage_account ? var.sa_key : azurerm_storage_account.sa[0].primary_access_key
  https_only                 = true
  app_settings = {
    "WEBSITE_CONTENTOVERVNET"               = "1"
    "FUNCTIONS_WORKER_RUNTIME"              = "node"
    "WEBSITE_NODE_DEFAULT_VERSION"          = "~14"
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.logicapp_appinsights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.logicapp_appinsights.connection_string
  }

  site_config {
    use_32_bit_worker_process        = true
    ftps_state                       = "Disabled"
    websockets_enabled               = false
    min_tls_version                  = "1.2"
    runtime_scale_monitoring_enabled = false
    vnet_route_all_enabled           = true
  }
}

resource "azurerm_storage_account" "sa" {
  count                            = var.use_existing_storage_account ? 0 : 1
  name                             = var.sa_name
  resource_group_name              = var.rg_name
  location                         = var.location
  account_tier                     = var.account_tier
  account_replication_type         = var.account_replication_type
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  enable_https_traffic_only        = var.enable_https_traffic_only
  allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public
  public_network_access_enabled    = var.public_network_access_enabled
  tags                             = var.tags
  dynamic "network_rules" {
    for_each = var.network_acls != null ? [1] : []
    content {
      bypass                     = var.network_acls.bypass_services_info
      default_action             = var.network_acls.default_action
      ip_rules                   = var.network_acls.allowed_ips
      virtual_network_subnet_ids = var.network_acls.service_endpoint_subnet_ids
    }
  }
  dynamic "blob_properties" {
    for_each = var.blob_versioning_enabled ? [1] : []
    content {
      versioning_enabled = var.blob_versioning_enabled
    }
  }
}

resource "azurerm_storage_share" "logic_app_storage_account_share" {
  name                 = "${var.logicapp_name}-content"
  storage_account_name = var.use_existing_storage_account ? var.sa_name : azurerm_storage_account.sa[0].name
  quota                = "5000"
}

resource "azurerm_private_endpoint" "sa_pe" {
  for_each            = var.use_existing_storage_account ? {} : var.sa_private_dns_zone_info
  name                = format("%s-%s-%s", var.sa_name, each.key, "private-endpoint")
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoint_subnet_id
  private_service_connection {
    name                           = format("%s-%s-%s", var.sa_name, each.key, "private-service-connection")
    private_connection_resource_id = var.use_existing_storage_account ? var.sa_id : azurerm_storage_account.sa[0].id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = [each.key]
  }

  private_dns_zone_group {
    name                 = each.value.dns_zone_name
    private_dns_zone_ids = each.value.dns_zone_ids
  }
}

resource "azurerm_private_endpoint" "logicapp_pe" {
  name                = format("%s-%s", var.logic_app_name, "private-endpoint")
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoint_subnet_id
  private_service_connection {
    name                           = format("%s-%s", var.logic_app_name, "private-service-connection")
    private_connection_resource_id = azurerm_logic_app_standard.logicapp-standard.id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = ["sites"]
  }
  private_dns_zone_group {
    name                 = var.logicapp_private_dns_zone_info.dns_zone_name
    private_dns_zone_ids = var.logicapp_private_dns_zone_info.dns_zone_ids
  }
}

resource "azurerm_log_analytics_workspace" "logicapp_logs" {
  count               = var.use_existing_la ? 0 : 1
  name                = var.la_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "logicapp_appinsights" {
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = var.rg_name
  application_type    = "web"
  workspace_id        = var.use_existing_la ? var.workspace_id : azurerm_log_analytics_workspace.logicapp_logs[0].id
}