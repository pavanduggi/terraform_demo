region              = "us-east-1"
access_key          = "AKIAVCNGHW4XQRMNUY4D"
secret_key          = "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"
/* vpc_name            = "kubernetes" */
vpc_cidr            = "10.0.0.0/16"
public_subnet_name  = ["public_subnet_1", "public_subnet_2", "public_subnet_3", "public_subnet_4"]
public_subnet_cidr  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_name = ["private_subnet_1", "private_subnet_2", "private_subnet_3", "private_subnet_4"]
private_subnet_cidr = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24"]
ami                 = "ami-005f9685cb30f234b"
instance_type       = "t3.small"
security_group_name = "k8_security_group"
instance_name       = "k8_instance"
env                 = "prosperix_uat"