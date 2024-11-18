module "instance" {
  for_each = local.instances
  source   = "./incus/instance"

  name             = try(each.value.name, each.key)
  source_instances = merge(var.instance_config.source_instances, try(each.value.source_instances, {}))
  description      = lookup(each.value, "description", var.instance_config.description)
  type             = lookup(each.value, "type", var.instance_config.type)
  ephemeral        = lookup(each.value, "ephemeral", var.instance_config.ephemeral)
  running          = lookup(each.value, "running", var.instance_config.running)
  wait_for_network = lookup(each.value, "wait_for_network", var.instance_config.wait_for_network)
  profiles         = lookup(each.value, "profiles", var.instance_config.profiles)
  devices          = merge(var.instance_config.devices, try(each.value.devices, {}))
  files            = merge(var.instance_config.files, try(each.value.files, {}))
  config           = merge(var.instance_config.config, try(each.value.config, {}))
  project          = lookup(each.value, "project", var.instance_config.project)
  remote           = lookup(each.value, "remote", var.instance_config.remote)
  target           = lookup(each.value, "target", var.instance_config.target)
}
