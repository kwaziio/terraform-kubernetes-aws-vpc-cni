######################################################
# Provides Information for AWS VPC CNI Configuration #
######################################################

output "data" {
  description = "Kubernetes AWS VPC CNI Configuration Map Data"
  value       = yamlencode(kubernetes_config_map_v1_data.aws_vpc_cni.data)
}
