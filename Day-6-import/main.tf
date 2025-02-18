resource "aws_instance" "import" {
    ami = "ami-053a45fff0a704a47"
    key_name = "MyKeyPair"
    instance_type = "t2.micro"
    tags = {
        Nmae = "import"
    }

  }

