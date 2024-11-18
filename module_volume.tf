module "volume" {
  for_each = local.volumes
  source   = "./incus/volume"

  name         = try(each.value.name, each.key)
  pool         = lookup(each.value, "pool", var.volume_config.pool)
  description  = lookup(each.value, "description", var.volume_config.description)
  type         = lookup(each.value, "type", var.volume_config.type)
  config       = merge(var.volume_config.config, try(each.value.config, {}))
  content_type = lookup(each.value, "content_type", var.volume_config.content_type)
  project      = lookup(each.value, "project", var.volume_config.project)
  remote       = lookup(each.value, "remote", var.volume_config.remote)
  target       = lookup(each.value, "target", var.volume_config.target)
}
