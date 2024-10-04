# VPC Configuration
variable "cidr_block" {
  default = "172.16.0.0/22"
}

variable "aws_vpc" {
  default = "my_elasticsearch-vpc"
}

# Subnets Configuration
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["172.16.0.0/24", "172.16.1.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["172.16.2.0/24", "172.16.3.0/24"]
}
variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-3a", "eu-west-3b"]
}

# Tags for Resources
variable "tags" {
  type    = map(string)
  default = {}
}

# EC2 Instance Configuration
variable "ami_id" {
  default = "ami-04a92520784b93e73" # Adjust as needed
}

variable "instance_type" {
  default = "t3.medium"  # Suitable for Elasticsearch
}

variable "subnet_id" {
  default = "public"  # Using public subnets for now
}

variable "key_name" {
  default = "all_key"
}

variable "security_group_name" {
  default = "elasticsearch-SG"
}

# Security Group Configuration
variable "ingress_ports" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 9200
      to_port     = 9200
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Open to all IPs, adjust for security
    },
    {
      from_port   = 9300
      to_port     = 9300
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # For Elasticsearch cluster node communication
    },
    {
      from_port   = 5601
      to_port     = 5601
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # kibana
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # For SSH access
    },
    {
      from_port   = 0        
      to_port     = 0        
      protocol    = "-1"     
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "egress_ports" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# Autoscaling Configuration (Optional for clustering)
variable "desired_capacity" {
  default = "2"  # Two node Elasticsearch setup
}

variable "max_size" {
  default = "3"
}

variable "min_size" {
  default = "1"
}

# Elasticsearch Port
variable "port" {
  default = "9200"  # Default Elasticsearch port
}

variable "listener_port" {
  default = "9200"  # Listener port for Elasticsearch
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

variable "default_vpc_cidr" {
  type = string
  default = "172.31.0.0/16"
}
