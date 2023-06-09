# terraform-module-vnet-peering
terraform-module-vnet-peering
 
A module for peering of vnets 
# Example 

The following example shows how to use module for peering vnets.

module "vnet_peer_hub_prod" {
  source = "github.com/hmcts/terraform-module-vnet-peering"

  for_each = toset([for r in local.regions : r if contains(local.hub_to_env_mapping["prod"], var.env)])

  peerings = {
    source = {
      name           = (var.env == "ptl") || (var.env == "dev") ? "${local.hub["prod"][each.key].peering_name}-prod" : local.hub["prod"][each.key].peering_name
      vnet           = module.network.network_name
      resource_group = module.network.network_resource_group
    }
    target = {
      name           = format("%s%s", var.project, var.env)
      vnet           = local.hub["prod"][each.key].name
      resource_group = local.hub["prod"][each.key].name
    }
  }

  providers = {
    azurerm.initiator = azurerm
    azurerm.target    = azurerm.hub-prod
  }
}
