variable "name" { }
variable "resource_group_name" { }
variable "storage_account_name" { }

resource "azurerm_storage_container" "storage_container" {
  name                 = "${lower(var.name)}"
  resource_group_name  = "${var.resource_group_name}"
  storage_account_name = "${var.storage_account_name}"
}
