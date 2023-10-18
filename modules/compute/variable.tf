variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "vm_instances" {
  type = list(object({
    name               = string
    vm_size            = string
    subnet_id          = string
    availability_zones = list(string)
  }))
  default = [
    {
      name               = "vm1"
      vm_size            = "Standard_DS2_v2"
      subnet_id          = "/subscriptions/subscription-id/resourceGroups/example-resources/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/subnet1"
      availability_zones = ["1", "2"]
    },
    {
      name               = "vm2"
      vm_size            = "Standard_DS2_v2"
      subnet_id          = "/subscriptions/subscription-id/resourceGroups/example-resources/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/subnet2"
      availability_zones = ["2", "3"]
    }
  ]
}

variable "secret_name" {
  type = string
}

variable "kv_name" {
  type = string
}
