module "pool" {
  for_each = local.pools
  source   = "../incus/pool"

  name        = try(each.value.name, each.key)
  config      = merge(var.pool_config.config, try(each.value.config, {}))
  driver      = lookup(each.value, "driver", var.pool_config.driver)
  description = lookup(each.value, "description", var.pool_config.description)
  project     = lookup(each.value, "project", var.pool_config.project)
  remote      = lookup(each.value, "remote", var.pool_config.remote)
  target      = lookup(each.value, "target", var.pool_config.target)
}
