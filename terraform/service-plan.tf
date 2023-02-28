resource "azurerm_service_plan" "sp" {
  for_each = toset(var.locations)

  name = format("sp-%s-%s-%s", random_id.environment_id.hex, var.environment, each.value)

  resource_group_name = azurerm_resource_group.rg[each.value].name
  location            = azurerm_resource_group.rg[each.value].location

  os_type  = "Linux" // Could be Windows or Linux
  sku_name = "EP1"   // Values could be EP1, EP2, EP3
}

resource "azurerm_monitor_diagnostic_setting" "sp" {
  for_each = toset(var.locations)

  name = azurerm_log_analytics_workspace.law.name

  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  target_resource_id = azurerm_service_plan.sp[each.value].id

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}
