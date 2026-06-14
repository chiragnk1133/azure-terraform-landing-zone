variable "tenant_id" {
  description = "Microsoft Entra tenant ID."
  type        = string
}

variable "root_management_group_id" {
  description = "Existing tenant root management group ID under which the landing zone hierarchy is created."
  type        = string
}

variable "organization_name" {
  description = "Short organization name used in resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,20}$", var.organization_name))
    error_message = "organization_name must be 2-20 alphanumeric or hyphen characters."
  }
}

variable "management_subscription_id" {
  description = "Existing subscription ID for centralized management resources."
  type        = string
}

variable "connectivity_subscription_id" {
  description = "Existing subscription ID for shared connectivity resources."
  type        = string
}

variable "identity_subscription_id" {
  description = "Existing subscription ID reserved for shared identity resources."
  type        = string
}

variable "location" {
  description = "Primary Azure region."
  type        = string
  default     = "eastus2"
}

variable "allowed_locations" {
  description = "Regions workloads are allowed to use."
  type        = list(string)
  default     = ["eastus2", "centralus"]
}

variable "log_retention_days" {
  description = "Log Analytics retention in days."
  type        = number
  default     = 90

  validation {
    condition     = var.log_retention_days >= 30 && var.log_retention_days <= 730
    error_message = "log_retention_days must be between 30 and 730."
  }
}

variable "security_contact_email" {
  description = "Security contact used by operational alerting and incident processes."
  type        = string
}

variable "hub_address_space" {
  description = "Address space for the regional hub."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "hub_subnets" {
  description = "Hub subnet prefixes. Reserved subnet names must remain unchanged."
  type = object({
    AzureFirewallSubnet = string
    AzureBastionSubnet  = string
    GatewaySubnet       = string
    shared_services     = string
    private_endpoints   = string
  })
  default = {
    AzureFirewallSubnet = "10.0.0.0/24"
    AzureBastionSubnet  = "10.0.1.0/26"
    GatewaySubnet       = "10.0.2.0/27"
    shared_services     = "10.0.3.0/24"
    private_endpoints   = "10.0.4.0/24"
  }
}

variable "enable_firewall" {
  description = "Deploy Azure Firewall Standard and its policy."
  type        = bool
  default     = true
}

variable "enable_bastion" {
  description = "Deploy Azure Bastion Standard."
  type        = bool
  default     = false
}

variable "enable_vpn_gateway" {
  description = "Deploy a route-based VPN gateway. Connections are configured separately."
  type        = bool
  default     = false
}

variable "enable_ddos_protection" {
  description = "Deploy an Azure DDoS Network Protection plan and attach it to the hub."
  type        = bool
  default     = false
}

variable "enable_defender_for_cloud" {
  description = "Enable selected Defender for Cloud plans in platform subscriptions."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Base tags applied to resources."
  type        = map(string)
  default = {
    Environment = "platform"
    ManagedBy   = "terraform"
    Criticality = "high"
  }
}

