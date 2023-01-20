locals {
  folders_config = {
    for folder in var.folders_config: folder.path => {
      permissions_string: format(",%s", join(",", concat(
        [for v in [for k in folder.permissions : k if(contains(keys(k), "user") && k["scope"] == "access")] : "${v.type}:${v.user}:${v.permissions}"],
        [for v in [for k in folder.permissions : k if(contains(keys(k), "group") && k["scope"] == "access")] : "${v.type}:${v.group}:${v.permissions}"],
        [for v in [for k in folder.permissions : k if(contains(keys(k), "user") && k["scope"] == "default")] : "default:${v.type}:${v.user}:${v.permissions}"]
      )))
    }
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name               = var.name
  storage_account_id = var.storage_account_id
  properties = {
    for key, value in var.properties : key => base64encode(value)
  }

  lifecycle { prevent_destroy = false }

  dynamic "ace" {
    for_each = length(var.permissions) == 0 ? [] : [for k in var.permissions : k if contains(keys(k), "group")]
    content {
      id          = ace.value["group"]
      permissions = ace.value["permissions"]
      scope       = ace.value["scope"]
      type        = ace.value["type"]
    }
  }
  dynamic "ace" {
    for_each = length(var.permissions) == 0 ? [] : [for k in var.permissions : k if contains(keys(k), "user")]
    content {
      id          = ace.value["user"]
      permissions = ace.value["permissions"]
      scope       = ace.value["scope"]
      type        = ace.value["type"]
    }
  }
  dynamic "ace" {
    for_each = var.ace_default
    content {
      permissions = ace.value["permissions"]
      scope       = ace.value["scope"]
      type        = ace.value["type"]
    }
  }
}

resource "null_resource" "create_folders" {
  for_each = var.storage_role_assigned == true ? {} : {
    for folder in var.folders_config: replace(folder.path, "/", "-") => folder
  }
  triggers = {
    acl_list = local.folders_config[each.value.path].permissions_string,
    folder   = each.value.path
  }
  provisioner "local-exec" {
    on_failure  = continue
    command     = "bash ./az_create_folders.sh \"${var.storage_account_name}\" \"${azurerm_storage_data_lake_gen2_filesystem.this.name}\" \"${each.value.folder}\" \"${local.folders_config[each.value.folder].permissions_string}\""
    working_dir = path.module
  }
}

resource "azurerm_storage_data_lake_gen2_path" "other" {
  for_each = var.storage_role_assigned == true ? {
    for folder in var.folders_config: replace(folder.path, "/", "-") => folder
  } : {}

  path               = each.value.path
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.this.name
  storage_account_id = var.storage_account_id
  resource           = "directory"

  dynamic "ace" {
    for_each = length(each.value.permissions) == 0 ? [] : [for k in each.value.permissions : k if contains(keys(k), "group")]
    content {
      id          = ace.value["group"]
      permissions = ace.value["permissions"]
      scope       = ace.value["scope"]
      type        = ace.value["type"]
    }
  }
  dynamic "ace" {
    for_each = length(each.value.permissions) == 0 ? [] : [for k in each.value.permissions : k if contains(keys(k), "user")]
    content {
      id          = ace.value["user"]
      permissions = ace.value["permissions"]
      scope       = ace.value["scope"]
      type        = ace.value["type"]
    }
  }
  dynamic "ace" {
    for_each = var.ace_default
    content {
      permissions = ace.value["permissions"]
      scope       = ace.value["scope"]
      type        = ace.value["type"]
    }
  }
}
