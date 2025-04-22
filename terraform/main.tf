terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "default" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "default" {
  name           = "k8s-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.2.0.0/16"]
}

resource "yandex_vpc_address" "ingress_ip" {
  name = "hipster-ingress-ip"

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

output "ingress_static_ip" {
  value = yandex_vpc_address.ingress_ip.external_ipv4_address[0].address
}

resource "yandex_kubernetes_cluster" "k8s" {
  name       = "cluster"
  network_id = yandex_vpc_network.default.id

  master {
    zonal {
      zone      = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.default.id
    }
    public_ip = true
  }
  release_channel = "RAPID"
}

resource "yandex_kubernetes_node_group" "nodes" {
  cluster_id = yandex_kubernetes_cluster.k8s.id
  name       = "nodes"

  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 4
      cores  = 2
    }
    boot_disk {
      size = 50
      type = "network-ssd"
    }
    network_interface {
      subnet_ids = [yandex_vpc_subnet.default.id]
      nat        = true
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }
}

output "cluster_name" {
  value = yandex_kubernetes_cluster.k8s.name
}
