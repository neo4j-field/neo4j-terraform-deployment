<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 3.85.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 3.85.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_network.vpc-custom](https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.sub-custom](https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/compute_subnetwork) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_create_subnetworks"></a> [auto\_create\_subnetworks](#input\_auto\_create\_subnetworks) | If true, Terraform will automatically create subnetworks for the VPC | `string` | `"false"` | no |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | The credentials from service account used for provisioning | `string` | `"keys/keys.json"` | no |
| <a name="input_private_ip_google_access"></a> [private\_ip\_google\_access](#input\_private\_ip\_google\_access) | If true, Terraform will automatically create a Google Access IP for the VPC | `string` | `"true"` | no |
| <a name="input_project"></a> [project](#input\_project) | The project id where the VPC being provioned | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region of the VPC/Subnetwork being created by this Terraform deployment | `string` | `"asia-southeast1"` | no |
| <a name="input_subnetwork_name"></a> [subnetwork\_name](#input\_subnetwork\_name) | Name of the subnetwork being used by this Terraform deployment | `string` | `"subnetwork-neo4j-custom"` | no |
| <a name="input_subnetwork_range"></a> [subnetwork\_range](#input\_subnetwork\_range) | CIDR range of the subnetwork being used by this Terraform deployment | `string` | `"10.10.10.0/24"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC being used by this Terraform deployment | `string` | `"vpc-neo4j-custom"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone where the Network is being provisioned | `string` | `"asia-southeast1-a"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->