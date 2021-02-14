variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default     = "deptp"
}

variable "username" {
  description = "Enter username for the machine"
  default     = "bsawant"

}

variable "password" {
  description = "Enter password to access the machine"
  default     = "Yakima66#"

}

variable "num_of_virtual_machines" {
  description = "Enter number of virtual machines"
  default     = 1
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "westus"
}

variable "vm_image_id" {
  description = "Enter the image image that will be used for creating the virtual machines"
  default     = "/subscriptions/ef5a7969-b97b-445e-ac5e-5edf463b725c/resourceGroups/rg-deployment-project/providers/Microsoft.Compute/images/myPackerImage"
}