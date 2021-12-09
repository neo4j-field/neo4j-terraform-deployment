############################################################################################
# Version: 0.0.1
# Created Date: 26/11/2021
# Author: Maruthi Prithivirajan
# Email: maruthi.prithivirajan@neo4j.com
# Description:
# Terraform script hosting GCP Provider and Project information
# Coverage: Terraform GCP Provider
############################################################################################
/*
Terraform GCP Provider Version Lock
*/
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.85.0"
    }
  }
}

/*
GCP Project Information
*/
provider "google" {
  # Configuration options
  project = var.project
  region = var.region
  zone = var.zone
  credentials = var.credentials
}