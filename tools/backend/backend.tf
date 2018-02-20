variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "environment" {}
variable "location" {}
variable "resource_group_name" {}

provider "azurerm" {
  version         = "~> 1.1"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
}

module "storage_account_backend" {
  source                   = "../../modules/storage_account"
  name                     = "as${var.environment}mybackend"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

module "storage_container_tfstate" {
  source               = "../../modules/storage_account_container"
  name                 = "${var.environment}terraformstate"
  resource_group_name  = "${var.resource_group_name}"
  storage_account_name = "${module.storage_account_backend.storage_account_name}"
}
