variable "name" { }
variable "resource_group_name" { }
variable "location" { }
variable "account_tier" { }
variable "account_replication_type" { }

resource "azurerm_storage_account" "storage_account" {
  name                     = "${lower(var.name)}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "${var.account_tier}"
  account_replication_type = "${var.account_replication_type}"
}

output "storage_account_name" {
  value = "${azurerm_storage_account.storage_account.name}"
}
