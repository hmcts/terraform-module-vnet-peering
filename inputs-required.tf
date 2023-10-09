variable "peerings" {
  type = map(object({
    name           = string
    resource_group = optional(string)
    vnet      = optional(string)
    vnet_id        = optional(string)
  }))
  description = "Map of peerings to be created, must contain a source and target keys."
  validation {
    condition = alltrue([
      contains(keys(var.peerings), "source"),
      contains(keys(var.peerings), "target"),
      (var.peerings["source"].vnet != null && var.peerings["source"].resource_group != null) || var.peerings["source"].vnet_id != null,
      (var.peerings["target"].vnet != null && var.peerings["target"].resource_group != null) || var.peerings["target"].vnet_id != null,
    ])
    error_message = "Must contain exactly two keys, source and target and either vnet_name or vnet_id must be provided."
  }
}
