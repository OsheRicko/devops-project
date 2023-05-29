variable "app_resource_group_name" {
  description = "Name of the application resource group."
  default     = "ot-app-rg"
}

variable "app_virtual_network_name" {
  description = "Name of the application virtual network."
  default     = "ot-app-vnet"
}

variable "app_subnet_name" {
  description = "Name of the application subnet."
  default     = "ot-app-subnet"
}

variable "app_storage_account_name" {
  description = "Name of the application storage account."
  default     = "otappsa"
}

variable "storage_container_name" {
  description = "Name of the storage container."
  default     = "appdata"
}

variable "sql_server_name" {
  description = "Name of the SQL server."
  default     = "ot-app-sql"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry."
  default     = "otappacr"
}

variable "admin_username" {
  description = "Admin username for the virtual machine."
  default     = "osher"
}

variable "admin_password" {
  description = "Admin password for the virtual machine."
  default     = "Password1234"
}
