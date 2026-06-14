locals {
  prefix = lower(var.organization_name)

  common_tags = merge(var.tags, {
    LandingZone = "platform"
    Framework   = "Microsoft-CAF"
  })
}

module "governance" {
  source = "./modules/governance"

  providers = {
    azurerm = azurerm.management
  }

  root_management_group_id     = var.root_management_group_id
  organization_name            = var.organization_name
  management_subscription_id   = var.management_subscription_id
  connectivity_subscription_id = var.connectivity_subscription_id
  identity_subscription_id     = var.identity_subscription_id
  allowed_locations            = var.allowed_locations
  location                     = var.location
  required_tags                = ["Environment", "Owner", "CostCenter", "DataClassification"]
}

module "management" {
  source = "./modules/management"

  providers = {
    azurerm = azurerm.management
  }

  prefix                    = local.prefix
  location                  = var.location
  log_retention_days        = var.log_retention_days
  security_contact_email    = var.security_contact_email
  enable_defender_for_cloud = var.enable_defender_for_cloud
  tags                      = local.common_tags
}

module "connectivity" {
  source = "./modules/connectivity"

  providers = {
    azurerm = azurerm.connectivity
  }

  prefix                     = local.prefix
  location                   = var.location
  hub_address_space          = var.hub_address_space
  hub_subnets                = var.hub_subnets
  enable_firewall            = var.enable_firewall
  enable_bastion             = var.enable_bastion
  enable_vpn_gateway         = var.enable_vpn_gateway
  enable_ddos_protection     = var.enable_ddos_protection
  log_analytics_workspace_id = module.management.log_analytics_workspace_id
  tags                       = local.common_tags

  depends_on = [module.governance]
}

