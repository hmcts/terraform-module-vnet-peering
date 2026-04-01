# terraform-module-vnet-peering

This is a module to use when creating a peering between virtual networks (VNets). The idea is to have a centralised module that facilitates the VNets peering.

By default, the module creates full VNet peerings. Subnet peering is available as an opt-in mode for new peerings only.

## Usage

To use the peering module, it defines a VNet [peering](https://github.com/hmcts/aks-cft-deploy/blob/main/components/network/peering.tf)
configuration and reuses it across different environments. This promotes code reuse, reduces duplication, and ensures consistent configuration across the infrastructure.

## Example

The following example shows how to use module for peering vnets.

```hcl
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

## Subnet Peering

Subnet peering is opt-in. Existing module calls continue to create full VNet peerings unless `peer_complete_virtual_networks_enabled` is set to `false` and each side provides `subnet_names`.

```hcl
module "vnet_peer_cross_tenant_subnet" {
  source = "github.com/hmcts/terraform-module-vnet-peering"

  peer_complete_virtual_networks_enabled = false

  peerings = {
    source = {
      name           = "app-to-partner"
      vnet           = module.network.network_name
      resource_group = module.network.network_resource_group
      subnet_names   = ["app", "private-endpoints"]
    }
    target = {
      name           = "partner-to-app"
      vnet           = "partner-vnet"
      resource_group = "partner-network-rg"
      subnet_names   = ["shared-services"]
    }
  }

  providers = {
    azurerm.initiator = azurerm
    azurerm.target    = azurerm.partner
  }
}
```

## Cross-Tenant Peering

Cross-tenant peering is supported by this module through aliased AzureRM providers. Each side of the peering must be authenticated with a provider that has the required access in that tenant/subscription.


> **Note:** For cross-tenant operations, you must use the `auxiliary_tenant_ids` argument in your provider blocks. See the [official documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/authenticate-multi-tenant#header-values-for-authentication) for details.

### Example: Cross-Tenant Full VNet Peering (with auxiliary_tenant_ids)

```hcl
# Root module: configure two providers, each with different tenant/subscription and auxiliary_tenant_ids
provider "azurerm" {
  alias                = "initiator"
  subscription_id      = var.source_subscription_id
  tenant_id            = var.source_tenant_id
  auxiliary_tenant_ids = [var.target_tenant_id]
  features {}
}

provider "azurerm" {
  alias                = "target"
  subscription_id      = var.target_subscription_id
  tenant_id            = var.target_tenant_id
  auxiliary_tenant_ids = [var.source_tenant_id]
  features {}
}

module "vnet_peer_cross_tenant" {
  source = "github.com/hmcts/terraform-module-vnet-peering"

  peerings = {
    source = {
      name           = "source-to-target"
      vnet           = var.source_vnet_name
      resource_group = var.source_rg
    }
    target = {
      name           = "target-to-source"
      vnet           = var.target_vnet_name
      resource_group = var.target_rg
    }
  }

  providers = {
    azurerm.initiator = azurerm.initiator
    azurerm.target    = azurerm.target
  }
}
```

### Example: Cross-Tenant Subnet Peering (with auxiliary_tenant_ids)

```hcl
# Root module: configure two providers, each with different tenant/subscription and auxiliary_tenant_ids
provider "azurerm" {
  alias                = "initiator"
  subscription_id      = var.source_subscription_id
  tenant_id            = var.source_tenant_id
  auxiliary_tenant_ids = [var.target_tenant_id]
  features {}
}

provider "azurerm" {
  alias                = "target"
  subscription_id      = var.target_subscription_id
  tenant_id            = var.target_tenant_id
  auxiliary_tenant_ids = [var.source_tenant_id]
  features {}
}

module "vnet_peer_cross_tenant_subnet" {
  source = "github.com/hmcts/terraform-module-vnet-peering"

  peer_complete_virtual_networks_enabled = false

  peerings = {
    source = {
      name           = "source-to-target"
      vnet           = var.source_vnet_name
      resource_group = var.source_rg
      subnet_names   = ["app", "private-endpoints"]
    }
    target = {
      name           = "target-to-source"
      vnet           = var.target_vnet_name
      resource_group = var.target_rg
      subnet_names   = ["shared-services"]
    }
  }

  providers = {
    azurerm.initiator = azurerm.initiator
    azurerm.target    = azurerm.target
  }
}
```
