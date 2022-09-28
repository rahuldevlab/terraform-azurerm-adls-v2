output "id" {
  value = azurerm_storage_data_lake_gen2_filesystem.this.id
}

output "name" {
  value = azurerm_storage_data_lake_gen2_filesystem.this.name
}

output "storage_account_id" {
  value = azurerm_storage_data_lake_gen2_filesystem.this.storage_account_id
}

output "root_path" {
  value = var.root_dir
}
