resource "azurerm_resource_group" "connectivity" {
  name     = "rg-${var.prefix}-connectivity-${var.location}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_network_ddos_protection_plan" "hub" {
  count = var.enable_ddos_protection ? 1 : 0

  name                = "ddos-${var.prefix}-${var.location}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  tags                = var.tags
}

resource "azurerm_virtual_network" "hub" {
  name                = "vnet-${var.prefix}-hub-${var.location}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  address_space       = var.hub_address_space
  tags                = var.tags

  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_protection ? [1] : []
    content {
      id     = azurerm_network_ddos_protection_plan.hub[0].id
      enable = true
    }
  }
}

resource "azurerm_subnet" "hub" {
  for_each = var.hub_subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [each.value]

  private_endpoint_network_policies = each.key == "private_endpoints" ? "Disabled" : "Enabled"
}

resource "azurerm_public_ip" "firewall" {
  count = var.enable_firewall ? 1 : 0

  name                = "pip-${var.prefix}-firewall-${var.location}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

resource "azurerm_firewall_policy" "hub" {
  count = var.enable_firewall ? 1 : 0

  name                     = "afwp-${var.prefix}-hub-${var.location}"
  location                 = azurerm_resource_group.connectivity.location
  resource_group_name      = azurerm_resource_group.connectivity.name
  sku                      = "Standard"
  threat_intelligence_mode = "Alert"
  tags                     = var.tags

  dns {
    proxy_enabled = true
  }

  insights {
    enabled                            = true
    default_log_analytics_workspace_id = var.log_analytics_workspace_id
    retention_in_days                  = 90
  }
}

resource "azurerm_firewall" "hub" {
  count = var.enable_firewall ? 1 : 0

  name                = "afw-${var.prefix}-hub-${var.location}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.firewall_sku
  firewall_policy_id  = azurerm_firewall_policy.hub[0].id
  zones               = ["1", "2", "3"]
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub["AzureFirewallSubnet"].id
    public_ip_address_id = azurerm_public_ip.firewall[0].id
  }
}

resource "azurerm_monitor_diagnostic_setting" "firewall" {
  count = var.enable_firewall ? 1 : 0

  name                       = "send-to-central-law"
  target_resource_id         = azurerm_firewall.hub[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_public_ip" "bastion" {
  count = var.enable_bastion ? 1 : 0

  name                = "pip-${var.prefix}-bastion-${var.location}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

resource "azurerm_bastion_host" "hub" {
  count = var.enable_bastion ? 1 : 0

  name                = "bas-${var.prefix}-hub-${var.location}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  sku                 = var.bastion_sku
  copy_paste_enabled  = true
  file_copy_enabled   = false
  tunneling_enabled   = true
  zones               = ["1", "2", "3"]
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub["AzureBastionSubnet"].id
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }
}

resource "azurerm_monitor_diagnostic_setting" "bastion" {
  count = var.enable_bastion ? 1 : 0

  name                       = "diag-${var.prefix}-bastion"
  target_resource_id         = azurerm_bastion_host.hub[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AuditLogs"
    enabled  = true
  }

  enabled_log {
    category = "ConnectionLogs"
    enabled  = true
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_public_ip" "vpn" {
  count = var.enable_vpn_gateway ? 1 : 0

  name                = "pip-${var.prefix}-vpngw-${var.location}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway" "vpn" {
  count = var.enable_vpn_gateway ? 1 : 0

  name                = "vpngw-${var.prefix}-hub-${var.location}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  bgp_enabled         = false
  sku                 = "VpnGw1AZ"
  tags                = var.tags

  ip_configuration {
    name                          = "configuration"
    public_ip_address_id          = azurerm_public_ip.vpn[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub["GatewaySubnet"].id
  }
}
