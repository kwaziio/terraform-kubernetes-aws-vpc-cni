##################################################################
# Creates AWS VPC CNI Configuration Map (if NOT Already Present) #
##################################################################

resource "kubernetes_config_map_v1" "aws_vpc_cni" {
  data = {
    branch-eni-cooldown              = "${var.aws_vpc_cni_branch_eni_cooldown}"
    enable-network-policy-controller = "${var.aws_vpc_cni_enable_network_policy_controller}"
    enable-windows-ipam              = "${var.aws_vpc_cni_enable_windows_ipam}"
    enable-windows-prefix-delegation = "${var.aws_vpc_cni_enable_windows_prefix_delegation}"
    minimum-ip-target                = "${var.aws_vpc_cni_minimum_ip_target}"
    warm-ip-target                   = "${var.aws_vpc_cni_warm_ip_target}"
    warm-prefix-target               = "${var.aws_vpc_cni_warm_prefix_target}"
  }

  lifecycle {
    ignore_changes = [
      data,
      metadata[0].annotations,
      metadata[0].labels,
    ]
  }

  metadata {
    name      = "amazon-vpc-cni"
    namespace = "kube-system"
  }
}

##############################################
# Updates AWS VPC_CNI Configuration Map Data #
##############################################

resource "kubernetes_config_map_v1_data" "aws_vpc_cni" {
  depends_on = [kubernetes_config_map_v1.aws_vpc_cni]
  force      = true
  
  data = {
    branch-eni-cooldown              = "${var.aws_vpc_cni_branch_eni_cooldown}"
    enable-network-policy-controller = "${var.aws_vpc_cni_enable_network_policy_controller}"
    enable-windows-ipam              = "${var.aws_vpc_cni_enable_windows_ipam}"
    enable-windows-prefix-delegation = "${var.aws_vpc_cni_enable_windows_prefix_delegation}"
    minimum-ip-target                = "${var.aws_vpc_cni_minimum_ip_target}"
    warm-ip-target                   = "${var.aws_vpc_cni_warm_ip_target}"
    warm-prefix-target               = "${var.aws_vpc_cni_warm_prefix_target}"
  }

  metadata {
    name      = "amazon-vpc-cni"
    namespace = "kube-system"
  }
}
