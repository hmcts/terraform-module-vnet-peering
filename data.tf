data "azurerm_virtual_network" "initiator" {
  provider = azurerm.initiator

  name                = var.peerings["source"]["vnet"]
  resource_group_name = var.peerings["source"]["resource_group"]
}

data "azurerm_virtual_network" "target" {
  provider = azurerm.target

  name                = var.peerings["target"]["vnet"]
  resource_group_name = var.peerings["target"]["resource_group"]
}