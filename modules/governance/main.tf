locals {
  prefix = lower(var.organization_name)
}

resource "azurerm_management_group" "organization" {
  name                       = local.prefix
  display_name               = var.organization_name
  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_id}"
}

resource "azurerm_management_group" "platform" {
  name                       = "${local.prefix}-platform"
  display_name               = "Platform"
  parent_management_group_id = azurerm_management_group.organization.id
}

resource "azurerm_management_group" "management" {
  name                       = "${local.prefix}-management"
  display_name               = "Management"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "connectivity" {
  name                       = "${local.prefix}-connectivity"
  display_name               = "Connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "identity" {
  name                       = "${local.prefix}-identity"
  display_name               = "Identity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "landing_zones" {
  name                       = "${local.prefix}-landing-zones"
  display_name               = "Landing Zones"
  parent_management_group_id = azurerm_management_group.organization.id
}

resource "azurerm_management_group" "corp" {
  name                       = "${local.prefix}-corp"
  display_name               = "Corp"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "online" {
  name                       = "${local.prefix}-online"
  display_name               = "Online"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "sandbox" {
  name                       = "${local.prefix}-sandbox"
  display_name               = "Sandbox"
  parent_management_group_id = azurerm_management_group.organization.id
}

resource "azurerm_management_group" "decommissioned" {
  name                       = "${local.prefix}-decommissioned"
  display_name               = "Decommissioned"
  parent_management_group_id = azurerm_management_group.organization.id
}

resource "azurerm_management_group_subscription_association" "management" {
  management_group_id = azurerm_management_group.management.id
  subscription_id     = "/subscriptions/${var.management_subscription_id}"
}

resource "azurerm_management_group_subscription_association" "connectivity" {
  management_group_id = azurerm_management_group.connectivity.id
  subscription_id     = "/subscriptions/${var.connectivity_subscription_id}"
}

resource "azurerm_management_group_subscription_association" "identity" {
  management_group_id = azurerm_management_group.identity.id
  subscription_id     = "/subscriptions/${var.identity_subscription_id}"
}

resource "azurerm_policy_definition" "allowed_locations" {
  name                = "${local.prefix}-allowed-locations"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "CAF - Restrict resource locations"
  management_group_id = azurerm_management_group.organization.id

  metadata = jsonencode({
    category = "General"
    version  = "1.0.0"
  })

  parameters = jsonencode({
    allowedLocations = {
      type = "Array"
      metadata = {
        displayName = "Allowed locations"
      }
    }
  })

  policy_rule = file("${path.module}/../../policies/allowed-locations.json")
}

resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  display_name         = "CAF - Allowed Azure regions"
  management_group_id  = azurerm_management_group.organization.id
  policy_definition_id = azurerm_policy_definition.allowed_locations.id

  parameters = jsonencode({
    allowedLocations = {
      value = var.allowed_locations
    }
  })
}

resource "azurerm_policy_definition" "required_tag" {
  for_each = toset(var.required_tags)

  name                = "${local.prefix}-require-${lower(each.value)}"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "CAF - Audit missing ${each.value} tag"
  management_group_id = azurerm_management_group.organization.id

  metadata = jsonencode({
    category = "Tags"
    version  = "1.0.0"
  })

  parameters = jsonencode({
    tagName = {
      type = "String"
      metadata = {
        displayName = "Tag name"
      }
    }
  })

  policy_rule = file("${path.module}/../../policies/require-tag.json")
}

resource "azurerm_management_group_policy_assignment" "required_tag" {
  for_each = toset(var.required_tags)

  name                 = "audit-${lower(each.value)}"
  display_name         = "CAF - Audit ${each.value} tag"
  management_group_id  = azurerm_management_group.landing_zones.id
  policy_definition_id = azurerm_policy_definition.required_tag[each.value].id

  parameters = jsonencode({
    tagName = {
      value = each.value
    }
  })
}

resource "azurerm_policy_definition" "deny_public_ip" {
  name                = "${local.prefix}-deny-public-ip"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "CAF - Deny public IP addresses"
  management_group_id = azurerm_management_group.organization.id

  metadata = jsonencode({
    category = "Network"
    version  = "1.0.0"
  })

  policy_rule = file("${path.module}/../../policies/deny-public-ip.json")
}

resource "azurerm_management_group_policy_assignment" "deny_public_ip_corp" {
  name                 = "deny-public-ip"
  display_name         = "CAF - Deny public IPs in Corp"
  management_group_id  = azurerm_management_group.corp.id
  policy_definition_id = azurerm_policy_definition.deny_public_ip.id
}

resource "azurerm_policy_definition" "require_diagnostic_settings" {
  name                = "${local.prefix}-require-diagnostic-settings"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "CAF - Require diagnostics for firewall and bastion"
  management_group_id = azurerm_management_group.organization.id

  metadata = jsonencode({
    category = "Monitoring"
    version  = "1.0.0"
  })

  policy_rule = file("${path.module}/../../policies/require-diagnostic-settings.json")
}

resource "azurerm_management_group_policy_assignment" "require_diagnostic_settings" {
  name                 = "require-diagnostic-settings"
  display_name         = "CAF - Audit firewall and Bastion diagnostics"
  management_group_id  = azurerm_management_group.platform.id
  policy_definition_id = azurerm_policy_definition.require_diagnostic_settings.id
}

resource "azurerm_management_group_policy_assignment" "security_benchmark" {
  name                 = "azure-security-benchmark"
  display_name         = "Microsoft Cloud Security Benchmark"
  management_group_id  = azurerm_management_group.organization.id
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/c96b1c7e-2084-49c3-b89c-2e003dcd2833"
  location             = var.location

  identity {
    type = "SystemAssigned"
  }
}

