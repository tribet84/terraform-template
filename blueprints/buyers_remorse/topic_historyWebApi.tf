module "subscription_historyWebApi_bundle1" {
  source              = "../../modules/asb_subscription"
  subscription_name   = "bundle-1"
  resource_group_name = "${module.resourceGroup_defaultServiceBus.resource_group_name}"
  asb_namespace       = "${module.namespace_ordersHistory.asb_namespace}"
  topic_name          = "${var.topic_historyWebApi_Name}"
}

module "autoForward_historyWebApi_bundle1" {
  source              = "../../modules/asb_auto_forward_arm"
  template_name       = "arm_autoForward_historyWebApi_bundle1"
  resource_group_name = "${module.resourceGroup_defaultServiceBus.resource_group_name}"
  asb_namespace       = "${module.namespace_ordersHistory.asb_namespace}"
  topic_name          = "${var.topic_historyWebApi_Name}"
  subscription_name   = "${module.subscription_historyWebApi_bundle1.subscription_name}"
  auto_forward_to     = "${module.topic_ordersHistory_bundle1.topic_name}"
}