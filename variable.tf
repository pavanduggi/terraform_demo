variable "region" {
  type        = string
  description = "name of the region"
}

variable "access_key" {
  type        = string
  description = "access key"
}

variable "secret_key" {
  type        = string
  description = "secret key"
}

variable "vpc_cidr" {
  type        = string
  description = "cidr range of vpc"
}

variable "public_subnet_cidr" {
  type        = list(any)
  description = "cidr range of public subnet "
}

variable "private_subnet_cidr" {
  type        = list(any)
  description = "cidr range of private subnet"
}

variable "ami" {
  type        = string
  description = "image of the instance"
}

variable "instance_type" {
  type        = string
  description = "type of the instance"
}

/* variable "vpc_name" {
  type        = string
  description = "name of the vpc"
} */

variable "public_subnet_name" {
  type        = list(any)
  description = "name of the public subnet"
}
variable "private_subnet_name" {
  type        = list(any)
  description = "name of the private subnet"
}

variable "security_group_name" {
  type        = string
  description = "name of the security group"
}

variable "instance_name" {
  type        = string
  description = "name of the instance"
}

variable "env" {
  type        = string
  description = "name of the security group"
}
