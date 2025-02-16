resource "aws_instance" "name" {
    ami = "ami-085ad6ae776d8f09c"
    instance_type = "t2.micro"
    key_name = "MyKeyPair"
    availability_zone = "us-east-1a"
          tags = {
            Name = "dev"
            }
   
}