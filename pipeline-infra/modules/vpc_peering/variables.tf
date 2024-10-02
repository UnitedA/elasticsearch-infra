
variable "vpc_id" {
  type = string
}
variable "region_name" {
  type = string
  default = "eu-west-3"
  
}

variable "vpc_peering_name" {
  type = string
  default = "elasticsearch_peering"
}


variable "cidr_range" {
  type = string
  default = "172.16.0.0/22"
}

variable"public_route_table_id" {
  type = string
}

variable "private_route_table_id" {
 type = string
}

variable "default_vpc_cidr" {
  type = string
  default = "172.31.0.0/16"

}
