// Create mysql server
resource "azurerm_mysql_server" "db" {
  name                = "final-dbserver"
  location            = "eastus"
  resource_group_name = data.azurerm_resource_group.msp.name

  administrator_login          = var.vm_user
  administrator_login_password = var.vm_pass

  sku_name   = "B_Gen5_1"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = false
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}