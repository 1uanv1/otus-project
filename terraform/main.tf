terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone      = var.zone
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}

resource "yandex_vpc_network" "default" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "default" {
  name           = "k8s-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.2.0.0/16"]
}

resource "yandex_kubernetes_cluster" "k8s" {
  name       = "cluster"
  network_id = yandex_vpc_network.default.id

  master {
    zonal {
      zone      = var.zone
      subnet_id = yandex_vpc_subnet.default.id
    }
    public_ip = true
  }

  service_account_id      = var.k8s_sa_id
  node_service_account_id = var.k8s_sa_id
  release_channel         = "RAPID"
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
