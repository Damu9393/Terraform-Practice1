resource "aws_instance" "innova" {
    ami = "ami-053a45fff0a704a47"
    instance_type = "t2.micro"
    availability_zone = "us-east-1b"
    key_name = "MyKeyPair"
    
  tags = {
    Name = "damu"
  }

#below examples are for lifecycle meta_arguments 

 # lifecycle {
  #   create_before_destroy = true    #this attribute will create the new object first and then destroy the old one
   #}

#lifecycle {
  # prevent_destroy = true    #Terraform will error when it attempts to destroy a resource when this is set to true:
 #}


  lifecycle {
    ignore_changes = [tags,instance_type] #This means that Terraform will never update the object but will be able to create or destroy it.
  }
}