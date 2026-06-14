output "hub_virtual_network_id" {
  value = azurerm_virtual_network.hub.id
}

output "hub_subnet_ids" {
  value = { for key, subnet in azurerm_subnet.hub : key => subnet.id }
}

output "firewall_private_ip" {
  value = var.enable_firewall ? azurerm_firewall.hub[0].ip_configuration[0].private_ip_address : null
}

