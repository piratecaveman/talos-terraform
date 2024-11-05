module "network" {
  for_each = local.networks
  source   = "../incus/network"

  name        = try(each.value.name, each.key)
  config      = merge(var.network_config.config, try(each.value.config, {}))
  description = lookup(each.value, "description", var.network_config.description)
  type        = lookup(each.value, "type", var.network_config.type)
  project     = lookup(each.value, "project", var.network_config.project)
  remote      = lookup(each.value, "remote", var.network_config.remote)
  target      = lookup(each.value, "target", var.network_config.target)
}
