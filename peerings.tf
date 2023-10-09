resource "azurerm_virtual_network_peering" "initiator_to_target" {
  provider = azurerm.initiator

  name                         = var.peerings["source"]["name"]
  resource_group_name          = var.peerings["source"]["resource_group"]
  virtual_network_name         = var.peerings["source"]["vnet"]
  remote_virtual_network_id    = var.peerings["target"].vnet_id == null ? data.azurerm_virtual_network.target.id : var.peerings["target"].vnet_id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
}

resource "azurerm_virtual_network_peering" "target_to_initiator" {
  provider = azurerm.target

  name                         = var.peerings["target"]["name"]
  resource_group_name          = var.peerings["target"]["resource_group"]
  virtual_network_name         = var.peerings["target"]["vnet"]
  remote_virtual_network_id    = var.peerings["source"].vnet_id == null ? data.azurerm_virtual_network.initiator.id : var.peerings["source"].vnet_id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
}
