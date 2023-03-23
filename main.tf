terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.48.0"
    }
  }
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "trgthanh258"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "city-info-terra"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "ARM_SUBSCRIPTION_ID" {
  type = string
  default = ""

}

variable "ARM_CLIENT_ID" {
  type = string
  default = ""

}

resource "azurerm_resource_group" "example" {
  name     = "terra-rg"
  location = "southeastasia"
}

resource "azurerm_app_service_plan" "example" {
  name                = "terra-app-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "terra-appservice"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v6.0"
    vnet_route_all_enabled   = true
  }

  source_control {
    repo_url               = "https://github.com/trgthanh258/CityInfo/"
    branch                 = "master"
  }
}

# resource "azurerm_api_management" "example" {
#   name                = "terra-api-management"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   publisher_name      = "Terra API Management"
#   publisher_email     = "trgthanh258@gmail.com"

#   sku_name = "Developer_1"
# }

# resource "azurerm_api_management_api" "example" {
#   name                = "terra-api"
#   display_name        = "Terra API"
#   description         = "An Terra API"
#   path                = "cities"
#   protocols           = ["https"]
#   revision            = "1"
#   resource_group_name = azurerm_resource_group.example.name
#   api_management_name = azurerm_api_management.example.name
# }

# resource "azurerm_api_management_api_operation" "example" {
#   operation_id            = "get-cities-operation"
#   display_name            = "Get Cities Operation"
#   api_name                = azurerm_api_management_api.example.name
#   api_management_name     = azurerm_api_management.example.name
#   resource_group_name     = azurerm_api_management_api.example.resource_group_name
#   method                  = "GET"
#   url_template            = "/cities"
#   description             = "Get all cities."

#   response {
#     status_code = 200
#   }
# }

# resource "azurerm_api_management_backend" "example" {
#   name                = "terra-backend"
#   url                 = "https://${azurerm_app_service.example.default_site_hostname}"
#   protocol            = "http"
#   api_management_name = azurerm_api_management.example.name
#   resource_group_name = azurerm_resource_group.example.name
# }

# resource "azurerm_api_management_api_operation_policy" "example" {
#   api_name             = azurerm_api_management_api.example.name
#   resource_group_name = azurerm_resource_group.example.name
#   api_management_name  = azurerm_api_management.example.name
#   operation_id       = azurerm_api_management_api_operation.example.operation_id
#   xml_content          = <<XML
#     <policies>
#       <inbound>
#         <base />
#         <set-backend-service base-url="https://${azurerm_api_management_backend.example.url}" />
#       </inbound>
#       <backend>
#         <base />
#       </backend>
#       <outbound>
#         <base />
#       </outbound>
#       <on-error>
#         <base />
#       </on-error>
#     </policies>
#     XML
# }

# resource "azurerm_api_management_api_release" "example" {
#   name                 = "terra-release"
#   api_id               = azurerm_api_management_api.example.id
# }
