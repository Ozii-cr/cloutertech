################################################################################
# VPC -public and private subnets
################################################################################
module "ct_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "ct-vpc"
  cidr = "10.1.0.0/16"

  azs = [
    "${var.aws_region}a",
    "${var.aws_region}b"
  ]

  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24"]


  map_public_ip_on_launch = true
  create_igw              = true
  enable_nat_gateway      = false
  single_nat_gateway      = false
  enable_vpn_gateway      = false
}

################################################################################
# Security Groups
################################################################################

resource "aws_security_group" "ct_server_sg" {
  name        = "CT-Server-SG"
  description = "Security group for ct server"
  vpc_id      = module.ct_vpc.vpc_id

  egress {
    description = "allow outbound traffic from all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sgr

  }
  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sgr

  }
  ingress {
    description = "ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sgr
  }
}


################################################################################
# EC2
################################################################################
module "ct_server" {
  source            = "../modules/ec2-instance"
  key_name          = "CtServerKey"
  ssh_public_key    = var.ssh_public_key_ct_server
  ami               = "ami-00ca570c1b6d79f36" #amazonlinux 23
  instance_type     = "t2.micro"
  security_group_id = aws_security_group.ct_server_sg.id
  subnet_id         = module.ct_vpc.public_subnets[0]
  instance_name     = "ct server"
  enable_eip        = false
  instance_state    = "running"
}
