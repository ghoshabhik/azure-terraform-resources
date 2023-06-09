
resource "azurerm_databricks_workspace" "adb-ws" {
    location = azurerm_resource_group.tf-data-grp.location
    name = "tfadbws${random_integer.ri.result}"
    resource_group_name = azurerm_resource_group.tf-data-grp.name
    sku = "standard"
}

data "databricks_node_type" "smallest" {
  depends_on = [ azurerm_databricks_workspace.adb-ws ]
  local_disk = true
}

data "databricks_spark_version" "latest_lts" {
    depends_on = [ azurerm_databricks_workspace.adb-ws ]
    long_term_support = true
}

# resource "databricks_instance_pool" "tf-pool" {
#   instance_pool_name = "tfnodepool${random_integer.ri.result}"
#   min_idle_instances = 0
#   max_capacity = 2
#   node_type_id = data.databricks_node_type.smallest.id
#   idle_instance_autotermination_minutes = 10
# }

resource "databricks_cluster" "single" {
  depends_on = [ azurerm_databricks_workspace.adb-ws ]
  
  cluster_name = "tf cluster"
  spark_version = data.databricks_spark_version.latest_lts.id   
  node_type_id = data.databricks_node_type.smallest.id
  autotermination_minutes = 10
  autoscale {
    min_workers = 1
    max_workers = 1
  }
  spark_conf = {
    "spark.databricks.io.cache.enabled": true
  }
  custom_tags = {
    "createdby": "terraform"
  }
}

resource "databricks_git_credential" "github" {
  depends_on = [ azurerm_databricks_workspace.adb-ws ]
  git_username          = "ghoshabhik"
  git_provider          = "github"
  personal_access_token = var.personal_access_token
}

resource "databricks_repo" "databricks_repos" {
  depends_on = [ azurerm_databricks_workspace.adb-ws ]
  url = "https://github.com/ghoshabhik/azure-terraform-resources.git"
}