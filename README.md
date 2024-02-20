# Terraform Kubernetes AWS VPC CNI Module by KWAZI

Terraform Module for Managing Amazon Web Services (AWS) Virtual Private Cloud (VPC) Container Network Interface (CNI) for an Elastic Kubernetes Service (EKS) Cluster on AWS

## Getting Started

> NOTE: This section assumes that you have Terraform experience, have already created an AWS account, and have already configured programmatic access to that account via access token, Single-Sign On (SSO), or AWS Identity and Access Management (IAM) role. If you need help, [checkout our website](https://www.kwazi.io).

The simplest way to get started is to create a `main.tf` file with the minimum configuration options. You can use the following as a template:

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

######################################################
# Retrieves Information About the Active AWS Session #
######################################################

data "aws_caller_identity" "current" {}

############################################################
# Retrieves Information About the Targeted AWS EKS Cluster #
############################################################

data "aws_eks_cluster" "cluster" {
  name = "CLUSTER_NAME"
}

#######################################################
# Requests Temporary EKS Cluster Authentication Token #
#######################################################

data "aws_eks_cluster_auth" "admin" {
  name = "CLUSTER_NAME"
}

#####################################
# Kubernetes Provider Configuration #
#####################################

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.cluster_ca_certificate)
  host                   = data.aws_eks_cluster.cluster.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.admin.token
}

#########################################################
# Example Terraform Kubernetes AWS VPC CNI Module Usage #
#########################################################

module "terraform_kubernetes_aws_vpc_cni" {
  source = "../../"
}

```

In the example above, you should replace the following templated values:

Placeholder | Description
--- | ---
`CLUSTER_NAME` | Replace this w/ the Name of the Targeted AWS EKS Cluster

## Need Help?

Working in a strict environment? Struggling to make design decisions you feel comfortable with? Want help from an expert that you can rely on -- one who won't abandon you when the job is finished?

Check us out at [https://www.kwazi.io](https://www.kwazi.io).

## Designing a Deployment

Before launching this module, your team should agree on the following decision points:

1. Will the cluster support Windows nodes?

### Will the cluster support Windows nodes?

By default, this modules assumes that Windows nodes are not supported for the associated cluster. To enable support for Windows nodes, set the following variable:

```HCL
aws_vpc_cni_enable_windows_ipam = true
```

## Major Created Resources

The following table lists resources that this module may create in Kubernetes, accompanied by conditions for when they will or will not be created:

Resource Name | Creation Condition
--- | ---
Kubernetes Configuration Map | Always

## Usage Examples

The following example(s) are provided as guidance:

* [examples/complete](examples/complete/README.md)
