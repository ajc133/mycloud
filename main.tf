# Configure the Azure provider
provider "azurerm" {
  version = "=2.0.0"
  features {}
}

# Create a new resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-my-cloud"
  location = var.location

  tags = var.tags
}

# Create a virtual network (VPC equivalent?)
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-myfirstvnet"
  address_space       = ["172.16.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = azurerm_resource_group.rg.tags
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "snet-myfirstsnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "172.16.0.0/24"
}

# Create public IP (sounds like an elastic IP, since it's explicitly declared)
resource "azurerm_public_ip" "publicip" {
  name                = "pip-myfirstpip"
  location            = azurerm_virtual_network.vnet.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  tags                = azurerm_resource_group.rg.tags
}

# Create Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-myfirstnsg"
  location            = azurerm_virtual_network.vnet.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = azurerm_resource_group.rg.tags
}

# Create ssh Network Security Rule for "nsg-myfirstnsg"
resource "azurerm_network_security_rule" "ssh_allow" {
  name                       = "SSH"
  priority                   = 1001
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name        = azurerm_resource_group.rg.name

  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Create http Network Security Rule for "nsg-myfirstnsg"
resource "azurerm_network_security_rule" "http_allow" {
  name                       = "HTTP"
  priority                   = 1002
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name        = azurerm_resource_group.rg.name

  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-myfirstnic"
  location            = azurerm_virtual_network.vnet.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = azurerm_resource_group.rg.tags

  ip_configuration {
    name                          = "nic-myfirstnic-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

output "ip" {
  value = azurerm_public_ip.publicip.ip_address
}
