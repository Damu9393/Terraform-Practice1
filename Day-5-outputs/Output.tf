output "ip" {
    value = aws_instance.Terraform.public_ip

  
}
output "az" {
    value = aws_instance.Terraform.availability_zone
  
}

output "private_ip" {
    value = aws_instance.Terraform.private_ip
    sensitive = true
  
}