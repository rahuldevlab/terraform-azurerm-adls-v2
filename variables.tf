variable "name" {
  type        = string
  description = "Name of ADLS FS to create"
}

variable "storage_account_id" {
  type        = string
  description = "ID of storage account to create ADLS in"
}

variable "storage_account_name" {
  type        = string
  description = "Name of storage account to create ADLS in"
}

variable "storage_role_assigned" {
  type        = bool
  default     = false
  description = "Is Storage Blob Data Owner Role assigned to Terraform Service Principal? Provides an ability to create File System with bash script(false) or azurerm resources(true)."
}

variable "ace_default" {
  type        = list(map(string))
  description = "Default ACE values"
  default = [
    { "permissions" = "---", "scope" = "access", "type" = "other" },
    { "permissions" = "---", "scope" = "default", "type" = "other" },
    { "permissions" = "rwx", "scope" = "access", "type" = "group" },
    { "permissions" = "rwx", "scope" = "access", "type" = "mask" },
    { "permissions" = "rwx", "scope" = "access", "type" = "user" },
    { "permissions" = "rwx", "scope" = "default", "type" = "group" },
    { "permissions" = "rwx", "scope" = "default", "type" = "mask" },
    { "permissions" = "rwx", "scope" = "default", "type" = "user" },
  ]
}

variable "permissions" {
  type        = list(map(string))
  description = "List of ADLS FS permissions"
  default     = [{}]
}

variable "folders_config" {
  type = list(object({
    path        = string
    permissions = any
  }))
  description = "List of ADLS folders configuration to create"
  default     = []
}

variable "properties" {
  type        = map(string)
  description = "Map of properties"
  default     = {}
}
variable "is_hns_enabled" {
    description = "(Optional) - This input variable contains the is_hns_enabled"
    type        = bool
    default     = false  
}
