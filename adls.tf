resource "azurerm_storage_account" "datalake" {
  name                     = "abhiktfadls${random_integer.ri.result}"
  resource_group_name      = azurerm_resource_group.tf-data-grp.name
  location                 = azurerm_resource_group.tf-data-grp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "container" {
  name               = "dlcontainer"
  storage_account_id = azurerm_storage_account.datalake.id
}