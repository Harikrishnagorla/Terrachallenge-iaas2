
resource "azurerm_network_interface" "linuxinterface" {
  name                = "Linuxinterface"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "Websubnet"
    subnet_id                     = azurerm_subnet.Websubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-test.id
  }
  depends_on = [ azurerm_virtual_network.Terrachallenge-vnet ]
}

resource "azurerm_linux_virtual_machine" "LinuxVM" {
  name                = "LinuxVM"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.linuxinterface.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  }

resource "azurerm_network_interface_security_group_association" "nsgassociation" {
  network_interface_id      = azurerm_network_interface.linuxinterface.id
  network_security_group_id = azurerm_network_security_group.TerraNSG.id
}

