variable "template_name" {}
variable "resource_group_name" {}
variable "asb_namespace" {}
variable "topic_name" {}
variable "subscription_name" {}
variable "rule_name" {}
variable "sql_filter" {}

resource "azurerm_template_deployment" "asb_subscription_rule_arm_template" {
  name                = "${var.template_name}"
  resource_group_name = "${var.resource_group_name}"

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
      "namespaceName": {
        "type": "string"
      },
      "topicName": {
        "type": "string"
      },
      "subscriptionName": {
        "type": "string"
      },
      "ruleName": {
        "type": "string"
      },
      "sqlFilter": {
        "type": "string"
      }
    },
    "variables": {
      "subscriptionPath": "[concat(parameters('namespaceName'), '/', parameters('topicName'), '/', parameters('subscriptionName'), '/')]"
    },
    "resources": [
      {
        "apiVersion": "2015-08-01",
        "name":  "[concat(variables('subscriptionPath'), parameters('ruleName'))]",
        "type": "Microsoft.ServiceBus/namespaces/topics/subscriptions/rules",
        "location": "[resourceGroup().location]",
        "properties": {
            "filter": {
                "sqlExpression": "[parameters('sqlFilter')]"
            }
        }
      }
    ],
    "outputs": {
    }
  }
DEPLOY

  parameters {
    "namespaceName"    = "${var.asb_namespace}"
    "topicName"        = "${var.topic_name}"
    "subscriptionName" = "${var.subscription_name}"
    "ruleName"         = "${var.rule_name}"
    "sqlFilter"        = "${var.sql_filter}"
  }

  deployment_mode = "Incremental"
}
