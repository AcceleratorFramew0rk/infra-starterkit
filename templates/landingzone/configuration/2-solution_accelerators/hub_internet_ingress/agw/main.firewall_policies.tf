resource "azurerm_web_application_firewall_policy" "azure_waf" {
  name                = "${module.naming.firewall_policy.name}${random_string.this.result}ez" 
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location

  # custom_rules {
  #   name      = "Rule1"
  #   priority  = 1
  #   rule_type = "MatchRule"

  #   match_conditions {
  #     match_variables {
  #       variable_name = "RemoteAddr"
  #     }

  #     operator           = "IPMatch"
  #     negation_condition = false
  #     match_values       = ["192.168.1.0/24", "10.0.0.0/24"]
  #   }

  #   action = "Block"
  # }

  # custom_rules {
  #   name      = "Rule2"
  #   priority  = 2
  #   rule_type = "MatchRule"

  #   match_conditions {
  #     match_variables {
  #       variable_name = "RemoteAddr"
  #     }

  #     operator           = "IPMatch"
  #     negation_condition = false
  #     match_values       = ["192.168.1.0/24"]
  #   }

  #   match_conditions {
  #     match_variables {
  #       variable_name = "RequestHeaders"
  #       selector      = "UserAgent"
  #     }

  #     operator           = "Contains"
  #     negation_condition = false
  #     match_values       = ["Windows"]
  #   }

  #   action = "Block"
  # }

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    exclusion {
      match_variable          = "RequestHeaderNames"
      selector                = "x-company-secret-header"
      selector_match_operator = "Equals"
    }
    exclusion {
      match_variable          = "RequestCookieNames"
      selector                = "too-tasty"
      selector_match_operator = "EndsWith"
    }

    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        rule {
          id      = "920300"
          enabled = true
          action  = "Log"
        }

        rule {
          id      = "920440"
          enabled = true
          action  = "Block"
        }
      }
    }
  }
}
