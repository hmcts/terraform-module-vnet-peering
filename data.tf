data "azurerm_virtual_network" "initiator" {
  provider = azurerm.initiator

  count               = var.peerings["source"].vnet_id == null ? 1 : 0
  name                = var.peerings["source"]["vnet"]
  resource_group_name = var.peerings["source"]["resource_group"]
}

data "azurerm_virtual_network" "target" {
  provider = azurerm.target

  count               = var.peerings["target"].vnet_id == null ? 1 : 0
  name                = var.peerings["target"]["vnet"]
  resource_group_name = var.peerings["target"]["resource_group"]
}
