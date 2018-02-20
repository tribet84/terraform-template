variable "queue_name" {}
variable "resource_group_name" {}
variable "asb_namespace" {}

resource "azurerm_servicebus_queue" "queue" {
  name                      = "${var.queue_name}"
  resource_group_name       = "${var.resource_group_name}"
  namespace_name            = "${var.asb_namespace}"
  enable_partitioning       = true                         # this must also be set in the arm template below as it is a required property
  max_size_in_megabytes     = 5120                         # per partition
  enable_batched_operations = true
}

output "queue_name" {
  value = "${azurerm_servicebus_queue.queue.name}"
}

#deadLetteringOnMessageExpiration is not currently supported by terraform
resource "azurerm_template_deployment" "asb_dead_letter_on_expiration_arm_template" {
  name                = "arm_deadLetterOnExpiration_${azurerm_servicebus_queue.queue.name}"
  resource_group_name = "${var.resource_group_name}"

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
      "namespaceName": {
        "type": "string"
      },
      "queueName": {
        "type": "string"
      }
    },
    "variables": {
      "queuePath": "[concat(parameters('namespaceName'), '/', parameters('queueName'))]"
    },
    "resources": [
      {
        "apiVersion": "2017-04-01",
        "name":  "[variables('queuePath')]",
        "type": "Microsoft.ServiceBus/namespaces/Queues",
        "location": "[resourceGroup().location]",
        "properties": {
            "enablePartitioning": true,
            "deadLetteringOnMessageExpiration": true
        }
      }
    ],
    "outputs": {
    }
}
DEPLOY

  parameters {
    "namespaceName" = "${var.asb_namespace}"
    "queueName"     = "${azurerm_servicebus_queue.queue.name}"
  }

  deployment_mode = "Incremental"
}