module "openshift" {
  source  = "terraform-openshift"
  version = "x.y.z"
  providers = {
    openshift = openshift
  }

  cluster_name = "my-openshift-cluster"
  region       = "us-west-2"
  # additional OpenShift specific variables
}