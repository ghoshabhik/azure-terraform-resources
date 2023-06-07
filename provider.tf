terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.59.0"
    }
    databricks = {
        source = "databricks/databricks"
        version = "1.18.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.adb-ws.id
  azure_client_id = var.client_id
  azure_client_secret = var.client_secret
  azure_tenant_id = var.tenant_id
}