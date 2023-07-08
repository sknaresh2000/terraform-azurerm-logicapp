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
  source                                = "../"
  logic_app_name                        = var.logicapp_name
  sa_name                               = var.sa_name
  service_plan_name                     = var.sp_name
  la_name                               = var.la_name
  app_insights_name                     = var.app_insights_name
  tags                                  = module.tags.tags
  rg_name                               = module.rg.name
  private_endpoint_subnet_id            = module.subnet.id
  private_endpoint_sa_subresource_names = ["blob"]
}

module "virtual_network" {
  source        = "git::https://github.com/sknaresh2000/terraform-azurerm-virtual-network.git?ref=v0.0.1"
  address_space = [var.vnet_address_prefix]
  name          = var.vnet_name
  rg_name       = module.rg.name
  tags          = module.tags.tags
}

module "subnet" {
  source         = "git::https://github.com/sknaresh2000/terraform-azurerm-subnets.git?ref=v0.0.1"
  address_prefix = var.subnet_address_prefix
  name           = var.subnet_name
  nsg_name       = var.nsg_name
  nsg_rg_name    = module.rg.name
  tags           = module.tags.tags
  vnet_name      = module.virtual_network.name
  vnet_rg_name   = module.rg.name
}