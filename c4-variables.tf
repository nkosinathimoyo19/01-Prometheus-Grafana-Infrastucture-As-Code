variable "aws_region" {
    description = "aws region"
    type = string
    default = "us-east-1"
}

variable "ec2_instance_type" {
    description = "type of instance"
    type = string
    default = "t2.medium"
}

variable "ec2_keypair" {
    description = "value"
    type = string
    default = "sample-key"
}