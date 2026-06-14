variable "root_management_group_id" {
  type = string
}

variable "organization_name" {
  type = string
}

variable "management_subscription_id" {
  type = string
}

variable "connectivity_subscription_id" {
  type = string
}

variable "identity_subscription_id" {
  type = string
}

variable "allowed_locations" {
  type = list(string)
}

variable "location" {
  type = string
}

variable "required_tags" {
  type = list(string)
}

