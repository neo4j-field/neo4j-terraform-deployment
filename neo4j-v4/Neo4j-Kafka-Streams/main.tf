############################################################################################
# Version: 0.0.1
# Created Date: 26/11/2021
# Author: Maruthi Prithivirajan
# Email: maruthi.prithivirajan@neo4j.com
# Description:
# Terraform script to deploy infratructure for Kafka and Neo4j Streams in Google Cloud 
# Platform (GCP) to support Sync between Neo4j GDS and Causal Cluster 
# Coverage: Kafaka, Neo4j Streams
############################################################################################

/*
Setup Firewall
*/

resource "google_compute_firewall" "neo4j-access-internal" {
  name = var.neo4j_access_internal_name
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports = var.neo4j_access_internal_ports
  }
  allow {
    protocol = "udp"
    ports = var.neo4j_access_internal_ports
  }

  target_tags = var.firewall_rule_tags
  source_ranges = [ var.subnetwork_range ]
  priority = var.firewall_priority
}

resource "google_compute_firewall" "neo4j-access-external" {
  name = var.neo4j_access_external_name
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports = var.neo4j_access_external_ports
  }

  target_tags = var.firewall_rule_tags
  source_ranges = [ var.neo4j_access_external_range ]
  priority = var.firewall_priority
}

/*
Setup VM | Public IP | Storage Disk
*/
resource "google_compute_instance" "neo4j-gce" {
  name = var.vm_name
  zone = var.zone
  machine_type = var.machine_type
  network_interface {
    network = var.vpc_name
    subnetwork = var.subnetwork_name
    network_ip = var.static_internal_ips
    access_config {
      nat_ip = google_compute_address.ext_static.address
    }
  }
  boot_disk {
    initialize_params {
      image = var.vm_os_image
      size = var.vm_boot_disk_size
    }
    auto_delete = var.vm_boot_disk_delete_on_termination
  }
  tags = var.firewall_rule_tags
 
  # Update this as necessary to match your project and 
  # make sure update the `variables.tf` file to reflect 
  # your changes here.
  
  labels = {
    "env" = var.labels_env,
    "group" = var.labels_group
  }
  allow_stopping_for_update = var.allow_stopping_for_update
  scheduling {
    preemptible = var.scheduling_preemptible
    automatic_restart = var.scheduling_automatic_restart
  }
  service_account {
    email = var.service_account
    scopes = var.vm_scope
  }
  lifecycle {
    ignore_changes = [ attached_disk ]
  }

  # Script that will be executed on VM boot to setup Kafka and Neo4j Streams
  metadata = {
    startup-script = templatefile("./scripts/setup_kafka.sh", {"bucket_name" = var.bucket_name})
  }
  depends_on = [local_file.render_setup_template]
}

/*
Setup template renderer for validation of VM setup script
*/
resource local_file render_setup_template {
  depends_on = [
    google_storage_bucket_object.upload_kafka_assets
  ]
  filename = "./out/rendered_kafka_template.txt"
  content = templatefile("./scripts/setup_kafka.sh", {"bucket_name" = var.bucket_name})
}

/*
Create static ip address for this VM
*/

resource "google_compute_address" "ext_static" {
  name = var.static_external_ip_name
  address_type = var.static_external_ip_address_type
}

/* 
This block will support the creation of the storage disk for the Neo4j Datastore.
Note: If disk is resized need to execute the following command 
inside the VM manually `sudo resize2fs </dev/sda>` 
*/
resource "google_compute_disk" "disks" {
  name = var.vm_storage_disk_name
  size = var.vm_storage_disk_size
  type = var.vm_storage_disk_type
  zone = var.zone
  labels = {
    "env" = var.labels_env
  }
}

/*
Attach the disk created above to this VM
*/
resource "google_compute_attached_disk" "attach-disks" {
  disk = google_compute_disk.disks.id
  instance = google_compute_instance.neo4j-gce.id
}

/*
Setup GCS 
*/

resource google_storage_bucket gcs-neo4j-bucket {
  name = var.bucket_name
  location = var.region
  storage_class = var.storage_class
  labels = {
    "env" = var.labels_env
    "group" = var.labels_group
  }
  # Leaving the following as default
  uniform_bucket_level_access = true
  force_destroy = true
}

/*
Upload the Kafka and Neo4j Streams jars to the GCS bucket
*/
resource "google_storage_bucket_object" "upload_kafka_assets" {
  for_each = toset(var.kafka_streams)
  name = "${each.value}"
  bucket = "${google_storage_bucket.gcs-neo4j-bucket.name}"
  source = "./assets/${each.value}"
}
