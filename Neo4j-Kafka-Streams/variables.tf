############################################################################################
# Version: 0.0.1
# Created Date: 26/11/2021
# Author: Maruthi Prithivirajan
# Email: maruthi.prithivirajan@neo4j.com
# Description:
# Terraform script hosting all (most) variables reqiured by the main.tf file
# Coverage: Kafaka, Neo4j Streams
############################################################################################

variable "bucket_name" {
    description = "Name of the GCS bucket used by this Terraform deployment"
    type = string
    default = "terraform-neo4j-kafka-deployer-01"
}

variable "vm_name" {
    description = "Name of the VM used by this Terraform deployment"
    type = string
    default = "neo4j-kafka-streams"
}

variable "zone" {
    description = "Zone of the VM used by this Terraform deployment"
    type = string
    default = "asia-southeast1-a"
}

variable "machine_type" {
    description = "Machine type of the VM used by this Terraform deployment"
    type = string
    default = "e2-medium"
}

variable "vpc_name" {
    description = "Name of the VPC used by this Terraform deployment"
    type = string
    default = "vpc-custom-neo4j"
}

variable "subnetwork_name" {
  description = "Name of the subnetwork used by this Terraform deployment"
  type = string
  default = "neo4j-subnetwork"
}

variable "subnetwork_range" {
  description = "Range of the subnetwork used by this Terraform deployment"
  type = string
  default = "10.10.10.0/24"
}

variable "firewall_priority" {
  description = "Priority of the firewall rule used by this Terraform deployment"
  type = string
  default = "1000"
}
variable "region" {
  description = "Region setting used by this Terraform deployment"
  type = string
  default = "asia-southeast1"
}

variable "private_ip_google_access" {
  description = "Private IP Google Access setting used by this Terraform deployment"
  type = string
  default = "true"
}

variable "neo4j_access_internal_name" {
  description = "Internal access firewall rule name used by this Terraform deployment"
  type = string
  default = "kafka-access-internal"
}

variable "neo4j_access_external_name" {
  description = "External access firewall rule name used by this Terraform deployment"
  type = string
  default = "kafka-access-external"
}

variable "neo4j_access_internal_ports" {
  description = "Internal access firewall rule ports used by this Terraform deployment"
  type = list(string)
  default = ["22", "7687"]
}


variable "neo4j_access_external_ports" {
  description = "External access firewall rule ports used by this Terraform deployment"
  type = list(string)
  default = ["22"]
}

variable "neo4j_access_external_range" {
  description = "External access firewall rule ingress allow IP range used by this Terraform deployment"
  type = string
  default = "0.0.0.0/0"
}
variable "vm_os_image" {
  description = "OS image used by this Terraform deployment"
  type = string
  default = "ubuntu-os-pro-cloud/ubuntu-pro-1804-lts"
}

variable "vm_boot_disk_size" {
  description = "Boot disk size used by this Terraform deployment"
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

/*
Hardcoding the internal IP address of the VMs used by this Terraform deployment. 
You can replace this with a dynamic IP address by making changes to the `main.tf` file.
*/
variable "static_internal_ips" {
  type = string
  default = "10.10.10.31"
}

variable "static_external_ip_name" {
  description = "Name assigned to External IP used by this Terraform deployment"
  type = string
  default = "neo4j-kafka-external-ip"
}

/*
Optional as the default config is  `External`, 
just having this here for flexibility of future needs
*/
variable "static_external_ip_address_type" {
  description = "Type of the External IP used by this Terraform deployment"
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
  description = "Scope of the VM used by this Terraform deployment"
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
  default = "neo4j-kafka"
}

variable "vm_storage_disk_name" {
  description = "Name of the storage disk used by this Terraform deployment"
  type = string
  default = "neo4j-kafka-disk"
}

variable "vm_storage_disk_size" {
  description = "Size of the storage disk used by this Terraform deployment"
  type = number
  default = 50
}

variable "vm_storage_disk_type" {
  description = "Type of the storage disk used by this Terraform deployment"
  type = string
  default = "pd-ssd"
}

variable "storage_class" {
  description = "Storage class used by this Terraform deployment"
  type = string
  default = "STANDARD"
}

variable "kafka_streams" {
  description = "Name of the packages in the `assets/` folder to be uploaded as part of this Terraform deployment"
  type = list(string)
  default = ["confluent-community-7.0.0.tar", "neo4j-kafka-connect-neo4j-2.0.0.zip", "sink_connector.properties", "source_connector.properties"]
}
