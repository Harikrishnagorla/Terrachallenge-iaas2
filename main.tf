terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
  
}
provider "azurerm" {
    features {
    
    }
  
}
resource "azurerm_resource_group" "terrachallenge" {
  name     = "terrachallenge"
  location = "East US"
}

resource "azurerm_virtual_network" "Terrachallenge-vnet" {
  name                = "Terrachallenge-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

 depends_on = [ azurerm_resource_group.terrachallenge ]

}
resource "azurerm_subnet" "Websubnet" {
  name                 = "Websubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = "Terrachallenge-vnet"
  address_prefixes     = ["10.0.5.0/24"]
  depends_on = [ azurerm_virtual_network.Terrachallenge-vnet ]
  
}
resource "azurerm_subnet" "Jumpboxsubnet" {
  name                 = "Jumpboxsubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = "Terrachallenge-vnet"
  address_prefixes     = ["10.0.3.0/24"]
  depends_on = [ azurerm_virtual_network.Terrachallenge-vnet ]
}
resource "azurerm_subnet" "Datasubnet" {
  name                 = "Datasubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = "Terrachallenge-vnet"
  address_prefixes     = ["10.0.6.0/24"]
  depends_on = [ azurerm_virtual_network.Terrachallenge-vnet ]
}
resource "azurerm_network_security_group" "TerraNSG" {
  name                = "TerraNSG"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on = [ azurerm_resource_group.terrachallenge ]
}
resource "azurerm_public_ip" "pip-test" {
  name                = "pip-test"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  depends_on = [ azurerm_virtual_network.Terrachallenge-vnet ]
}

