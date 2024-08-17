variable "kubenet" {
  type = list(string)
  default = [
    "kube-control-1",
    "kube-minion-1",
    "kube-minion-2"
  ]
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
