variable "peerings" {
  type = map(object({
    name           = string
    resource_group = string
    vnet           = string
    vnet_id        = optional(string)
  }))
  description = "Map of peerings to be created, must contain a source and target keys."
  validation {
    condition = alltrue([
      contains(keys(var.peerings), "source"),
      contains(keys(var.peerings), "target")
    ])
    error_message = "Must contain exactly two keys, source and target."
  }
}
