variable "TFE_HOST" {}
variable "TFE_ORG" {}
variable "TFE_WORKSPACE" {}

data "terraform_remote_state" "rstate" {
  backend = "atlas"
  config = {
    address = var.TFE_HOST
    name    = "${var.TFE_ORG}/${var.TFE_WORKSPACE}"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.62.1"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "child_02" {
  name                = "child_02_network"
  resource_group_name = data.terraform_remote_state.rstate.outputs.azure_resource_group_name
  location            = data.terraform_remote_state.rstate.outputs.azure_resource_group_location
  address_space       = ["10.0.0.0/16"]
}
