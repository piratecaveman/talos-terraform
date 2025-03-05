locals {
  pools = {
    defaults = {
      driver = "dir"
      config = {}
    }

    items = {
      talos = {
        description = "Pool for k8s root disk"
      }
      ceph = {
        description = "For ceph on k8s"
      }
    }
  }

  networks = {
    defaults = {
      type           = "bridge"
      "ipv4.dhcp"    = true
      "ipv4.nat"     = true
      "ipv6.address" = "none"
    }
    items = {
      k8s = {
        description = "Kubernetes network"
        config = {
          "dns.domain"   = "ks"
          "ipv4.address" = "10.100.101.1/24"
          "ipv4.nat"     = true
          "ipv6.address" = "none"
        }
      }
    }
  }

  profiles = {
    defaults = {
      config = {
        "boot.autostart"       = true
        "cloud-init.user-data" = file("data/cloud-init.user-data.yml")
      }
    }
    items = {
      k8s = {
        description = "Profile for k8s"
        devices = {
          eth0 = {
            name = "eth0"
            type = "nic"
            properties = {
              name    = "eth0"
              network = module.networks.k8s.network.name
            }
          }
          root = {
            name = "root"
            type = "disk"
            properties = {
              pool = module.pools.talos.pool.name
              path = "/"
            }
          }
        }
      }
    }
  }

  volumes = {
    defaults = {
      pool         = module.pools.ceph.pool.name
      content_type = "block"
      config = {
        size              = "12GB"
        "security.shared" = true
      }
      source_volume = null
    }
    items = {
      mk8s  = {}
      wk8s1 = {}
      wk8s2 = {}
    }
  }

  instances = {
    defaults = {
      image    = "images:ubuntu/24.04/cloud/amd64"
      type     = "virtual-machine"
      profiles = [module.profiles.k8s.profile.name]
      config = {
        "limits.cpu"    = 4
        "limits.memory" = "6GB"
      }
    }
    items = {
      mk8s = {
        description = "Cluster master"
        devices = {
          mk8s = {
            name = "mk8s"
            type = "disk"
            properties = {
              source = module.volumes.mk8s.volume.name
              pool   = module.pools.ceph.pool.name
            }
          }
          eth0 = {
            name = "eth0"
            type = "nic"
            properties = {
              network = module.networks.k8s.network.name
              "ipv4.address" = "10.100.101.10"
            }
          }
        }
      }
      wk8s1 = {
        description = "Worker number 1"
        devices = {
          mk8s = {
            name = "wk8s1"
            type = "disk"
            properties = {
              source = module.volumes.wk8s1.volume.name
              pool   = module.pools.ceph.pool.name
            }
          }
          eth0 = {
            name = "eth0"
            type = "nic"
            properties = {
              network = module.networks.k8s.network.name
              "ipv4.address" = "10.100.101.11"
            }
          }
        }
      }
      wk8s2 = {
        description = "Worker number 2"
        devices = {
          mk8s = {
            name = "wk8s2"
            type = "disk"
            properties = {
              source = module.volumes.wk8s2.volume.name
              pool   = module.pools.ceph.pool.name
            }
          }
          eth0 = {
            name = "eth0"
            type = "nic"
            properties = {
              network = module.networks.k8s.network.name
              "ipv4.address" = "10.100.101.12"
            }
          }
        }
      }
    }
  }
}
