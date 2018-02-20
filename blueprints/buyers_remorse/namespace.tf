module "resourceGroup_defaultServiceBus" {
  source              = "../../modules/resource_group"
  resource_group_name = "Default-ServiceBus-${var.location}"
  location            = "${var.location}"
}

module "namespace_ordersHistory" {
  source              = "../../modules/asb_namespace"
  asb_namespace       = "${var.orders_history_namespace}"
  location            = "${var.location}"
  resource_group_name = "${module.resourceGroup_defaultServiceBus.resource_group_name}"
  sku                 = "standard"
}