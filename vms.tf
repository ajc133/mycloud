# Create a linux vm (They call them VMs! Not ec2 instances or similar
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-myfirstvm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_virtual_network.vnet.location
  size                = "Standard_A1"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  tags = azurerm_resource_group.rg.tags

  computer_name = "skinnycat"

  admin_username = "ajc"
  admin_ssh_key {
    username   = "ajc"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  disable_password_authentication = "true"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # AMI equivalent
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

}

