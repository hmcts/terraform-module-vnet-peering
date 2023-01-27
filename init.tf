terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      configuration_aliases = [
        azurerm.initiator,
        azurerm.target
      ]
    }
  }
}