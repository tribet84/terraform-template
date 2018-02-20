module "topic_ordersHistory_bundle1" {
  source              = "../../modules/asb_topic"
  topic_name          = "bundle-1"
  resource_group_name = "${module.resourceGroup_defaultServiceBus.resource_group_name}"
  asb_namespace       = "${module.namespace_ordersHistory.asb_namespace}"
}

module "subscription_bundle1_buyersRemorse" {
  source              = "../../modules/asb_subscription"
  subscription_name   = "buyersRemorse"
  resource_group_name = "${module.resourceGroup_defaultServiceBus.resource_group_name}"
  asb_namespace       = "${module.namespace_ordersHistory.asb_namespace}"
  topic_name          = "${module.topic_ordersHistory_bundle1.topic_name}"
}

module "subscriptionFilter_bundle1_buyersRemorse" {
  source              = "../../modules/asb_filter_arm"
  template_name       = "arm_subscriptionFilter_bundle1_buyersRemorse"
  resource_group_name = "${module.resourceGroup_defaultServiceBus.resource_group_name}"
  asb_namespace       = "${module.namespace_ordersHistory.asb_namespace}"
  topic_name          = "${module.topic_ordersHistory_bundle1.topic_name}"
  subscription_name   = "${module.subscription_bundle1_buyersRemorse.subscription_name}"
  rule_name           = "IOrderCreatedInternalV1"
  sql_filter          = "[NServiceBus.EnclosedMessageTypes] = 'Asos.Commerce.Contracts.Internal.Orders.History.V1.Messages.Events.IOrderCreatedInternalV1'"
}

module "autoForward_bundle1_buyersRemorse" {
  source              = "../../modules/asb_auto_forward_arm"
  template_name       = "arm_autoForward_bundle1_buyersRemorse"
  resource_group_name = "${module.resourceGroup_defaultServiceBus.resource_group_name}"
  asb_namespace       = "${module.namespace_ordersHistory.asb_namespace}"
  topic_name          = "${module.topic_ordersHistory_bundle1.topic_name}"
  subscription_name   = "${module.subscription_bundle1_buyersRemorse.subscription_name}"
  auto_forward_to     = "${module.queue_buyersRemorse.queue_name}"
}