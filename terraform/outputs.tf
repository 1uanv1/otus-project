output "cluster_name" {
  value = yandex_kubernetes_cluster.k8s.name
}

output "ingress_static_ip" {
  value = yandex_vpc_address.ingress_ip.external_ipv4_address[0].address
}

