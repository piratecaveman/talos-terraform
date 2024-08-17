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

resource "incus_instance" "test" {
  name     = "test"
  type     = "virtual-machine"
  image    = "images:ubuntu/24.04/cloud/amd64"
  profiles = [var.profile.name]
}