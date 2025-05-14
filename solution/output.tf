output "kube_config" {
  value = module.aks.aks.kube_config

  sensitive = true
}

output "resource_group_name" {
  value = module.rg.name
}

output "resource_group_location" {
  value = module.rg.location
}
output "aks_cluster_name" {
  value = module.aks.aks_cluster_name
}