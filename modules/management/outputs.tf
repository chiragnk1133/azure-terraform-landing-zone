output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.central.id
}

output "security_action_group_id" {
  value = azurerm_monitor_action_group.security.id
}

