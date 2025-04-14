resource "azurerm_resource_group" "lon2_lab" {
  name     = "lon2-lab-rg"
  location = "UK South"
}
output "resource_group" {
  value       = azurerm_resource_group.lon2_lab.name
}
