# we need to specify the provider that we are going to use
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
   features {
    
  }
}

variable "imagebuild" {
  type = string
  description = "the latest image build version"
}

terraform {
  backend "azurerm" {
    resource_group_name = "rg_st_tf"
    storage_account_name = "tfstaccsa"
    container_name = "tfdata"
    key = "terraform.tfstate"
  }
}

# since we are using azure we need to create a resource group since its the bases of everything in azure
# the name we provide on line 11 is only used in our tf file not on azure whent the resource is created
# the naming should unique
resource "azurerm_resource_group" "tf_rg_sample" {
  name = "mlawandtfrg" # this is the name on azure
  location = "uksouth" # data center location on azure
}

# create the container group
resource "azurerm_container_group" "tf_cg_sample" {
  name                  = "sampleapi"
  location              = azurerm_resource_group.tf_rg_sample.location #utilising the resource group
  resource_group_name   = azurerm_resource_group.tf_rg_sample.name #utilising the resource group

  ip_address_type       = "public"
  dns_name_label        = "mohamadlawandtf"
  os_type               = "Linux"

  # Specify the container information
  container {
    name = "sampleapi"
    image = "mohamadlawand/sampleapi:${var.imagebuild}"
    cpu = "1"
    memory = "1"

    ports {
        port = 80
        protocol = "TCP"
    }
  }
}



