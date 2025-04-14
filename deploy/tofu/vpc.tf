resource "azurerm_virtual_network" "lon2_lab_vnet" {
  name                = "lon2-lab-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lon2_lab.location
  resource_group_name = azurerm_resource_group.lon2_lab.name
}
resource "azurerm_subnet" "lon2_lab_subnet" {
  name                 = "lon2-lab-subnet"
  resource_group_name  = azurerm_resource_group.lon2_lab.name
  virtual_network_name = azurerm_virtual_network.lon2_lab_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_public_ip" "lon2_lab_ip" {
  name                = "lon2-lab-public-ip"
  location            = azurerm_resource_group.lon2_lab.location
  resource_group_name = azurerm_resource_group.lon2_lab.name
  allocation_method   = "Dynamic"
}