variable "network_config" {
  default = {
    name        = null
    description = null
    type        = "bridge"
    config      = {}
    project     = null
    remote      = null
    target      = null
  }
}

variable "pool_config" {
  default = {
    name        = null
    driver      = "dir"
    description = null
    config      = {}
    project     = null
    remote      = null
    target      = null
  }
}

variable "profile_config" {
  default = {
    name        = null
    description = null
    devices     = {}
    config      = {}
    project     = null
    remote      = null
  }
}

variable "volume_config" {
  default = {
    name         = null
    pool         = null
    description  = null
    type         = "custom"
    content_type = "block"
    config       = {}
    project      = null
    remote       = null
    target       = null
  }
}

variable "instance_config" {
  default = {
    name             = null
    image            = null
    source_instances = {}
    description      = null
    type             = "container"
    ephemeral        = false
    running          = true
    wait_for_network = true
    profiles         = []
    devices          = {}
    files            = {}
    limits           = {}
    config           = {}
    project          = null
    remote           = null
    target           = null
  }
}