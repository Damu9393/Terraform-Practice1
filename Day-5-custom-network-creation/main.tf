# Creating VPC
resource "aws_vpc" "Terraform" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Terraform_VPC"
  }
}

# Subnet creation
resource "aws_subnet" "name" {
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

# Route Table Subnet Association
resource "aws_route_table_association" "Terraform" {
  route_table_id = aws_route_table.Terraform.id
  subnet_id      = aws_subnet.name.id
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
resource "aws_nat_gateway" "example" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.Terraform_subnet.id
}

