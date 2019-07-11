locals{
    virtual_machine_name  = "DC1"

}
resource "azurerm_virtual_machine" "vm" {
    name                  = "${local.virtual_machine_name}"
    location              = "${var.location}"
    resource_group_name   = "${var.resource_group_name}"
    vm_size               = "Standard_B2s"
    network_interface_ids = ["${var.nic_id}"]

    storage_os_disk {
        name              = "OsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter"
        version   = "latest"
  }

    os_profile {
        computer_name  = "${local.virtual_machine_name}"
        admin_username = "luke"
        #Lab password
        admin_password = "Terminal12"
    }

    os_profile_windows_config{
    }
}