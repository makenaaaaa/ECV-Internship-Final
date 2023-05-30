resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "final-vm"
  resource_group_name             = data.azurerm_resource_group.msp.name
  location                        = "eastus"
  size                            = "Standard_B1s"
  disable_password_authentication = false
  admin_username                  = var.vm_user
  admin_password                  = var.vm_pass
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "None"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    apt-get install -y ansible
    apt-get install -y mysql-server
    apt-get install -y python3.8
    apt-get install -y python3-pip
    echo "This is Azure!" > /var/www/html/index.html
    EOF
  )
}
