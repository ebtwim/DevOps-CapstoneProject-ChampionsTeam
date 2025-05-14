locals {

 
  prefix                 = "DevOps1-CapstoneProject-Champions"
  location               = "East US"
  default_node_pool_name = "sau"

  vnet_address_space = ["10.2.0.0/16"]

  subnet_address_prefixes = ["10.2.2.0/24"]

  sql_db = {
    username             = "Champions"
    collation            = "SQL_Latin1_General_CP1_CI_AS"
    password             = "m/2.71.0/do"
    server_version       = "12.0"
    dbsize               = 1
    zone_redundant       = false
    sql_database_name    = "Champions"
    sku_name             = "Basic"
    storage_account_type = "Local"

  }




}