############################################################################################
# Version: 0.0.1
# Created Date: 26/11/2021
# Author: Maruthi Prithivirajan
# Email: maruthi.prithivirajan@neo4j.com
# Description:
# Terraform script hosting all (most) variables reqiured by the main.tf file
# Coverage: Firewall, GCE, GCS, Neo4j, GDS, APOC and Bloom
############################################################################################

variable "neo4j_version" {
    description = "Neo4j version to be installed"
    type = string
    default = "4.3.7"
}

variable "gds_version" {
    description = "Neo4j GDS version to be installed"
    type = string
    default = "1.7.2"
}

variable "bloom_version" {
    description = "Neo4j Bloom version to be installed"
    type = string
    default = "1.9.0"
}

variable "apoc_version" {
    description = "Neo4j APOC version to be installed"
    type = string
    default = "4.3.0.4"
}

variable "gcs_version" {
    description = "Neo4j GCS connector version to be installed"
    type = string
    default = "3.5"
}

variable "bucket_name" {
    description = "Name of the GCS bucket to be used by this Terraform deployment"
    type = string
    default = "terraform-neo4j-gds-deployer-01"
}

variable "storage_class" {
    description = "Storage class used by this Terraform deployment"
    type = string
    default = "STANDARD"
}

/*Enter memory config size, the 
inputs needs to be in GB relative 
to available memory*/
variable "initial_heap_size" {
    type = string
    default = "1"
}

/*Enter memory config size, the 
inputs needs to be in GB relative 
to available memory*/
variable "max_heap_size" {
    type = string
    default = "1"
}

/*Enter memory config size, the 
inputs needs to be in GB relative 
to available memory*/
variable "page_cache_size" {
    type = string
    default = "1"
}

variable "allow_upgrade" {
    description = "Allow upgrade of the Neo4j DB being provisioned"
    type = string
    default = "true"
}

variable "gds_license" {
    description = "GDS license to be used by this Terraform deployment"
    type = string
    default = "gds.txt"
}

variable "bloom_license" {
    description = "Bloom license to be used by this Terraform deployment"
    type = string
    default = "bloom.txt"
}

/*Provide the username that will 
own the DB in this instance*/
variable "db_owner" {
    type = string
    default = "neo4j"
}

variable "vm_name" {
    description = "Name of the VM being provisioned by this Terraform deployment"
    type = string
    default = "neo4j-gds-standalone-01"
}

variable "zone" {
    description = "Zone where the VM is being provisioned"
    type = string
    default = "asia-southeast1-a"
}

variable "region" {
  description = "Region where the VM is being provisioned"
  type = string
  default = "asia-southeast1"
}

variable "machine_type" {
    description = "Machine type of the VM being provisioned"
    type = string
    default = "e2-medium"
}

variable "vpc_name" {
    description = "Name of the VPC being used in provisioning the services of this Terraform deployment"
    type = string
    default = "vpc-custom-neo4j"
}

variable "vm_os_image" {
    description = "OS image of the VM being provisioned"
    type = string
    default = "ubuntu-os-pro-cloud/ubuntu-pro-1804-lts"
}

variable "vm_boot_disk_size" {
    description = "Boot disk size of the VM being provisioned"
    type = number
    default = 30
}

/*
Setting the value to `false` prevents the boot disk from being 
deleted during server upsizing or downsizing.
Setting the value to `true` deletes the boot disk and recommended 
when destroying this deployment.
*/
variable "vm_boot_disk_delete_on_termination" {
    type = string
    default = "true"
}

variable "firewall_rule_tags" {
    description = "Firewall rule tags used by this Terraform deployment"
    type = list(string)
    default = ["neo4j-access"]
}

/*
Set this to `true` to support resizing of the host VM Compute Engine instance.
*/
variable "allow_stopping_for_update" {
    type = string
    default = "true"
}

/*
Keep the following settings to `false` if you're 
not using preemptible instances
*/
variable "scheduling_preemptible" {
    type = string
    default = "false" 
}

