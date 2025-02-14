resource "aws_instance" "name" {
  ami = var.ami_id
  key_name = var.key
  instance_type = var.type
}
