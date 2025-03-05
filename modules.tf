module "pools" {
  source   = "./tfmods/pool"
  for_each = local.pools.items

  name        = each.key
  driver      = try(each.value.driver, try(local.pools.defaults.driver, var.pool_config.driver))
  description = try(each.value.description, try(local.pools.defaults.description, var.pool_config.description))
  config      = merge(try(var.pool_config.config, null), try(local.pools.defaults.config, null), try(each.value.config, null))
  project     = try(each.value.project, try(local.pools.defaults.project, try(var.pool_config.project, null)))
  remote      = try(each.value.remote, try(local.pools.defaults.remote, try(var.pool_config.remote, null)))
  target      = try(each.value.target, try(local.pools.defaults.target, try(var.pool_config.target, null)))
}

module "networks" {
  source   = "./tfmods/network"
  for_each = local.networks.items

  name        = each.key
  description = try(each.value.description, try(local.networks.defaults.description, var.network_config.description))
  type        = try(each.value.type, try(local.networks.defaults.type, var.network_config.type))
  config = merge(
    try(var.network_config.config, null),
    try(local.networks.defaults.config, null),
    try(each.value.config, null)
    ) == {} ? null : merge(
    try(var.network_config.config, null),
    try(local.networks.defaults.config, null),
    try(each.value.config, null)
  )
  project = try(each.value.project, try(local.networks.defaults.project, try(var.network_config.project, null)))
  remote  = try(each.value.remote, try(local.networks.defaults.remote, try(var.network_config.remote, null)))
  target  = try(each.value.target, try(local.networks.defaults.target, try(var.network_config.target, null)))
}

module "profiles" {
  source   = "./tfmods/profile"
  for_each = local.profiles.items

  name = each.key
  devices = merge(
    try(var.profile_config.devices, null),
    try(local.profiles.defaults.devices, null),
    try(each.value.devices, null)
    ) == {} ? null : merge(
    try(var.profile_config.devices, null),
    try(local.profiles.defaults.devices, null),
    try(each.value.devices, null)
  )
  config = merge(
    try(var.profile_config.config, null),
    try(local.profiles.defaults.config, null),
    try(each.value.config, null)
    ) == {} ? null : merge(
    try(var.profile_config.config, null),
    try(local.profiles.defaults.config, null),
    try(each.value.config, null)
  )
  description = try(each.value.description, try(local.profiles.defaults.description, var.profile_config.description))
  project     = try(each.value.project, try(local.profiles.defaults.project, try(var.profile_config.project, null)))
  remote      = try(each.value.remote, try(local.profiles.defaults.remote, try(var.profile_config.remote, null)))
}

module "volumes" {
  source   = "./tfmods/volume"
  for_each = local.volumes.items

  name         = each.key
  pool         = try(each.value.pool, try(local.volumes.defaults.pool, var.volume_config.pool))
  description  = try(each.value.description, try(local.volumes.defaults.description, var.volume_config.description))
  type         = try(each.value.type, try(local.volumes.defaults.type, var.volume_config.type))
  content_type = try(each.value.content_type, try(local.volumes.defaults.content_type, var.volume_config.content_type))
  config = merge(
    try(var.volume_config.config, null),
    try(local.volumes.defaults.config, null),
    try(each.value.config, null)
    ) == {} ? null : merge(
    try(var.volume_config.config, null),
    try(local.volumes.defaults.config, null),
    try(each.value.config, null)
  )
  project = try(each.value.project, try(local.volumes.defaults.project, var.volume_config.project))
  remote  = try(each.value.remote, try(local.volumes.defaults.remote, var.volume_config.remote))
  target  = try(each.value.target, try(local.volumes.defaults.target, var.volume_config.target))
  source_volume = merge(
    try(var.volume_config.source_volume, null),
    try(local.volumes.defaults.source_volume, null),
    try(each.value.source_volume, null)
    ) == {} ? null : merge(
    try(var.volume_config.source_volume, null),
    try(local.volumes.defaults.source_volume, null),
    try(each.value.source_volume, null)
  )
}

module "instances" {
  source   = "./tfmods/instance"
  for_each = local.instances.items

  name             = each.key
  image            = try(each.value.image, try(local.instances.defaults.image, var.instance_config.image))
  description      = try(each.value.description, try(local.instances.defaults.description, var.instance_config.description))
  type             = try(each.value.type, try(local.instances.defaults.type, var.instance_config.type))
  ephemeral        = try(each.value.ephemeral, try(local.instances.defaults.ephemeral, var.instance_config.ephemeral))
  running          = try(each.value.running, try(local.instances.defaults.running, var.instance_config.running))
  wait_for_network = try(each.value.wait_for_network, try(local.instances.defaults.wait_for_network, var.instance_config.wait_for_network))
  profiles         = try(each.value.profiles, try(local.instances.defaults.profiles, var.instance_config.profiles))
  devices = merge(
    try(var.instance_config.devices, null),
    try(local.instances.defaults.devices, null),
    try(each.value.devices, null)
    ) == {} ? null : merge(
    try(var.instance_config.devices, null),
    try(local.instances.defaults.devices, null),
    try(each.value.devices, null)
  )
  files = merge(
    try(var.instance_config.files, null),
    try(local.instances.defaults.files, null),
    try(each.value.files, null)
    ) == {} ? null : merge(
    try(var.instance_config.files, null),
    try(local.instances.defaults.files, null),
    try(each.value.files, null)
  )
  config = merge(
    try(var.instance_config.config, null),
    try(local.instances.defaults.config, null),
    try(each.value.config, null)
    ) == {} ? null : merge(
    try(var.instance_config.config, null),
    try(local.instances.defaults.config, null),
    try(each.value.config, null)
  )
  project = try(each.value.project, try(local.instances.defaults.project, var.instance_config.project))
  remote  = try(each.value.remote, try(local.instances.defaults.remote, var.instance_config.remote))
  target  = try(each.value.target, try(local.instances.defaults.target, var.instance_config.target))
}
