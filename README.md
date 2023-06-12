# terraform-module-vnet-peering
This is a module to use when creating a peering between virtual networks (VNets). The idea is to have a centralised module that facilitates the VNets peering.
 
## Usage 

To use the peering module, it defines a VNet [peering](https://github.com/hmcts/aks-cft-deploy/blob/main/components/network/peering.tf) 
configuration and reuses it across different environments. This promotes code reuse, reduces duplication, and ensures consistent configuration across the infrastructure.
# Example 

The following example shows how to use module for peering vnets.
```json
module "vnet_peer_hub_prod" {
  source = "github.com/hmcts/terraform-module-vnet-peering"


  peerings = {
    source = {
      name           = "hub"
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
```
