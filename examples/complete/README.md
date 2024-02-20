# Complete Usage Example

This example is intended to show a standard use case for this module with a moderate amount of customization; it also includes the creation of all prerequisite resources:

```HCL
###########################
# Terraform Configuration #
###########################

terraform {
  required_version = ">= 1.6.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.21"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
  }
}

##############################
# AWS Provider Configuration #
##############################

provider "aws" {
  // DO NOT HARDCODE CREDENTIALS (Use Environment Variables)
}

###################################
# Required Prerequisite Resources #
###################################

module "terraform_aws_role_eks_cluster" {
  source = "kwaziio/role-eks-cluster/aws"

  iam_role_prefix = "example-service-"

  resource_tags = {
    Environment = "examples"
  }
}

module "terraform_aws_role_eks_node" {
  source = "kwaziio/role-eks-node/aws"

  iam_role_enable_ebs_csi        = true
  iam_role_enable_efs_csi        = true
  iam_role_enable_full_s3_access = true
  iam_role_prefix                = "example-service-"

  resource_tags = {
    Environment = "examples"
  }
}

module "network" {
  source = "kwaziio/network/aws"

  network_primary_cidr_block = "10.0.0.0/16"
  network_tags_name          = "example-network"
  network_trusted_ipv4_cidrs = ["0.0.0.0/0"]

  subnets_private = [
    {
      cidr = "10.0.0.0/19",
      name = "private-a",
      zone = "a",
    },
    {
      cidr = "10.0.32.0/19",
      name = "private-b",
      zone = "b",
    },
    {
      cidr = "10.0.64.0/19",
      name = "private-c",
      zone = "c",
    },
  ]

  subnets_public = [
    {
      cidr = "10.0.192.0/20",
      name = "public-a",
      zone = "a",
    },
    {
      cidr = "10.0.208.0/20",
      name = "public-b",
      zone = "b",
    },
    {
      cidr = "10.0.224.0/20",
      name = "public-c",
      zone = "c",
    },
  ]
}

module "terraform_aws_firewall_eks_cluster" {
  source = "kwaziio/firewall-eks-cluster/aws"

  network_id = module.network.network_id
}

module "terraform_aws_firewall_eks_node" {
  source = "kwaziio/firewall-eks-node/aws"

  firewall_bastion_id = module.network.firewall_bastion_id
  network_id          = module.network.network_id
}

module "terraform_aws_kubernetes_cluster" {
  source  = "kwaziio/kubernetes-cluster/aws"
  version = "0.2.0-alpha"

  kubernetes_cluster_cidr          = "10.15.0.0/16"
  kubernetes_cluster_firewall_ids  = [module.terraform_aws_firewall_eks_cluster.id]
  kubernetes_cluster_name          = "example-cluster"
  kubernetes_cluster_role_arn      = module.terraform_aws_role_eks_cluster.id
  kubernetes_cluster_subnet_ids    = module.network.subnets_private.*.id
  kubernetes_cluster_trusted_cidrs = ["0.0.0.0/0"]
}

######################################################
# Retrieves Information About the Active AWS Session #
######################################################

data "aws_caller_identity" "current" {}

#######################################################
# Requests Temporary EKS Cluster Authentication Token #
#######################################################

data "aws_eks_cluster_auth" "admin" {
  name = module.terraform_aws_kubernetes_cluster.cluster_name
}

#####################################
# Kubernetes Provider Configuration #
#####################################

provider "kubernetes" {
  cluster_ca_certificate = base64decode(module.terraform_aws_kubernetes_cluster.cluster_ca_certificate)
  host                   = module.terraform_aws_kubernetes_cluster.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.admin.token
}

#########################################################
# Example Terraform Kubernetes AWS VPC CNI Module Usage #
#########################################################

module "terraform_kubernetes_aws_vpc_cni" {
  source = "../../"
}
```

## Executing Example Deployment

The following example is provided as guidance, but can also be used for integration testing:

* [https://github.com/kwaziio/terraform-kubernetes-aws-vpc-cni/tree/main/examples/complete](https://github.com/kwaziio/terraform-kubernetes-vpc-cni/tree/main/examples/complete)

### Deploying Complete Example as Integration Test

The following commands will initialize and deploy the infrastructure for the complete example:

```SHELL
terraform -chdir=examples/complete init -reconfigure
terraform -chdir=examples/complete apply
```

### Destroying Complete Example After Integration Test

The following command will destroy any resources created while deploying the complete example:

```SHELL
terraform -chdir=examples/complete destroy
```
