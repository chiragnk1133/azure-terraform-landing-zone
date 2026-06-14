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

output "bastion_host_id" {
  description = "Azure Bastion host ID when enabled."
  value       = module.connectivity.bastion_host_id
}

output "bastion_public_ip" {
  description = "Azure Bastion public IP when enabled."
  value       = module.connectivity.bastion_public_ip
}

output "firewall_private_ip" {
  description = "Azure Firewall private IP when enabled."
  value       = module.connectivity.firewall_private_ip
}

