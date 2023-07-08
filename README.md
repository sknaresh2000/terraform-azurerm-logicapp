## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.logicapp_appinsights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_log_analytics_workspace.logicapp_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_logic_app_standard.logicapp-standard](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_standard) | resource |
| [azurerm_private_endpoint.pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_service_plan.logicapp-plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_storage_account.sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS | `string` | `"LRS"` | no |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | Defines the Tier to use for this storage account. Valid options are Standard and Premium | `string` | `"Standard"` | no |
| <a name="input_allow_nested_items_to_be_public"></a> [allow\_nested\_items\_to\_be\_public](#input\_allow\_nested\_items\_to\_be\_public) | Allow or disallow nested items within this Account to opt into being public | `bool` | `false` | no |
| <a name="input_app_insights_name"></a> [app\_insights\_name](#input\_app\_insights\_name) | Name of app insights to enable | `string` | n/a | yes |
| <a name="input_blob_versioning_enabled"></a> [blob\_versioning\_enabled](#input\_blob\_versioning\_enabled) | Is blob versioning enabled | `bool` | `false` | no |
| <a name="input_container_info"></a> [container\_info](#input\_container\_info) | Details about the containers that needs to be created | <pre>map(object({<br>    access_type = string<br>  }))</pre> | `{}` | no |
| <a name="input_cross_tenant_replication_enabled"></a> [cross\_tenant\_replication\_enabled](#input\_cross\_tenant\_replication\_enabled) | Should cross Tenant replication be enabled? | `bool` | `false` | no |
| <a name="input_enable_https_traffic_only"></a> [enable\_https\_traffic\_only](#input\_enable\_https\_traffic\_only) | Boolean flag which forces HTTPS if enabled | `bool` | `true` | no |
| <a name="input_is_manual_connection"></a> [is\_manual\_connection](#input\_is\_manual\_connection) | Does the Private Endpoint require Manual Approval from the remote resource owner? | `string` | `false` | no |
| <a name="input_la_name"></a> [la\_name](#input\_la\_name) | Name of log analytics workspace | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the resouces that will be created | `string` | `"eastus"` | no |
| <a name="input_logic_app_name"></a> [logic\_app\_name](#input\_logic\_app\_name) | The name of the logic app to create | `string` | n/a | yes |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Network & Firewall settings for storage account | <pre>object({<br>    bypass_services_info        = list(string)<br>    default_action              = string<br>    allowed_ips                 = list(string)<br>    service_endpoint_subnet_ids = list(string)<br>  })</pre> | `null` | no |
| <a name="input_private_dns_zone_info"></a> [private\_dns\_zone\_info](#input\_private\_dns\_zone\_info) | Details about DNS zones | <pre>object({<br>    dns_zone_name = string<br>    dns_zone_ids  = list(string)<br>  })</pre> | `null` | no |
| <a name="input_private_endpoint_sa_subresource_names"></a> [private\_endpoint\_sa\_subresource\_names](#input\_private\_endpoint\_sa\_subresource\_names) | A list of subresource names which the Private Endpoint is able to connect to. | `list(string)` | `null` | no |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | Details of the subnet id where the private endpoint needs to be configured | `string` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether the public network access is enabled? | `bool` | `false` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group where the resources should be created | `string` | n/a | yes |
| <a name="input_sa_key"></a> [sa\_key](#input\_sa\_key) | The access key which will be used to access the backend storage account for the Logic App | `string` | `null` | no |
| <a name="input_sa_name"></a> [sa\_name](#input\_sa\_name) | The name of the storage account to create if use\_existing\_storage\_account is set to false. If its true, provide the name of the existing storage account to be linked with logic app standard. | `string` | n/a | yes |
| <a name="input_service_plan_name"></a> [service\_plan\_name](#input\_service\_plan\_name) | The name which should be used for this Service Plan. | `string` | n/a | yes |
| <a name="input_service_plan_ostype"></a> [service\_plan\_ostype](#input\_service\_plan\_ostype) | The O/S type for the App Services to be hosted in this plan. | `string` | `"Windows"` | no |
| <a name="input_service_plan_sku"></a> [service\_plan\_sku](#input\_service\_plan\_sku) | The SKU for the plan. Possible values for logic app include WS1, WS2, WS3 | `string` | `"WS1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Mapping of Tags | `map(any)` | n/a | yes |
| <a name="input_use_existing_la"></a> [use\_existing\_la](#input\_use\_existing\_la) | Use existing log analytics to enable app insights for standard logic app? | `bool` | `false` | no |
| <a name="input_use_existing_storage_account"></a> [use\_existing\_storage\_account](#input\_use\_existing\_storage\_account) | Use existing storage account for standard logic app? | `bool` | `false` | no |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | The log analytics workspace id to enable app insights | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the created Logic App |
