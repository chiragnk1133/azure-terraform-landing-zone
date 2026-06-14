variable "prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "log_retention_days" {
  type = number
}

variable "security_contact_email" {
  type = string
}

variable "enable_defender_for_cloud" {
  type = bool
}

variable "tags" {
  type = map(string)
}

