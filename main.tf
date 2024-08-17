terraform {
  required_providers {
    incus = {
      source = "lxc/incus"
    }
  }
}

provider "incus" {
  generate_client_certificates = true
  accept_remote_certificate    = true
}

resource "incus_network" "kbr0" {
  name = var.network.name
  config = {
    "ipv4.address" = var.network.ipv4_addr
    "ipv4.nat"     = true
    "dns.domain"   = var.network.dns_domain
    "ipv6.address" = "none"
    "ipv6.nat"     = false
  }
}

resource "incus_storage_pool" "kube" {
  name   = var.pool_name
  driver = "dir"
}

resource "incus_profile" "terra" {
  name = var.profile.name
  config = {
    "cloud-init.user-data" = var.profile.cloud_init
  }
  device {
    name = var.profile.devices.eth_name
    type = "nic"
    properties = {
      name    = var.profile.devices.eth_name
      network = var.network.name
    }
  }

  device {
    name = "root"
    type = "disk"
    properties = {
      path = "/"
      pool = var.pool_name
    }
  }
}

resource "incus_storage_pool" "openebs" {
  name   = "openebs"
  driver = "dir"
}

resource "incus_storage_volume" "openebs" {
  count        = length(var.kubenet)
  name         = var.kubenet[count.index]
  pool         = incus_storage_pool.openebs.name
  content_type = "block"
  config = {
    size              = "10GB"
    "security.shared" = true
  }
}

resource "incus_instance" "kubenet" {
  count    = length(var.kubenet)
  name     = var.kubenet[count.index]
  type     = "virtual-machine"
  image    = var.image_name
  profiles = [var.profile.name]
  limits = {
    cpu    = 2
    memory = "3GB"
  }
  device {
    type = "disk"
    name = "${var.kubenet[count.index]}-volume"
    properties = {
      pool   = incus_storage_pool.openebs.name
      source = var.kubenet[count.index]
    }
  }
}
