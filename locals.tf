locals {
  # statics
  machines = [
    "kube-control-1",
    "kube-control-2",
    "kube-control-3",
    "kube-minion-1",
    "kube-minion-2",
    "kube-minion-3",
  ]
  ip_range_offset = 50
  ip_range = "192.168.100.1"

  networks = {
    terranet = {
      profile     = "terra"
      name        = "terranet"
      description = "Network for kubernetes"
      config = {
        "ipv4.address" = "${local.ip_range}/24"
        "ipv6.address" = "none"
        "dns.domain"   = "ks"
      }
    }
  }

  pools = {
    cube = {
      profile     = "terra"
      name        = "cube"
      description = "Pool for kubernetes"

    }
  }

  profiles = {
    terra = {
      name        = "terra"
      description = "Profile for kubernetes"
      config = {
        "cloud-init.user-data" = file("./data/cloud_init.yml")
        "boot.autostart"       = true
      }
      devices = {
        root = {
          name = "root"
          type = "disk"
          properties = {
            path = "/"
            pool = module.pool[[for item in local.pools : item.name if item.profile == "terra"][0]].pool.name
          }
        }
      }
    }
  }

  volumes = { for key in local.machines : key => {
    profile = "terra"
    name         = key
    pool         = module.pool[[for item in local.pools : item.name if item.profile == "terra"][0]].pool.name
    description  = "Kubernetes pool ${key}"
    type         = "custom"
    content_type = "block"
    config = {
      size              = "20GB"
      "security.shared" = true
    }
    }
  }

  instances = {for key in local.machines: key => {
    name = key
    image = "images:ubuntu/24.04/cloud/amd64"
    description = "Kubernetes node: ${key}"
    type = "virtual-machine"
    profiles = [for item in local.profiles: item.name if item.name == "terra"]
    devices = {
      "ceph" = {
        name = join("",[for item in split("-", key): substr(item, 0, 1)])
        type = "disk"
        properties = {
          source = module.volume[key].volume.name
          pool = module.pool[[for item in local.pools : item.name if item.profile == "terra"][0]].pool.name
        }
      }
      "network" = {
        name = "eth0"
        type = "nic"
        properties = {
          network = module.network[[for item in local.networks: item.name if item.profile == "terra"][0]].network.name
          "ipv4.address" = "${join(".", slice(split(".", local.ip_range), 0, 3))}.${tonumber(split(".", local.ip_range)[3]) + local.ip_range_offset - 1 + index(local.machines, key)}"
        }
      }
    }
  }}
}
