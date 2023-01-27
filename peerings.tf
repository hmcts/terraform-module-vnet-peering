resource "azurerm_virtual_network_peering" "initiator_to_target" {
  provider = azurerm.initiator

  name                         = var.peerings["source"]["name"]
  resource_group_name          = var.peerings["source"]["resource_group"]
  virtual_network_name         = var.peerings["source"]["vnet"]
  remote_virtual_network_id    = data.azurerm_virtual_network.target.id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
}

resource "azurerm_virtual_network_peering" "target_to_initiator" {
  provider = azurerm.target

  name                         = var.peerings["target"]["name"]
  resource_group_name          = var.peerings["target"]["resource_group"]
  virtual_network_name         = var.peerings["target"]["vnet"]
  remote_virtual_network_id    = data.azurerm_virtual_network.initiator.id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
}

#resource "azurerm_virtual_network_peering" "initiator_to_target" {
#  name                         = "peer1to2"
#  virtual_network_name         = var.virtual_network_name1
#  remote_virtual_network_id    = var.vnetid1
#  resource_group_name          = var.resource_grp_name1
#  allow_virtual_network_access = var.virtual_network_access1
#  allow_forwarded_traffic      = var.allow_forwarded_traffic1
#  allow_gateway_transit        = var.allow_gateway_transit1
#  use_remote_gateways          = var.use_remote_gateways1
#}
#
#resource "azurerm_virtual_network_peering" "target_to_initiator" {
#  name                         = "peer2to1"
#  resource_group_name          = var.resource_grp_name2
#  virtual_network_name         = var.virtual_network_name2
#  remote_virtual_network_id    = var.vnetid2
#  allow_virtual_network_access = var.virtual_network_access2
#  allow_forwarded_traffic      = var.allow_forwarded_traffic2
#  allow_gateway_transit        = var.allow_gateway_transit2
#  use_remote_gateways          = var.use_remote_gateways2
#}
