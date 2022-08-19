############################################################################################
# Version: 0.0.1
# Created Date: 26/11/2021
# Author: Maruthi Prithivirajan
# Email: maruthi.prithivirajan@neo4j.com
# Description:
# Terraform script to deploy infratructure for neo4j Standalone instance in Google Cloud Platform (GCP)
# Coverage: Firewall, GCE, GCS, Neo4j APOC and Bloom
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

locals {
  # Will be removed in future commits
  # discovery_addresses = "${join(",", [for ip in var.static_internal_ips : format("%s%s", ip, ":5000")])}"
  discovery_addresses = "${join(",", [for num in range(length(var.static_internal_ips)) : format("%s%s", "${var.vm_name}-${num + 1}", ":5000")])}"
  # internal_ports = "${join(",", [for int in var.neo4j_access_internal_ports : format("%s", "${int}")])}"
  # external_ports = "${join(",", [for ext in var.neo4j_access_external_ports : format("%s", "${ext}")])}"
}
resource "google_compute_instance" "neo4j-gce" {
  count = length(var.static_internal_ips)
  name = "${var.vm_name}-${count.index+1}"
  zone = var.zone
  machine_type = var.machine_type
  network_interface {
    network = var.vpc_name
    subnetwork = var.subnetwork_name
    network_ip = element(var.static_internal_ips, count.index)
    access_config {
      nat_ip = google_compute_address.ext_static[count.index].address
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

  metadata = {
    startup-script = templatefile("./scripts/setup.sh", {
                                                              "neo4j_version" = var.neo4j_version
                                                              "bloom_version" = var.bloom_version
                                                              "apoc_version" = var.apoc_version
                                                              "gcs_version" = var.gcs_version
                                                              "bucket_name" = var.bucket_name
                                                              "initial_heap_size" = var.initial_heap_size
                                                              "max_heap_size" = var.max_heap_size
                                                              "page_cache_size" = var.page_cache_size
                                                              "default_advertised_address" = google_compute_address.ext_static[count.index].address
                                                              "default_discovery_address" = "${var.vm_name}-${count.index+1}"
                                                              "cluster_address" = element(var.static_internal_ips, count.index)
                                                              "allow_upgrade" = var.allow_upgrade
                                                              "bloom_license" = var.bloom_license
                                                              "db_owner" = var.db_owner
                                                              "dbms_mode" = var.dbms_mode
                                                              "discovery_addresses" = local.discovery_addresses
                                                            })
  }

# Will be removed in the future commits
# depending on usage
# To support additional activities 
# not covered by Terraform providers 
  # metadata = {
  #   ssh-keys = "ubuntu:${file("./keys/id_rsa.pub")}"
  # }

  # provisioner "file" {
  # source = "./assets/test.txt"
  # destination = "/tmp/test.txt"

  #   connection {
  #     host = google_compute_address.ext_static.address
  #     type = "ssh"
  #     user = "ubuntu"
  #     private_key = "${file("./keys/id_rsa")}"
  #     agent = "false"
  #   }
  # }
  depends_on = [local_file.render_setup_template]
}

/*
Setup template renderer for validation of VM setup script
*/
resource local_file render_setup_template {
  depends_on = [
    google_storage_bucket_object.upload_database,
    google_storage_bucket_object.upload_licenses,
    google_storage_bucket_object.upload_plugins
  ]
  count = length(var.static_internal_ips)
  filename = "./out/rendered_template_${count.index + 1}.txt"
  content = templatefile("./scripts/setup.sh", {
                                                            "neo4j_version" = var.neo4j_version,
                                                            "bloom_version" = var.bloom_version,
                                                            "apoc_version" = var.apoc_version,
                                                            "gcs_version" = var.gcs_version,
                                                            "bucket_name" = var.bucket_name,
                                                            "initial_heap_size" = var.initial_heap_size,
                                                            "max_heap_size" = var.max_heap_size,
                                                            "page_cache_size" = var.page_cache_size,
                                                            "default_advertised_address" = google_compute_address.ext_static[count.index].address,
                                                            "default_discovery_address" = "${var.vm_name}-${count.index+1}",
                                                            "cluster_address" = element(var.static_internal_ips, count.index),
                                                            "allow_upgrade" = var.allow_upgrade,
                                                            "bloom_license" = var.bloom_license,
                                                            "db_owner" = var.db_owner,
                                                            "dbms_mode" = var.dbms_mode,
                                                            "discovery_addresses" = local.discovery_addresses
                                                          })
}

/*
Create static ip address for this VM
*/

resource "google_compute_address" "ext_static" {
  count = length(var.static_internal_ips)
  name = "${var.static_external_ip_name}-${count.index+1}"
  address_type = var.static_external_ip_address_type
}

/* 
This block will support the creation of the storage disk for the Neo4j Datastore.
Note: If disk is resized need to execute the following command 
inside the VM manually `sudo resize2fs </dev/sda>` 
*/
resource "google_compute_disk" "disks" {
  count = length(var.static_internal_ips)
  name = "${var.vm_storage_disk_name}-${count.index+1}"
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
  count = length(var.static_internal_ips)
  disk = google_compute_disk.disks[count.index].id
  instance = google_compute_instance.neo4j-gce[count.index].id
}

/*
Setup GCS | Upload the Neo4j and APOC jars to the GCS bucket
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

resource "google_storage_bucket_object" "upload_database" {
  name = "database/${var.neo4j_database}"
  bucket = "${google_storage_bucket.gcs-neo4j-bucket.name}"
  source = "./assets/database/${var.neo4j_database}"
}

resource "google_storage_bucket_object" "upload_licenses" {
  for_each = toset(var.neo4j_licenses)
  name = "licenses/${each.value}"
  bucket = "${google_storage_bucket.gcs-neo4j-bucket.name}"
  source = "./assets/licenses/${each.value}"
}

resource "google_storage_bucket_object" "upload_plugins" {
  for_each = toset(var.neo4j_plugins)
  name = "plugins/${each.value}"
  bucket = "${google_storage_bucket.gcs-neo4j-bucket.name}"
  source = "./assets/plugins/${each.value}"
}

/* 
Setup DNS to support Causal Cluster Routing 
*/

data "google_compute_network" "vpc-custom" {
  name = var.vpc_name
}

resource "google_dns_managed_zone" "causal-cluster-private-zone" {
  name        = "${var.vm_name}-private-zone"
  dns_name    = var.private_zone_dns
  description = var.private_zone_description
  labels = {
    "env" = var.labels_env
    "group" = var.labels_group
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.google_compute_network.vpc-custom.id
    }
  }
}

resource "google_dns_record_set" "recordset" {
  # provider = "google-beta"
  managed_zone = google_dns_managed_zone.causal-cluster-private-zone.name
  name         = var.recordset_name
  rrdatas      = var.static_internal_ips
  # Type and TTL are hard set 
  type         = "A"
  ttl          = 86400
}