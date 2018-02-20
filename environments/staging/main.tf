# IMPORTANT: All existing resources MUST be imported in order to be modified. See tools/import/import.ps1
terraform {
  backend "azurerm" {
    storage_account_name = "asstaging"
    container_name       = "stagingterraformstate"
    key                  = "staging.tfstate"
    access_key           = "%backendAccessKey%"
  }
}

provider "azurerm" {
  version         = "~> 1.1"
  tenant_id       = "x"
  subscription_id = "x"
  client_id       = "x"
  client_secret   = "%clientSecretKey%"
}

module "blueprint_buyers_remorse_staging" {
  source                   = "../../../blueprints/buyers_remorse"
  location                 = "WestEurope"
  orders_history_namespace = "staging-history-bus"
}
