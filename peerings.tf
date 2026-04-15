locals {
  source_subnet_names = try(var.peerings["source"].subnet_names, [])
  target_subnet_names = try(var.peerings["target"].subnet_names, [])
}

resource "azurerm_virtual_network_peering" "initiator_to_target" {
  provider = azurerm.initiator

  name                                   = var.peerings["source"]["name"]
  resource_group_name                    = var.peerings["source"]["resource_group"]
  virtual_network_name                   = var.peerings["source"]["vnet"]
  remote_virtual_network_id              = var.peerings["target"].vnet_id == null ? data.azurerm_virtual_network.target[0].id : var.peerings["target"].vnet_id
  allow_virtual_network_access           = var.allow_virtual_network_access
  allow_forwarded_traffic                = var.allow_forwarded_traffic
  peer_complete_virtual_networks_enabled = var.peer_complete_virtual_networks_enabled
  local_subnet_names                     = var.peer_complete_virtual_networks_enabled ? null : local.source_subnet_names
  remote_subnet_names                    = var.peer_complete_virtual_networks_enabled ? null : local.target_subnet_names

  lifecycle {
    precondition {
      condition     = var.peer_complete_virtual_networks_enabled ? length(local.source_subnet_names) == 0 && length(local.target_subnet_names) == 0 : length(local.source_subnet_names) > 0 && length(local.target_subnet_names) > 0
      error_message = "Subnet names must be omitted for full VNet peering and provided for both source and target when subnet peering is enabled."
    }

    precondition {
      condition     = length(local.source_subnet_names) <= 200 && length(local.target_subnet_names) <= 200
      error_message = "Azure subnet peering supports a maximum of 200 subnets per side."
    }
  }
}

resource "azurerm_virtual_network_peering" "target_to_initiator" {
  provider = azurerm.target

  name                                   = var.peerings["target"]["name"]
  resource_group_name                    = var.peerings["target"]["resource_group"]
  virtual_network_name                   = var.peerings["target"]["vnet"]
  remote_virtual_network_id              = var.peerings["source"].vnet_id == null ? data.azurerm_virtual_network.initiator[0].id : var.peerings["source"].vnet_id
  allow_virtual_network_access           = var.allow_virtual_network_access
  allow_forwarded_traffic                = var.allow_forwarded_traffic
  peer_complete_virtual_networks_enabled = var.peer_complete_virtual_networks_enabled
  local_subnet_names                     = var.peer_complete_virtual_networks_enabled ? null : local.target_subnet_names
  remote_subnet_names                    = var.peer_complete_virtual_networks_enabled ? null : local.source_subnet_names

  lifecycle {
    precondition {
      condition     = var.peer_complete_virtual_networks_enabled ? length(local.source_subnet_names) == 0 && length(local.target_subnet_names) == 0 : length(local.source_subnet_names) > 0 && length(local.target_subnet_names) > 0
      error_message = "Subnet names must be omitted for full VNet peering and provided for both source and target when subnet peering is enabled."
    }

    precondition {
      condition     = length(local.source_subnet_names) <= 200 && length(local.target_subnet_names) <= 200
      error_message = "Azure subnet peering supports a maximum of 200 subnets per side."
    }
  }
}
