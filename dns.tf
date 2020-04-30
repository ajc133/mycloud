resource "azurerm_dns_zone" "azure_unofficialaj" {
  name                = "azure.unofficialaj.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dns_a_record" "a1" {
  name                = "a1"
  zone_name           = azurerm_dns_zone.azure_unofficialaj.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.publicip.id
}


