output "management_group_ids" {
  description = "Created management group resource IDs."
  value       = module.governance.management_group_ids
}

output "log_analytics_workspace_id" {
  description = "Central Log Analytics workspace ID."
  value       = module.management.log_analytics_workspace_id
}

output "hub_virtual_network_id" {
  description = "Connectivity hub virtual network ID."
  value       = module.connectivity.hub_virtual_network_id
}

output "firewall_private_ip" {
  description = "Azure Firewall private IP when enabled."
  value       = module.connectivity.firewall_private_ip
}

