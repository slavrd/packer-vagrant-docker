variable "base_box" {
  type    = string
  default = "slavrd/bionic64"
}

variable "skip_add" {
  type    = bool
  default = true
}

variable "docker_version_string" {
  type    = string
  default = ""
}

source "vagrant" "ubuntu-docker" {
  communicator = "ssh"
  source_path  = var.base_box
  box_name     = var.base_box
  provider     = "virtualbox"
  add_force    = true
  skip_add     = var.skip_add
}

build {
  sources = ["source.vagrant.ubuntu-docker"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{.Vars}} sudo -E -S bash {{.Path}}"
    scripts = [
      "scripts/provision.sh",
      "scripts/cleanup.sh",
    ]
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "DOCKER_VERSION_STRING=${var.docker_version_string}",
    ]
  }
}