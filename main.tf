terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.54.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "aws" {
  version = "4.51.0"
  region  = "us-east-1"
}

data "azurerm_resource_group" "msp" {
  name = var.resource_group
}