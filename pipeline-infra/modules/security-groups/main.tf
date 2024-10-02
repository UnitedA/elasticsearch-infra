data "aws_security_group" "default_sg" {
  vpc_id = var.vpc_id-01
  filter {
    name = "group-name"
    values = ["default"]
  }
}
resource "aws_security_group" "elastic-SG" {
  vpc_id = var.vpc_id
  name   = var.security_group_name

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
 ingress {
    from_port   = 0         # Allow all ports
    to_port     = 0         # Allow all ports
    protocol    = "-1"      # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from all sources
    ipv6_cidr_blocks = []  # Optional: Add IPv6 CIDR blocks if needed
  }


  dynamic "egress" {
    for_each = var.egress_ports
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  # Egress Rule to Allow All Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound traffic to all
  }

  # Ingress Rule for ICMP (Optional)
  ingress {
    from_port   = -1                # ICMP allows -1 for all types
    to_port     = -1                # ICMP allows -1 for all codes
    protocol    = "icmp"
    cidr_blocks = []                 # Specify allowed CIDR blocks if needed
    security_groups = [data.aws_security_group.default_sg.id] # Allow traffic from the default SG
    ipv6_cidr_blocks = []
  }


  tags = {
    Name = "elastic-SG"
  }
}
