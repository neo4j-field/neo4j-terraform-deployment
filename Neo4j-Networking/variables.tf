############################################################################################
# Version: 0.0.1
# Created Date: 26/11/2021
# Author: Maruthi Prithivirajan
# Email: maruthi.prithivirajan@neo4j.com
# Description:
# Terraform script hosting all (most) variables reqiured by the main.tf file
# Coverage: Firewall, GCE, GCS, Neo4j, APOC and Bloom
############################################################################################

variable "project" {
    description = "The project id where the VPC being provioned"
    type = string
}

variable "region" {
  description = "Region of the VPC/Subnetwork being created by this Terraform deployment"
  type = string
  default = "asia-southeast1"
}

variable "zone" {
    description = "Zone where the Network is being provisioned"
    type = string
    default = "asia-southeast1-a"
}

variable "credentials" {
    description = "The credentials from service account used for provisioning"
    type = string
    default = "keys/keys.json"
}

variable "vpc_name" {
  description = "Name of the VPC being used by this Terraform deployment"
  type = string
  default = "vpc-neo4j-custom"
}

variable "subnetwork_name" {
  description = "Name of the subnetwork being used by this Terraform deployment"
  type = string
  default = "subnetwork-neo4j-custom"
}

/*
Modify this, if you want to create a VPC spanning across multiple 
regions with Subnetworks in each region.
*/
variable "auto_create_subnetworks" {
  description = "If true, Terraform will automatically create subnetworks for the VPC"
  type = string
  default = "false"
}

variable "subnetwork_range" {
  description = "CIDR range of the subnetwork being used by this Terraform deployment"
  type = string
  default = "10.10.10.0/24"
}

variable "private_ip_google_access" {
  description = "If true, Terraform will automatically create a Google Access IP for the VPC"
  type = string
  default = "true"
}