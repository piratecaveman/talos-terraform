terraform {
  required_providers {
    incus = {
      source  = "lxc/incus"
      version = ">=0.2.0"
    }
  }
}

provider "incus" {
  generate_client_certificates = true
  accept_remote_certificate    = true

  remote {
    name    = "local"
    scheme  = "unix"
    address = "/run/incus/unix.socket"
    default = true
  }
}


