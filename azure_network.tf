data "azurerm_virtual_network" "vnet" {
  name                = "jason-vnet"
  resource_group_name = data.azurerm_resource_group.msp.name
}

data "azurerm_subnet" "subnet" {
  name                 = "default"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.msp.name
}
resource "azurerm_subnet" "alb" {
  name                 = "alb"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.msp.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_public_ip" "pip" {
  name                = "final-publicip"
  resource_group_name = data.azurerm_resource_group.msp.name
  location            = "eastus"
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "alb" {
  name                = "final-albip"
  resource_group_name = data.azurerm_resource_group.msp.name
  location            = "eastus"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  name                = "final-nic"
  location            = "eastus"
  resource_group_name = data.azurerm_resource_group.msp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
    primary                       = true
  }
}

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

resource "azurerm_network_interface_security_group_association" "nicsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.sg.id
}
