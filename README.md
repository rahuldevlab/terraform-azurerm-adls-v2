# Azure Data Lake Storage Gen2 Terraform module
Terraform module for creation Azure Data Lake Storage Gen2 file system

## Usage

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.23.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >=3.1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.24.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_data_lake_gen2_filesystem.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem) | resource |
| [null_resource.create_folders](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.create_root_folder](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ace_default"></a> [ace\_default](#input\_ace\_default) | Default ACE values | `list(map(string))` | <pre>[<br>  {<br>    "permissions": "---",<br>    "scope": "access",<br>    "type": "other"<br>  },<br>  {<br>    "permissions": "---",<br>    "scope": "default",<br>    "type": "other"<br>  },<br>  {<br>    "permissions": "rwx",<br>    "scope": "access",<br>    "type": "group"<br>  },<br>  {<br>    "permissions": "rwx",<br>    "scope": "access",<br>    "type": "mask"<br>  },<br>  {<br>    "permissions": "rwx",<br>    "scope": "access",<br>    "type": "user"<br>  },<br>  {<br>    "permissions": "rwx",<br>    "scope": "default",<br>    "type": "group"<br>  },<br>  {<br>    "permissions": "rwx",<br>    "scope": "default",<br>    "type": "mask"<br>  },<br>  {<br>    "permissions": "rwx",<br>    "scope": "default",<br>    "type": "user"<br>  }<br>]</pre> | no |
| <a name="input_ad_groups"></a> [ad\_groups](#input\_ad\_groups) | Data which is contain mapping AD group name and GUID | `map(string)` | `{}` | no |
| <a name="input_folders"></a> [folders](#input\_folders) | Name of ADLS folders to create in root directory | `list(any)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of ADLS FS to create | `string` | n/a | yes |
| <a name="input_permissions"></a> [permissions](#input\_permissions) | List of ADLS FS permissions | `list(map(string))` | <pre>[<br>  {}<br>]</pre> | no |
| <a name="input_root_dir"></a> [root\_dir](#input\_root\_dir) | Name of ADLS root directory | `string` | `"data"` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | ID of storage account to create ADLS in | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Name of storage account to create ADLS in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Data Lake Storage Gen2 Filesystem (container ID). |
| <a name="output_name"></a> [name](#output\_name) | The name of the Data Lake Storage Gen2 Filesystem (container name). |
| <a name="output_root_path"></a> [root\_path](#output\_root\_path) | The name of the root directory. |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | The ID of the Storage Account where the Data Lake Storage Gen2 Filesystem exists. |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-azurerm-adls-v2/tree/main/LICENSE)
