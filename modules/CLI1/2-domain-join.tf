resource "azurerm_virtual_machine_extension" "domain-join" {
  name                 = "domain-join"
  location             = "uksouth"
  resource_group_name  = "${var.resource_group_name}"
  virtual_machine_name = "client1"
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.0"

  settings = <<SETTINGS
    {
        "Name": "lab.local",
        "OUPath": "OU=Computers,DC=lab,DC=local",
        "User": "lab.local\\"${var.admin_username},
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "Password": "${var.admin_password}"
    }
PROTECTED_SETTINGS
}