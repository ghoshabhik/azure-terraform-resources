resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "tf-data-grp" {
  location = "East US"
  name     = "tf-data-grp-${random_integer.ri.result}"
}