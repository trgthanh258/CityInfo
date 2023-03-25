terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.48.0"
    }
  }
  cloud {
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

  connection_string {
    name  = "CityInfoDBConnectionString"
    type  = "Custom"
    value = "Data Source=CityInfo.db"
  }
}

resource "azurerm_app_service_source_control" "example" {
  app_id    = azurerm_app_service.example.id
  repo_url  = "https://github.com/trgthanh258/CityInfo/"
  branch    = "master"
}

resource "azurerm_source_control_token" "example" {
  type  = "GitHub"
  token = "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"
}

resource "azurerm_api_management" "example" {
  name                = "terra-api-management"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  publisher_name      = "Terra API Management"
  publisher_email     = "trgthanh258@gmail.com"

  sku_name = "Developer_1"
}

resource "azurerm_api_management_api" "example" {
  name                = "get-cities-api"
  display_name        = "City Information APIs"
  description         = "An City Information APIs"
  protocols           = ["https"]
  revision            = 1
  resource_group_name = azurerm_resource_group.example.name
  api_management_name = azurerm_api_management.example.name
}

resource "azurerm_api_management_api_operation" "example" {
  operation_id            = "get-cities-operation"
  display_name            = "Get Cities Operation"
  api_name                = azurerm_api_management_api.example.name
  api_management_name     = azurerm_api_management.example.name
  resource_group_name     = azurerm_api_management_api.example.resource_group_name
  method                  = "GET"
  url_template            = "api/cities"
  description             = "Get all cities."

  response {
    status_code = 200
  }
}

resource "azurerm_api_management_backend" "example" {
  name                = "terra-apim-backend"
  url                 = "https://${azurerm_app_service.example.default_site_hostname}"
  protocol            = "http"
  api_management_name = azurerm_api_management.example.name
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_api_management_api_operation_policy" "example" {
  api_name             = azurerm_api_management_api.example.name
  resource_group_name = azurerm_resource_group.example.name
  api_management_name  = azurerm_api_management.example.name
  operation_id       = azurerm_api_management_api_operation.example.operation_id
  xml_content          = <<XML
    <policies>
      <inbound>
        <base />
      </inbound>
      <backend>
        <set-backend-service base-url="${azurerm_api_management_backend.example.url}/api/cities" />
      </backend>
      <outbound>
        <base />
      </outbound>
      <on-error>
        <base />
      </on-error>
    </policies>
    XML
}

# resource "azurerm_api_management_api_release" "example" {
#   name                 = "terra-release"
#   api_id               = azurerm_api_management_api.example.id
# }
