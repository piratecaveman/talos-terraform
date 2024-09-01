network = {
  name       = "kbr0"
  ipv4_addr  = "192.168.100.1/24"
  dns_domain = "ks"
}

static_network = {
  name   = "eth0"
  offset = 50
  range  = "192.168.100"
}

pool_name = "kube"

profile = {
  name       = "terra"
  cloud_init = <<-EOH
    #cloud-config
    package_update: true
    packages:
      - ssh
      - vim
      - wget
      - curl
      - arp-scan
      - net-tools
      - kitty-terminfo
      - bash-completion
      - inetutils-telnet
      - apt-transport-https
    users:
      - name: wraith
        passwd: '$y$j9T$WaPjzyBAUF5.EVkMb4rtO.$553sbTGzXteM7b9H5MTAIhIgNTzzwjqQZDsC2GqZCKD'
        shell: /bin/bash
        lock_passwd: false
        sudo:
          - 'ALL=(ALL) NOPASSWD: ALL'
        ssh_authorized_keys:
          - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWSCBV+u+F8WqvZp3um1Wj/dq0vJpytljaRA1EuBJlm wraith@kelpie
      - name: root
        ssh_authorized_keys:
          - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWSCBV+u+F8WqvZp3um1Wj/dq0vJpytljaRA1EuBJlm wraith@kelpie
  EOH
}

image_name = "images:ubuntu/24.04/cloud/amd64"