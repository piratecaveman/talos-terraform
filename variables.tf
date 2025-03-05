variable "pool_config" {
  default = {
    name        = null
    driver      = null
    description = null
    config      = null
    project     = null
    remote      = null
    target      = null
  }
}

variable "network_config" {
  default = {
    name        = null
    description = null
    type        = null
    config      = null
    project     = null
    remote      = null
    target      = null
  }

}

variable "profile_config" {
  default = {
    name        = null
    description = null
    devices     = null
    config      = null
    project     = null
    remote      = null
  }
}

variable "volume_config" {
  default = {
    name          = null
    pool          = null
    description   = null
    type          = null
    content_type  = null
    config        = null
    project       = null
    remote        = null
    target        = null
    source_volume = null
  }
}

variable "instance_config" {
  default = {
    name             = null
    image            = null
    description      = null
    type             = null
    ephemeral        = null
    running          = null
    wait_for_network = null
    profiles         = null
    devices          = null
    files            = null
    config           = null
    project          = null
    remote           = null
    target           = null
  }
}
