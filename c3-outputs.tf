output "ec2_instance_ip" {
    description = "ec2 instance public ip"
    value = aws_instance.myec3.public_ip
}

output "ec2_public_dns" {
  description = "ec2 public dns"
  value = aws_instance.myec3.public_dns
}