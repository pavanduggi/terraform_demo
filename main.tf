locals {
  env = var.env
}

resource "aws_key_pair" "key" {
  key_name   = "key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "${local.env}_key"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${local.env}_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${local.env}_igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${element(var.public_subnet_cidr,count.index)}"
  map_public_ip_on_launch = "true"
  count                   = 1
  tags = {
    Name = "${local.env}_${element(var.public_subnet_name,count.index)}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${element(var.private_subnet_cidr,count.index)}"
  map_public_ip_on_launch = "true"
  count                   = 1
  tags = {
    Name = "${local.env}_${element(var.private_subnet_name,count.index)}"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${local.env}_public_route_table"
  }
}

resource "aws_route_table_association" "assc_1" {
  subnet_id      = aws_subnet.public_subnet[0].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_nat_gateway" "nat_gateway" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${local.env}_nat_gateway"
    env = "${local.env}"
  }
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "${local.env}_private_route_table"
  }
}

resource "aws_route_table_association" "assc_2" {
  subnet_id      = aws_subnet.private_subnet[0].id
  route_table_id = aws_route_table.private_rt.id
}


resource "aws_security_group" "security_group" {
  name   = var.security_group_name
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.security_group_name}"
  }
}

resource "aws_instance" "instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.security_group.id]
  key_name               = "key"
  count                  = 1
  user_data              = file("k8_installation_script")
  tags = {
    Name = "${local.env}_${var.instance_name}"
    env = "${local.env}"
  }
}

