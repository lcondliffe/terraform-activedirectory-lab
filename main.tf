provider "azurerm" {
    version = "=1.28.0"
}

# Resource Group
resource "azurerm_resource_group" "lw-terraform-test" {
    name     = "LW-Terraform-ADLab"
    location = "uksouth"
}

# Virtual Network
resource "azurerm_virtual_network" "test" {
  name                = "lw-terraform-net"
  resource_group_name = "${azurerm_resource_group.lw-terraform-test.name}"
  location            = "${azurerm_resource_group.lw-terraform-test.location}"
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "subnet" {
    name                 = "lw-subnet"
    resource_group_name  = "${azurerm_resource_group.lw-terraform-test.name}"
    virtual_network_name = "${azurerm_virtual_network.test.name}"
    address_prefix       = "10.0.1.0/24"
}

# Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    name                = "Test-NSG"
    location            = "uksouth"
    resource_group_name = "${azurerm_resource_group.lw-terraform-test.name}"

    security_rule {
        name                       = "RDP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# Public IP
resource "azurerm_public_ip" "publicip" {
    name                         = "PIP"
    location                     = "uksouth"
    resource_group_name          = "${azurerm_resource_group.lw-terraform-test.name}"
    public_ip_address_allocation = "dynamic"
}

module "domain-controller"{
    source              = "./modules/DC1"
    location            = "${azurerm_resource_group.lw-terraform-test.location}"
    resource_group_name = "${azurerm_resource_group.lw-terraform-test.name}"
    subnet_id           = "${azurerm_subnet.subnet.id}"
    network_security_group_id = "${azurerm_network_security_group.nsg.id}"
    public_ip_id        = "${azurerm_public_ip.publicip.id}"
    active_directory_domain       = "lab.local"
    active_directory_netbios_name = "LABLOCAL"
    admin_username                = "luke"
    admin_password                = "Terminal22"
}

module "client1"{
    source      = "./modules/CLI1"
    location            = "${module.domain-controller.out_dc_location}"
    resource_group_name = "${azurerm_resource_group.lw-terraform-test.name}"
    subnetID            = "${azurerm_subnet.subnet.id}"
    network_security_group_id = "${azurerm_network_security_group.nsg.id}"
    active_directory_domain   = "lw.lab"
    admin_username            = "luke"
    admin_password            = "Terminal22"
}