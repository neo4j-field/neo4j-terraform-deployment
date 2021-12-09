<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 3.85.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 3.85.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_address.ext_static](https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/compute_address) | resource |
| [google_compute_attached_disk.attach-disk1](https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/compute_attached_disk) | resource |
| [google_compute_disk.disk1](https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/compute_disk) | resource |
| [google_compute_firewall.neo4j-access-external](https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.neo4j-access-internal](https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/compute_firewall) | resource |
| [google_compute_instance.neo4j-gce](https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/compute_instance) | resource |
| [google_storage_bucket.gcs-neo4j-bucket](https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_object.upload_database](https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/storage_bucket_object) | resource |
| [google_storage_bucket_object.upload_licenses](https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/storage_bucket_object) | resource |
| [google_storage_bucket_object.upload_plugins](https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/storage_bucket_object) | resource |
| [local_file.render_setup_template](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_stopping_for_update"></a> [allow\_stopping\_for\_update](#input\_allow\_stopping\_for\_update) | n/a | `string` | `"true"` | no |
| <a name="input_allow_upgrade"></a> [allow\_upgrade](#input\_allow\_upgrade) | Allow upgrade of the Neo4j DB being provisioned | `string` | `"true"` | no |
| <a name="input_apoc_version"></a> [apoc\_version](#input\_apoc\_version) | Neo4j APOC version to be installed | `string` | `"4.3.0.4"` | no |
| <a name="input_bloom_license"></a> [bloom\_license](#input\_bloom\_license) | Bloom license to be used by this Terraform deployment | `string` | `"bloom.txt"` | no |
| <a name="input_bloom_version"></a> [bloom\_version](#input\_bloom\_version) | Neo4j Bloom version to be installed | `string` | `"1.9.0"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the GCS bucket to be used by this Terraform deployment | `string` | `"terraform-neo4j-gds-deployer-01"` | no |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | GCP Credentials | `string` | `"keys/keys.json"` | no |
| <a name="input_db_owner"></a> [db\_owner](#input\_db\_owner) | n/a | `string` | `"neo4j"` | no |
| <a name="input_firewall_priority"></a> [firewall\_priority](#input\_firewall\_priority) | Firewall priority of the VM being provisioned by this Terraform deployment | `string` | `"1000"` | no |
| <a name="input_firewall_rule_tags"></a> [firewall\_rule\_tags](#input\_firewall\_rule\_tags) | Firewall rule tags used by this Terraform deployment | `list(string)` | <pre>[<br>  "neo4j-access"<br>]</pre> | no |
| <a name="input_gcs_version"></a> [gcs\_version](#input\_gcs\_version) | Neo4j GCS connector version to be installed | `string` | `"3.5"` | no |
| <a name="input_gds_license"></a> [gds\_license](#input\_gds\_license) | GDS license to be used by this Terraform deployment | `string` | `"gds.txt"` | no |
| <a name="input_gds_version"></a> [gds\_version](#input\_gds\_version) | Neo4j GDS version to be installed | `string` | `"1.7.2"` | no |
| <a name="input_initial_heap_size"></a> [initial\_heap\_size](#input\_initial\_heap\_size) | n/a | `string` | `"1"` | no |
| <a name="input_labels_env"></a> [labels\_env](#input\_labels\_env) | Environment labels used by this Terraform deployment | `string` | `"testing"` | no |
| <a name="input_labels_group"></a> [labels\_group](#input\_labels\_group) | Group labels used by this Terraform deployment | `string` | `"neo4j-gds-standalone"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Machine type of the VM being provisioned | `string` | `"e2-medium"` | no |
| <a name="input_max_heap_size"></a> [max\_heap\_size](#input\_max\_heap\_size) | n/a | `string` | `"1"` | no |
| <a name="input_neo4j_access_external_name"></a> [neo4j\_access\_external\_name](#input\_neo4j\_access\_external\_name) | External access firewall rule name used by this Terraform deployment | `string` | `"neo4j-access-gds-external"` | no |
| <a name="input_neo4j_access_external_ports"></a> [neo4j\_access\_external\_ports](#input\_neo4j\_access\_external\_ports) | External access firewall rule ports used by this Terraform deployment | `list(string)` | <pre>[<br>  "22",<br>  "7474",<br>  "7687"<br>]</pre> | no |
| <a name="input_neo4j_access_external_range"></a> [neo4j\_access\_external\_range](#input\_neo4j\_access\_external\_range) | External access firewall rule ingress allow IP range used by this Terraform deployment | `string` | `"0.0.0.0/0"` | no |
| <a name="input_neo4j_access_internal_name"></a> [neo4j\_access\_internal\_name](#input\_neo4j\_access\_internal\_name) | Internal access firewall rule name used by this Terraform deployment | `string` | `"neo4j-access-gds-internal"` | no |
| <a name="input_neo4j_access_internal_ports"></a> [neo4j\_access\_internal\_ports](#input\_neo4j\_access\_internal\_ports) | Internal access firewall rule ports used by this Terraform deployment | `list(string)` | <pre>[<br>  "7687"<br>]</pre> | no |
| <a name="input_neo4j_database"></a> [neo4j\_database](#input\_neo4j\_database) | Neo4j Database package name used to upload to GCS in this Terraform deployment | `string` | `"neo4j-enterprise-4.3.7-unix.tar.gz"` | no |
| <a name="input_neo4j_licenses"></a> [neo4j\_licenses](#input\_neo4j\_licenses) | Neo4j License key names used to upload to GCS in this Terraform deployment | `list(string)` | <pre>[<br>  "bloom.txt",<br>  "gds.txt"<br>]</pre> | no |
| <a name="input_neo4j_plugins"></a> [neo4j\_plugins](#input\_neo4j\_plugins) | Neo4j Plugin package names used to upload to GCS in this Terraform deployment | `list(string)` | <pre>[<br>  "apoc-4.3.0.4-all.jar",<br>  "google-cloud-storage-dependencies-3.5-apoc.jar",<br>  "neo4j-bloom-1.9.0.zip",<br>  "neo4j-graph-data-science-1.7.2-standalone.zip"<br>]</pre> | no |
| <a name="input_neo4j_version"></a> [neo4j\_version](#input\_neo4j\_version) | Neo4j version to be installed | `string` | `"4.3.7"` | no |
| <a name="input_page_cache_size"></a> [page\_cache\_size](#input\_page\_cache\_size) | n/a | `string` | `"1"` | no |
| <a name="input_project"></a> [project](#input\_project) | The project id where the VPC being provioned | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where the VM is being provisioned | `string` | `"asia-southeast1"` | no |
| <a name="input_scheduling_automatic_restart"></a> [scheduling\_automatic\_restart](#input\_scheduling\_automatic\_restart) | n/a | `string` | `"false"` | no |
| <a name="input_scheduling_preemptible"></a> [scheduling\_preemptible](#input\_scheduling\_preemptible) | n/a | `string` | `"false"` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | Service account used by this Terraform deployment | `string` | n/a | yes |
| <a name="input_static_external_ip_address_type"></a> [static\_external\_ip\_address\_type](#input\_static\_external\_ip\_address\_type) | n/a | `string` | `"EXTERNAL"` | no |
| <a name="input_static_external_ip_name"></a> [static\_external\_ip\_name](#input\_static\_external\_ip\_name) | Name assigned to External IP used by this Terraform deployment | `string` | `"neo4j-gds-standalone-external-ip"` | no |
| <a name="input_static_internal_ip"></a> [static\_internal\_ip](#input\_static\_internal\_ip) | n/a | `string` | `"10.10.10.9"` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Storage class used by this Terraform deployment | `string` | `"STANDARD"` | no |
| <a name="input_subnetwork_range"></a> [subnetwork\_range](#input\_subnetwork\_range) | Subnetwork range used by this Terraform deployment | `string` | `"10.10.10.0/24"` | no |
| <a name="input_vm_boot_disk_delete_on_termination"></a> [vm\_boot\_disk\_delete\_on\_termination](#input\_vm\_boot\_disk\_delete\_on\_termination) | n/a | `string` | `"true"` | no |
| <a name="input_vm_boot_disk_size"></a> [vm\_boot\_disk\_size](#input\_vm\_boot\_disk\_size) | Boot disk size of the VM being provisioned | `number` | `30` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | Name of the VM being provisioned by this Terraform deployment | `string` | `"neo4j-gds-standalone-01"` | no |
| <a name="input_vm_os_image"></a> [vm\_os\_image](#input\_vm\_os\_image) | OS image of the VM being provisioned | `string` | `"ubuntu-os-pro-cloud/ubuntu-pro-1804-lts"` | no |
| <a name="input_vm_scope"></a> [vm\_scope](#input\_vm\_scope) | n/a | `list(string)` | <pre>[<br>  "cloud-platform"<br>]</pre> | no |
| <a name="input_vm_storage_disk_name"></a> [vm\_storage\_disk\_name](#input\_vm\_storage\_disk\_name) | Name of the storage disk used by the VM provisioned by this Terraform deployment | `string` | `"neo4j-gds-standalone-disk-01"` | no |
| <a name="input_vm_storage_disk_size"></a> [vm\_storage\_disk\_size](#input\_vm\_storage\_disk\_size) | Size of the storage disk used by the VM provisioned by this Terraform deployment | `number` | `50` | no |
| <a name="input_vm_storage_disk_type"></a> [vm\_storage\_disk\_type](#input\_vm\_storage\_disk\_type) | Type of the storage disk used by the VM provisioned by this Terraform deployment | `string` | `"pd-ssd"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC being used in provisioning the services of this Terraform deployment | `string` | `"vpc-neo4j-custom"` | no |
| <a name="input_vpc_subnetwork"></a> [vpc\_subnetwork](#input\_vpc\_subnetwork) | Subnetwork of the VPC being used in provisioning the services of this Terraform deployment | `string` | `"subnetwork-neo4j-custom"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone where the VM is being provisioned | `string` | `"asia-southeast1-a"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->