provider "azurerm" {

  features {}

  subscription_id = "65be6098-a1e3-4f7b-93b1-a14c3c8a3154"

}

resource "azurerm_resource_group" "rg" {

  name     = "pruebas-cris"
  location = "eastus"
}