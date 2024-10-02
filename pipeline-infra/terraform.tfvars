cidr_block           = "172.16.0.0/22"
aws_vpc              = "my-elasticsearch-vpc"
public_subnet_cidrs  = ["172.16.0.0/24", "172.16.1.0/24"]
private_subnet_cidrs = ["172.16.2.0/24", "172.16.3.0/24"]
availability_zones   = ["eu-west-3a", "eu-west-3b"]
ami_id               = "ami-04a92520784b93e73"
instance_type        = "t3.medium"
key_name             = "all_key"
security_group_name  = "Elasticsearch-SG"
desired_capacity     = 1
max_size             = 3
min_size             = 1
port                 = 9200
listener_port        = 9200
tags = {
  Name = "Elasticsearch Instance"
}
