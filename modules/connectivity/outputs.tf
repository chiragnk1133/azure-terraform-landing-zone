output "hub_virtual_network_id" {
  value = azurerm_virtual_network.hub.id
}

output "hub_subnet_ids" {
  value = { for key, subnet in azurerm_subnet.hub : key => subnet.id }
}

output "firewall_private_ip" {
  value = var.enable_firewall ? azurerm_firewall.hub[0].ip_configuration[0].private_ip_address : null
}

output "bastion_host_id" {
  value = var.enable_bastion ? azurerm_bastion_host.hub[0].id : null
}

output "bastion_public_ip" {
  value = var.enable_bastion ? azurerm_public_ip.bastion[0].ip_address : null
}

