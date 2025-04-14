# Resource Group
resource "azurerm_resource_group" "lab" {
  name     = "hybrid-lab-rg"
  location = "UK South"
}

# Virtual Network
resource "azurerm_virtual_network" "lab_vnet" {
  name                = "lab-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
}

# Subnet
resource "azurerm_subnet" "lab_subnet" {
  name                 = "lab-subnet"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "lab_ip" {
  name                = "lab-public-ip"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Dynamic"
}

# Network Interface
resource "azurerm_network_interface" "lab_nic" {
  name                = "lab-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab_ip.id
  }
}

# Windows VM
resource "azurerm_windows_virtual_machine" "lab_vm" {
  name                = "lab-vm"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = "Standard_B2s"
  admin_username      = "daniela"
  admin_password      = "TempPassword123!" # <-- only for local testing, replace before committing

  network_interface_ids = [
    azurerm_network_interface.lab_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}
