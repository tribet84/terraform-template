variable "template_name" {}
variable "resource_group_name" {}
variable "asb_namespace" {}
variable "topic_name" {}
variable "subscription_name" {}
variable "auto_forward_to" {}

resource "azurerm_template_deployment" "asb_auto_forward_arm_template" {
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
      "autoForwardTo": {
        "type": "string"
      }
    },
    "variables": {
      "subscriptionPath": "[concat(parameters('namespaceName'), '/', parameters('topicName'), '/', parameters('subscriptionName'))]"
    },
    "resources": [
      {
        "apiVersion": "2017-04-01",
        "name":  "[variables('subscriptionPath')]",
        "type": "Microsoft.ServiceBus/namespaces/Topics/Subscriptions",
        "location": "[resourceGroup().location]",
        "properties": {
            "forwardTo": "[parameters('autoForwardTo')]"
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
    "autoForwardTo"    = "${var.auto_forward_to}"
  }

  deployment_mode = "Incremental"
}