/*
Keep the following settings to `false` if you're 
not using preemptible instances
*/
variable "scheduling_automatic_restart" {
    type = string
    default = "false" 
}

variable "vpc_subnetwork" {
    description = "Subnetwork of the VPC being used in provisioning the services of this Terraform deployment"
    type = string
    default = "neo4j-subnetwork"
}

/*
Hardcoding the internal IP address of the VMs used by this Terraform deployment. 
You can replace this with a dynamic IP address by making changes to the `main.tf` file.
This will deploy a single node instance. 
*/
variable "static_internal_ip" {
    type = string
    default = "10.10.10.9"
}

variable "static_external_ip_name" {
    description = "Name assigned to External IP used by this Terraform deployment"
    type = string
    default = "neo4j-gds-standalone-external-ip"
}

/*
Optional as the default config is  `External`, 
just having this here for flexibility of future needs
*/
variable "static_external_ip_address_type" {
    type = string
    default = "EXTERNAL"
}

variable "service_account" {
    description = "Service account used by this Terraform deployment"
    type = string
    default = "terraform-gcp@annular-moon-311601.iam.gserviceaccount.com"
}

/*
Adjust the scope of the VM instance as per your needs.
*/
variable "vm_scope" {
    type = list(string)
    default = ["cloud-platform"]
}

variable "labels_env" {
    description = "Environment labels used by this Terraform deployment"
    type = string
    default = "testing"
}

variable "labels_group" {
    description = "Group labels used by this Terraform deployment"
    type = string
    default = "neo4j-gds-standalone"
}

variable "vm_storage_disk_name" {
    description = "Name of the storage disk used by the VM provisioned by this Terraform deployment"
    type = string
    default = "neo4j-gds-standalone-disk-01"
}

variable "vm_storage_disk_size" {
    description = "Size of the storage disk used by the VM provisioned by this Terraform deployment"
    type = number
    default = 50
}

variable "vm_storage_disk_type" {
    description = "Type of the storage disk used by the VM provisioned by this Terraform deployment"
    type = string
    default = "pd-ssd"
}

variable "neo4j_database" {
  description = "Neo4j Database package name used to upload to GCS in this Terraform deployment"
  type = string
  default = "neo4j-enterprise-4.3.7-unix.tar.gz"
}

variable "neo4j_licenses" {
  description = "Neo4j License key names used to upload to GCS in this Terraform deployment"
  type = list(string)
  default = ["bloom.txt", "gds.txt"]
}

variable "neo4j_plugins" {
  description = "Neo4j Plugin package names used to upload to GCS in this Terraform deployment"
  type = list(string)
  default = ["apoc-4.3.0.4-all.jar", "google-cloud-storage-dependencies-3.5-apoc.jar", "neo4j-bloom-1.9.0.zip", "neo4j-graph-data-science-1.7.2-standalone.zip"]
}

variable "subnetwork_range" {
  description = "Subnetwork range used by this Terraform deployment"
  type = string
  default = "10.10.10.0/24"
}

variable "firewall_priority" {
  description = "Firewall priority of the VM being provisioned by this Terraform deployment"
  type = string
  default = "1000"
}

variable "neo4j_access_internal_name" {
  description = "Internal access firewall rule name used by this Terraform deployment"
  type = string
  default = "neo4j-access-gds-internal"
}

variable "neo4j_access_internal_ports" {
  description = "Internal access firewall rule ports used by this Terraform deployment"
  type = list(string)
  default = ["7687"]
}

variable "neo4j_access_external_name" {
  description = "External access firewall rule name used by this Terraform deployment"
  type = string
  default = "neo4j-access-gds-external"
}

variable "neo4j_access_external_ports" {
  description = "External access firewall rule ports used by this Terraform deployment"
  type = list(string)
  default = ["22", "7474", "7687"]
}

variable "neo4j_access_external_range" {
  description = "External access firewall rule ingress allow IP range used by this Terraform deployment"
  type = string
  default = "0.0.0.0/0"
}