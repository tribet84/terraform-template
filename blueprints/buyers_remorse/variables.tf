variable "location" {}
variable "orders_history_namespace" {}

variable "topic_historyWebApi_Name" {
  default = "asos.commerce.orders.history.web.api.events"
}

variable "topic_orderProcessingEvents_Name" {
  default = "order.processing.events"
}
