############################################################################################
# Version: 0.0.1
# Created Date: 04/12/2021
# Author: Maruthi Prithivirajan
# Email: maruthi.prithivirajan@neo4j.com
# Description:
# Terraform script to deploy infratructure for Neo4j in Google Cloud Platform (GCP)
# Coverage: VPC, Subnet
############################################################################################

/*
Create VPC
*/
resource google_compute_network vpc-custom {
  name = var.vpc_name
  # This is set to false to avoid default subnetwork creation
  auto_create_subnetworks = var.auto_create_subnetworks
}

/*
Create Subnet
*/
resource "google_compute_subnetwork" "sub-custom" {
  name = var.subnetwork_name
  network = google_compute_network.vpc-custom.id
  ip_cidr_range = var.subnetwork_range
  region = var.region
  private_ip_google_access = var.private_ip_google_access
}