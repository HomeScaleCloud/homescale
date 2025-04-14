output "vm_public_ip" {
  description = "Public IP address of the Windows VM"
  value       = azurerm_public_ip.lab_ip.ip_address
}

output "resource_group" {
  description = "Name of the Azure Resource Group"
  value       = azurerm_resource_group.lab.name
}

output "vm_admin_username" {
  description = "Admin username for the VM"
  value       = azurerm_windows_virtual_machine.lab_vm.admin_username
}
