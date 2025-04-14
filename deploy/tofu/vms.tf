resource "azurerm_network_interface" "lon2_lab_vm_nic" {
  name                = "lon2-lab-vm-nic"
  location            = azurerm_resource_group.lon2_lab.location
  resource_group_name = azurerm_resource_group.lon2_lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lon2_lab_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lon2_lab_ip.id
  }
}
output "lon2_lab_vm_admin_username" {
  value       = azurerm_windows_virtual_machine.lab_vm.admin_username
}
output "lon2_lab_vm_public_ip" {
  value       = azurerm_public_ip.lon2_lab_ip.ip_address
}
resource "azurerm_windows_virtual_machine" "lon2_lab_vm" {
  name                = "lon2-lab-vm"
  resource_group_name = azurerm_resource_group.lon2_lab.name
  location            = azurerm_resource_group.lon2_lab.location
  size                = "Standard_B2s"
  admin_username      = "daniela"
  admin_password      = var.lon2_lab_vm_admin_password

  network_interface_ids = [
    azurerm_network_interface.lon2_lab_vm_nic.id
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