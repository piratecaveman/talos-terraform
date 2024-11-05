module "profile" {
  source   = "../incus/profile"
  for_each = local.profiles

  name        = try(each.value.name, each.key)
  devices     = merge(var.profile_config.devices, try(each.value.devices, {}))
  config      = merge(var.profile_config.config, try(each.value.config, {}))
  description = lookup(each.value, "description", var.profile_config.description)
  project     = lookup(each.value, "project", var.profile_config.project)
  remote      = lookup(each.value, "remote", var.profile_config.remote)
}
