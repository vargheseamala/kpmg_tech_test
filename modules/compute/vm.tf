data "azurerm_key_vault" "terrakv" {
  name                = var.kv_name
  resource_group_name = var.rg_name
}

data "azurerm_key_vault_secret" "kvsecret" {
  name         = var.secret_name
  key_vault_id = data.azurerm_key_vault.terrakv.id
}

resource "azurerm_network_interface" "nic" {
  for_each = { for k, instance in var.vm_instances : k => instance }

  name                = "${each.value.name}-nic"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = { for k, instance in var.vm_instances : k => instance }

  name                  = each.value.name
  location              = var.rg_location
  resource_group_name   = var.rg_name
  size                  = each.value.vm_size
  admin_username        = "adminuser"
  admin_password        = data.azurerm_key_vault_secret.kvsecret.value
  network_interface_ids = [azurerm_network_interface.example[each.key].id]
  zone                  = element(each.value.availability_zones, count.index)
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

