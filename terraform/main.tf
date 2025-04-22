provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-a"
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
