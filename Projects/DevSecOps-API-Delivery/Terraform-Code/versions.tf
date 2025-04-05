terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.14.0"
    }
  }

  cloud {
    organization = "Your Organization Here"
    workspaces {
      name = "Your Workspace Here"
    }
  }
}

provider "azurerm" {
  features {}
}
