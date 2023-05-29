provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-app" {
  name     = var.app_resource_group_name
  location = "West Europe"
}

resource "azurerm_resource_group" "rg-client" {
  name     = "client-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "ot-app-vnet" {
  name                = var.app_virtual_network_name
  resource_group_name = azurerm_resource_group.rg-app.name
  location            = azurerm_resource_group.rg-app.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "ot-app-subnet" {
  name                 = var.app_subnet_name
  resource_group_name  = azurerm_resource_group.rg-app.name
  virtual_network_name = azurerm_virtual_network.ot-app-vnet.name
  address_prefixes     = ["10.0.0.0/23"]
}

resource "azurerm_virtual_network" "ot-client-vnet" {
  name                = "client-vnet"
  resource_group_name = azurerm_resource_group.rg-client.name
  location            = azurerm_resource_group.rg-client.location
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "ot-client-subnet" {
  name                 = "client-subnet"
  resource_group_name  = azurerm_resource_group.rg-client.name
  virtual_network_name = azurerm_virtual_network.ot-client-vnet.name
  address_prefixes     = ["10.2.0.0/24"]
}

resource "azurerm_network_security_group" "client-nsg" {
  name                = "client-nsg"
  location            = azurerm_resource_group.rg-client.location
  resource_group_name = azurerm_resource_group.rg-client.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.ot-client-subnet.id
  network_security_group_id = azurerm_network_security_group.client-nsg.id
}

resource "azurerm_storage_account" "app-storage-account" {
  name                     = var.app_storage_account_name
  resource_group_name      = azurerm_resource_group.rg-app.name
  location                 = azurerm_resource_group.rg-app.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "app-container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.app-storage-account.name
  container_access_type = "blob"
}

data "template_file" "blob_content" {
  template = <<EOT
name = ["osher", "yoav"]
table = ["Address", "Customer"]
action1 = ["AddressID", "FirstName"]
action2 = ["City", "CustomerId"]

EOT
}

resource "azurerm_storage_blob" "app-blob" {
  name                   = "allowed.txt"
  storage_account_name   = azurerm_storage_account.app-storage-account.name
  storage_container_name = azurerm_storage_container.app-container.name
  type                   = "Block"
  source_content         = data.template_file.blob_content.rendered
}

resource "azurerm_mssql_server" "ot-app-sql" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg-app.name
  location                     = azurerm_resource_group.rg-app.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
}

resource "azurerm_container_registry" "my_acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg-app.name
  location            = azurerm_resource_group.rg-app.location
  sku                 = "Standard"
  admin_enabled       = false
}
