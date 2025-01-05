terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.14.0"
    }
  }

  cloud {
    organization = "YourOrg"
    workspaces {
      name = "Your workspace"
    }
  }
}

provider "azurerm" {
  features {}
}
