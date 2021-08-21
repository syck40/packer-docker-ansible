packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
  #changes = ["ENTRYPOINT nginx -g 'daemon off;'"]
  #   changes = [
  #     "ENTRYPOINT /bin/sh -c",
  #     "CMD bash"
  #   ]
}

variable "docker_image" {
  type    = string
  default = "ubuntu:focal"
}

build {
  name = "packer-ubuntu"
  sources = [
    "source.docker.ubuntu"
  ]

  provisioner "file" {
      destination = "/tmp/"
      source = "./ansible"
  }

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world"
    ]
    script = "install-ansible.sh"
  }

  provisioner "shell" {
    inline = ["ansible-galaxy collection install -r /tmp/ansible/requirements.yml"]
  }

  provisioner "ansible-local" {
    galaxy_file = "ansible/requirements.yml"
    #galaxy_command = "ansible-galaxy install ansible/requirements.yml"
    playbook_dir            = "ansible"
    playbook_file           = "ansible/main.yml"
    extra_arguments         = ["--extra-vars", "ansible_python_interpreter=/usr/bin/python3"]
    clean_staging_directory = true
  }

  post-processor "docker-tag" {
    repository = "syck40"
    tags       = ["ubuntu-bionic", "packer-rocks"]
    only       = ["docker.ubuntu"]
  }

  post-processor "manifest" {}
}
