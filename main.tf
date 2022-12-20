locals {
  folders = length(var.folders) == 0 ? "" : join(",", [for f in var.folders : "${var.root_dir}/${f}"])
  extra_acl = length(var.permissions) == 0 ? "" : format(",%s",
    join(
      ",",
      concat(
        [for v in [for k in var.permissions : k if(contains(keys(k), "user") && k["scope"] == "access")] : "${v.type}:${v.user}:${v.permissions}"],
        [for v in [for k in var.permissions : k if(contains(keys(k), "user") && k["scope"] == "default")] : "default:${v.type}:${v.user}:${v.permissions}"]
      )
    )
  )
}

resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name               = var.name
  storage_account_id = var.storage_account_id

  lifecycle { prevent_destroy = false }

  dynamic "ace" {
    for_each = length(var.permissions) == 0 ? [] : [for k in var.permissions : k if contains(keys(k), "group")]
    content {
      id          = lookup(var.ad_groups, ace.value["group"], "default")
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

resource "null_resource" "create_root_folder" {
  count = var.storage_role_assigned == true ? 0 : 1
  triggers = {
    acl_list = local.extra_acl,
    folder   = var.root_dir
  }
  provisioner "local-exec" {
    on_failure  = continue
    command     = "bash ./az_create_folders.sh \"${var.storage_account_name}\" \"${azurerm_storage_data_lake_gen2_filesystem.this.name}\" \"${var.root_dir}\" \"${local.extra_acl}\""
    working_dir = path.module
  }
}

resource "null_resource" "create_folders" {
  count = var.storage_role_assigned == true ? 0 : 1
  triggers = {
    acl_list = local.extra_acl,
    folder   = var.root_dir
  }
  provisioner "local-exec" {
    on_failure  = continue
    command     = "bash ./az_create_folders.sh \"${var.storage_account_name}\" \"${azurerm_storage_data_lake_gen2_filesystem.this.name}\" \"${local.folders}\" \"${local.extra_acl}\""
    working_dir = path.module
  }
  depends_on = [
    null_resource.create_root_folder
  ]
}

resource "azurerm_storage_data_lake_gen2_path" "root" {
  count = var.storage_role_assigned == true ? 1 : 0

  path               = var.root_dir
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.this.name
  storage_account_id = var.storage_account_id
  resource           = "directory"

  dynamic "ace" {
    for_each = length(var.permissions) == 0 ? [] : [for k in var.permissions : k if contains(keys(k), "group")]
    content {
      id          = lookup(var.ad_groups, ace.value["group"], "default")
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

  depends_on = [azurerm_storage_data_lake_gen2_filesystem.this]
}

resource "azurerm_storage_data_lake_gen2_path" "other" {
  for_each = var.storage_role_assigned == true ? toset(var.folders) : []

  path               = "${var.root_dir}/${each.key}"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.this.name
  storage_account_id = var.storage_account_id
  resource           = "directory"

  dynamic "ace" {
    for_each = length(var.permissions) == 0 ? [] : [for k in var.permissions : k if contains(keys(k), "group")]
    content {
      id          = lookup(var.ad_groups, ace.value["group"], "default")
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

  depends_on = [azurerm_storage_data_lake_gen2_path.root]
}
