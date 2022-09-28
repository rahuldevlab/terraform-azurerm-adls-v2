output "id" {
  value = azurerm_storage_data_lake_gen2_filesystem.this.id
  description = "The ID of the Data Lake Storage Gen2 Filesystem (container ID)."
}

output "name" {
  value = azurerm_storage_data_lake_gen2_filesystem.this.name
  description = "The name of the Data Lake Storage Gen2 Filesystem (container name)."
}

output "storage_account_id" {
  value = azurerm_storage_data_lake_gen2_filesystem.this.storage_account_id
  description = "The ID of the Storage Account where the Data Lake Storage Gen2 Filesystem exists."
}

output "root_path" {
  value = var.root_dir
  description = "The name of the root directory."
}
