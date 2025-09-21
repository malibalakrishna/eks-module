terraform {
required_version = ">= 1.5"
required_providers {
aws = {
source = "hashicorp/aws"
version = ">= 5.50"
}
helm = {
source = "hashicorp/helm"
version = ">= 2.13"
}
kubernetes = {
source = "hashicorp/kubernetes"
version = ">= 2.29"
}
}
}
