variable "network_manager_connectivity_configurations" {
  description = <<EOT
Map of network_manager_connectivity_configurations, attributes below
Required:
    - connectivity_topology
    - name
    - network_manager_id
    - applies_to_group (block):
        - global_mesh_enabled (optional)
        - group_connectivity (required)
        - network_group_id (required)
        - use_hub_gateway (optional)
Optional:
    - connected_group_address_overlap_enabled
    - connected_group_private_endpoints_scale
    - delete_existing_peering_enabled
    - description
    - global_mesh_enabled
    - peering_enforcement_enabled
    - hub (block):
        - resource_id (required)
        - resource_type (required)
EOT

  type = map(object({
    connectivity_topology                   = string
    name                                    = string
    network_manager_id                      = string
    connected_group_address_overlap_enabled = optional(bool)
    connected_group_private_endpoints_scale = optional(string)
    delete_existing_peering_enabled         = optional(bool)
    description                             = optional(string)
    global_mesh_enabled                     = optional(bool)
    peering_enforcement_enabled             = optional(bool)
    applies_to_group = list(object({
      global_mesh_enabled = optional(bool)
      group_connectivity  = string
      network_group_id    = string
      use_hub_gateway     = optional(bool)
    }))
    hub = optional(object({
      resource_id   = string
      resource_type = string
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.network_manager_connectivity_configurations : (
        length(v.applies_to_group) >= 1
      )
    ])
    error_message = "Each applies_to_group list must contain at least 1 items"
  }
}

