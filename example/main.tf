data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

module "rg" {
  source = "git::https://github.com/sknaresh2000/terraform-azurerm-resource-group.git?ref=v0.0.1"
  name   = var.resource_group_name
  tags   = module.tags.tags
}

module "tags" {
  source   = "git::https://github.com/sknaresh2000/terraform-azurerm-tags.git?ref=v0.0.1"
  app_name = var.app_name
}

module "logicapp" {
  source                         = "../"
  logic_app_name                 = var.logicapp_name
  sa_name                        = var.sa_name
  service_plan_name              = var.service_plan_name
  la_name                        = var.la_name
  app_insights_name              = var.app_insights_name
  tags                           = module.tags.tags
  rg_name                        = module.rg.name
  private_endpoint_subnet_id     = module.subnet["pe"].id
  logic_app_subnet_id            = module.subnet["logicapp"].id
  sa_private_dns_zone_info       = { for k, v in local.sa_private_dns_zone_info : k => merge(v, { dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone[k].id] }) }
  logicapp_private_dns_zone_info = { for k, v in local.logicapp_private_dns_zone_info : k => merge(v, { dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone[k].id] }) }.sites
  public_network_access_enabled  = true
  network_acls                   = local.network_acls
}

module "virtual_network" {
  source        = "git::https://github.com/sknaresh2000/terraform-azurerm-virtual-network.git?ref=v0.0.1"
  address_space = [var.vnet_address_prefix]
  name          = var.vnet_name
  rg_name       = module.rg.name
  tags          = module.tags.tags
}

module "subnet" {
  source             = "git::https://github.com/sknaresh2000/terraform-azurerm-subnets.git?ref=v0.0.1"
  for_each           = var.subnet_prefixes
  address_prefix     = each.value.address_prefix
  name               = each.key
  nsg_name           = each.value.nsg_name
  nsg_rg_name        = module.rg.name
  tags               = module.tags.tags
  vnet_name          = module.virtual_network.name
  vnet_rg_name       = module.rg.name
  delegation_details = each.value.delegation_details
  nsgrules           = each.value.nsgrules
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  for_each            = merge(local.sa_private_dns_zone_info, local.logicapp_private_dns_zone_info)
  name                = each.value.dns_zone_name
  resource_group_name = module.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  for_each              = merge(local.sa_private_dns_zone_info, local.logicapp_private_dns_zone_info)
  name                  = "vnet-${each.key}-link"
  resource_group_name   = module.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone[each.key].name
  virtual_network_id    = module.virtual_network.id
}

locals {
  sa_private_dns_zone_info = {
    blob = {
      dns_zone_name = "privatelink.blob.core.windows.net"
    }
    file = {
      dns_zone_name = "privatelink.file.core.windows.net"
    }
    queue = {
      dns_zone_name = "privatelink.queue.core.windows.net"
    }
    table = {
      dns_zone_name = "privatelink.table.core.windows.net"
    }
  }
  logicapp_private_dns_zone_info = {
    sites = {
      dns_zone_name = "privatelink.azurewebsites.net"
    }
  }
  network_acls = {
    bypass_services_info        = ["None"]
    default_action              = "Deny"
    allowed_ips                 = [data.http.ip.response_body]
    service_endpoint_subnet_ids = null
  }
}