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
        "User": "lab.local\\luke",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "Password": "Terminal12"
    }
PROTECTED_SETTINGS
}