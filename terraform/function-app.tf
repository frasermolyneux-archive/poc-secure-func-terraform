// Create a secure storage account; this will deny all public access
resource "azurerm_storage_account" "fa" {
  for_each = toset(var.locations)

  name = format("sa%s", lower(random_string.location[each.value].result))

  resource_group_name = azurerm_resource_group.rg[each.value].name
  location            = azurerm_resource_group.rg[each.value].location

  // Consider your disaster recovery requirements when setting tier and replication type
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version = "TLS1_2"

  public_network_access_enabled = false
}

// Create the private endpoints for the storage account. The function needs different endpoints depending on what features are being used.
resource "azurerm_private_endpoint" "sa_blob_pe" {
  for_each = toset(var.locations)

  name = format("pe-%s-blob", azurerm_storage_account.fa[each.value].name)

  resource_group_name = azurerm_resource_group.rg[each.value].name
  location            = azurerm_resource_group.rg[each.value].location

  subnet_id = azurerm_subnet.endpoints[each.value].id

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.blob.id,
    ]
  }

  private_service_connection {
    name                           = format("pe-%s-blob", azurerm_storage_account.fa[each.value].name)
    private_connection_resource_id = azurerm_storage_account.fa[each.value].id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "sa_table_pe" {
  for_each = toset(var.locations)

  name = format("pe-%s-table", azurerm_storage_account.fa[each.value].name)

  resource_group_name = azurerm_resource_group.rg[each.value].name
  location            = azurerm_resource_group.rg[each.value].location

  subnet_id = azurerm_subnet.endpoints[each.value].id

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.table.id,
    ]
  }

  private_service_connection {
    name                           = format("pe-%s-table", azurerm_storage_account.fa[each.value].name)
    private_connection_resource_id = azurerm_storage_account.fa[each.value].id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "sa_queue_pe" {
  for_each = toset(var.locations)

  name = format("pe-%s-queue", azurerm_storage_account.fa[each.value].name)

  resource_group_name = azurerm_resource_group.rg[each.value].name
  location            = azurerm_resource_group.rg[each.value].location

  subnet_id = azurerm_subnet.endpoints[each.value].id

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.queue.id,
    ]
  }

  private_service_connection {
    name                           = format("pe-%s-queue", azurerm_storage_account.fa[each.value].name)
    private_connection_resource_id = azurerm_storage_account.fa[each.value].id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "sa_file_pe" {
  for_each = toset(var.locations)

  name = format("pe-%s-file", azurerm_storage_account.fa[each.value].name)

  resource_group_name = azurerm_resource_group.rg[each.value].name
  location            = azurerm_resource_group.rg[each.value].location

  subnet_id = azurerm_subnet.endpoints[each.value].id

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.file.id,
    ]
  }

  private_service_connection {
    name                           = format("pe-%s-file", azurerm_storage_account.fa[each.value].name)
    private_connection_resource_id = azurerm_storage_account.fa[each.value].id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }
}
