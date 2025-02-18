# Creating VPC
resource "aws_vpc" "Terraform" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Terraform_VPC"
  }
}

# Subnet creation
resource "aws_subnet" "terraform" {
  vpc_id     = aws_vpc.Terraform.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "Terraform_subnet"
  }
}
 

# Creation of the Internet Gateway
resource "aws_internet_gateway" "Terraform" {
  vpc_id = aws_vpc.Terraform.id
  tags = {
    Name = "Terraform_ig"
  }
}

# Creation of Route Table and Edit Route
resource "aws_route_table" "Terraform" {
  vpc_id = aws_vpc.Terraform.id
  route {
    gateway_id = aws_internet_gateway.Terraform.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "Terraform_public_RT"
  }
}

/*# Creation of private Route Table and Edit Route
resource "aws_route_table" "Terraform" {
  vpc_id = aws_vpc.Terraform.id
  route {
    gateway_id = aws_internet_gateway.Terraform.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "Terraform_private_RT"
  }
}*/
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id # NAT Gateway must be in a public subnet

  tags = {
    Name = "nat-gateway"
  }
}

/*resource "aws_eip" "nat_eip" {
  vpc = true # Important: Associate with the VPC
  tags = {
    Name = "nat-eip"
  }
}*/

# Nat Gateway

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.Terraform # Replace with your VPC ID
  cidr_block              = "10.0.0.0/24"     # Replace with your public subnet CIDR
  availability_zone       = "us-east-1a"      # Replace with your desired AZ
  map_public_ip_on_launch = true # Public subnet for NAT Gateway
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_vpc" "terraform" { # Example VPC definition (replace with your existing VPC)
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform-vpc"
  }
}

# Route Table Subnet Association
resource "aws_route_table_association" "Terraform" {
  route_table_id = aws_route_table.Terraform.id
  subnet_id      = aws_subnet.terraform.id
}

# Create Security Group
resource "aws_security_group" "Terraform" {
  name        = "Tf_security_group"
  description = "allow all tcp ports"
  vpc_id      = aws_vpc.Terraform.id

  ingress {
    description = "Terraform"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Terraform"
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
    Name = "Terraform_security"
  }
}


