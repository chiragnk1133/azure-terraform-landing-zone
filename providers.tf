provider "azurerm" {
  features {}

  tenant_id       = var.tenant_id
  subscription_id = var.management_subscription_id
}

provider "azurerm" {
  alias = "management"

  features {}

  tenant_id       = var.tenant_id
  subscription_id = var.management_subscription_id
}

provider "azurerm" {
  alias = "connectivity"

  features {}

  tenant_id       = var.tenant_id
  subscription_id = var.connectivity_subscription_id
}

provider "azurerm" {
  alias = "identity"

  features {}

  tenant_id       = var.tenant_id
  subscription_id = var.identity_subscription_id
}

