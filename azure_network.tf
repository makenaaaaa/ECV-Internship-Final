// Create vnet
resource "azurerm_virtual_network" "vnet" {
  name                = "final-vnet"
  location            = "eastus"
  resource_group_name = data.azurerm_resource_group.msp.name
  address_space       = ["10.0.0.0/16"]
}

// Create bastion subnet
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.msp.name
  address_prefixes     = ["10.0.0.0/24"]
}

// Create VM subnet
resource "azurerm_subnet" "subnet" {
  name                 = "sub"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.msp.name
  address_prefixes     = ["10.0.1.0/24"]
}

// Create second VM subnet
resource "azurerm_subnet" "subnet2" {
  name                 = "sub2"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.msp.name
  address_prefixes     = ["10.0.2.0/24"]
}

// Create AGW subnet
resource "azurerm_subnet" "alb" {
  name                 = "alb"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.msp.name
  address_prefixes     = ["10.0.3.0/24"]
}

// Create web public IP
resource "azurerm_public_ip" "pip" {
  name                = "final-publicip"
  resource_group_name = data.azurerm_resource_group.msp.name
  location            = "eastus"
  allocation_method   = "Static"
}

// Create AGW public IP
resource "azurerm_public_ip" "alb" {
  name                = "final-albip"
  resource_group_name = data.azurerm_resource_group.msp.name
  location            = "eastus"
  allocation_method   = "Dynamic"
}

// Create web NIC
resource "azurerm_network_interface" "nic" {
  name                = "final-nic"
  location            = "eastus"
  resource_group_name = data.azurerm_resource_group.msp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
    primary                       = true
  }
}

// Create second web public IP
resource "azurerm_public_ip" "pip2" {
  name                = "final-publicip2"
  resource_group_name = data.azurerm_resource_group.msp.name
  location            = "eastus"
  allocation_method   = "Static"
}

// Create second NIC
resource "azurerm_network_interface" "nic2" {
  name                = "final-nic2"
  location            = "eastus"
  resource_group_name = data.azurerm_resource_group.msp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip2.id
    primary                       = true
  }
}

// Create web SG
resource "azurerm_network_security_group" "sg" {
  name                = "vm_sg"
  location            = "eastus"
  resource_group_name = data.azurerm_resource_group.msp.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "out"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

// Associate NIC and SG
resource "azurerm_network_interface_security_group_association" "nicsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.sg.id
}

resource "azurerm_network_interface_security_group_association" "nicsg2" {
  network_interface_id      = azurerm_network_interface.nic2.id
  network_security_group_id = azurerm_network_security_group.sg.id
}