variable "peerings" {
  type = map(object({
    name           = string
    resource_group = optional(string)
    vnet           = optional(string)
    vnet_id        = optional(string)
  }))
  description = "Map of peerings to be created, must contain a source and target keys."
  validation {
    condition = alltrue([
      contains(keys(var.peerings), "source"),
      contains(keys(var.peerings), "target"),
      [for k, v in var.peerings : (contains(keys(v), "vnet") && contains(keys(v), "resource_group")) || contains(keys(v), "vnet_id")]
    ])
    error_message = "Must contain exactly two keys, source and target."
  }
}
