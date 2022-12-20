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

variable "ad_groups" {
  type        = map(string)
  description = "Data which is contain mapping AD group name and GUID"
  default     = {}
}

variable "permissions" {
  type        = list(map(string))
  description = "List of ADLS FS permissions"
  default     = [{}]
}

variable "root_dir" {
  type        = string
  description = "Name of ADLS root directory"
  default     = "data"
}

variable "folders" {
  type        = list(any)
  description = "Name of ADLS folders to create in root directory"
  default     = []
}
