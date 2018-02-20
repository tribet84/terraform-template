module "queue_buyersRemorse" {
  source              = "../../modules/asb_queue"
  queue_name          = "buyersRemorse"
  resource_group_name = "${module.resourceGroup_defaultServiceBus.resource_group_name}"
  asb_namespace       = "${module.namespace_ordersHistory.asb_namespace}"
}

module "queue_buyersRemorseScheduled" {
  source              = "../../modules/asb_queue"
  queue_name          = "buyersRemorse-Scheduled"
  resource_group_name = "${module.resourceGroup_defaultServiceBus.resource_group_name}"
  asb_namespace       = "${module.namespace_ordersHistory.asb_namespace}"
}