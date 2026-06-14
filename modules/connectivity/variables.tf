variable "prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "hub_address_space" {
  type = list(string)
}

variable "hub_subnets" {
  type = object({
    AzureFirewallSubnet = string
    AzureBastionSubnet  = string
    GatewaySubnet       = string
    shared_services     = string
    private_endpoints   = string
  })
}

variable "enable_firewall" {
  type = bool
}

variable "firewall_sku" {
  type    = string
  default = "Premium"
}

variable "enable_bastion" {
  type = bool
}

variable "bastion_sku" {
  type    = string
  default = "Standard"
}

variable "enable_vpn_gateway" {
  type = bool
}

variable "enable_ddos_protection" {
  type = bool
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

