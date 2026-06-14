resource "azurerm_resource_group" "management" {
  name     = "rg-${var.prefix}-management-${var.location}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "central" {
  name                = "law-${var.prefix}-central-${var.location}"
  location            = azurerm_resource_group.management.location
  resource_group_name = azurerm_resource_group.management.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  daily_quota_gb      = 10
  tags                = var.tags
}

resource "azurerm_automation_account" "operations" {
  name                         = "aa-${var.prefix}-operations-${var.location}"
  location                     = azurerm_resource_group.management.location
  resource_group_name          = azurerm_resource_group.management.name
  sku_name                     = "Basic"
  local_authentication_enabled = false
  tags                         = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_monitor_action_group" "security" {
  name                = "ag-${var.prefix}-security"
  resource_group_name = azurerm_resource_group.management.name
  short_name          = "security"
  tags                = var.tags

  email_receiver {
    name          = "cloud-security"
    email_address = var.security_contact_email
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "azure_activity_deletions" {
  name                 = "alert-${var.prefix}-critical-resource-deletions"
  resource_group_name  = azurerm_resource_group.management.name
  location             = azurerm_resource_group.management.location
  scopes               = [azurerm_log_analytics_workspace.central.id]
  description          = "Alerts on successful delete operations in centralized Azure Activity logs."
  severity             = 1
  enabled              = true
  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"

  criteria {
    query                   = "AzureActivity | where OperationNameValue endswith '/delete' and ActivityStatusValue == 'Success'"
    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"
  }

  action {
    action_groups = [azurerm_monitor_action_group.security.id]
  }

  tags = var.tags
}

resource "azurerm_security_center_subscription_pricing" "virtual_machines" {
  count = var.enable_defender_for_cloud ? 1 : 0

  tier          = "Standard"
  resource_type = "VirtualMachines"
  subplan       = "P2"
}

resource "azurerm_security_center_subscription_pricing" "storage" {
  count = var.enable_defender_for_cloud ? 1 : 0

  tier          = "Standard"
  resource_type = "StorageAccounts"
  subplan       = "DefenderForStorageV2"
}

resource "azurerm_security_center_subscription_pricing" "key_vaults" {
  count = var.enable_defender_for_cloud ? 1 : 0

  tier          = "Standard"
  resource_type = "KeyVaults"
}

