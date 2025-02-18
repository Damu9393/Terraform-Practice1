# Creating VPC
resource "aws_vpc" "Terraform" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Terraform_VPC"
  }
}

# Public Subnet creation (for the NAT Gateway)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.Terraform.id
  cidr_block              = "10.0.0.0/24" # Example public subnet CIDR
  availability_zone       = "us-east-1a"      # Replace with your desired AZ
  map_public_ip_on_launch = true # Important for public subnet
  tags = {
    Name = "Terraform_public_subnet"
  }
}

# Private Subnet creation
resource "aws_subnet" "private_subnet_a" { # Example private subnet
  vpc_id                  = aws_vpc.Terraform.id
  cidr_block              = "10.0.1.0/24" # Example private subnet CIDR (different from public)
  availability_zone       = "us-east-1a"      # Same AZ as your public subnet
  map_public_ip_on_launch = false # Important for private subnet
  tags = {
    Name = "Terraform_private_subnet_a"
  }
}


# Creation of the Internet Gateway
resource "aws_internet_gateway" "Terraform" {
  vpc_id = aws_vpc.Terraform.id
  tags = {
    Name = "Terraform_ig"
  }
}

# Creation of Public Route Table and Edit Route (for internet access)
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.Terraform.id
  route {
    gateway_id = aws_internet_gateway.Terraform.id
    cidr_block = "0.0.0.0/0" # Route all internet traffic
  }
  tags = {
    Name = "Terraform_public_RT"
  }
}

# Creation of Private Route Table and Edit Route (for NAT Gateway)
resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.Terraform.id
  route {
    nat_gateway_id = aws_nat_gateway.nat.id
    cidr_block     = "0.0.0.0/0" # Route all internet traffic through NAT Gateway
  }
  tags = {
    Name = "Terraform_private_RT_a"
  }
} # EIP 
data "aws_eip" "nat_eip" {
  id = "eipalloc-0a39c67f89884f11e" # The Allocation ID
}
# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id # NAT Gateway must be in a public subnet

  tags = {
    Name = "nat-gateway"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc" # Correct way to specify VPC association
  tags = {
    Name = "nat-eip"
  }
}



# Route Table Associations
resource "aws_route_table_association" "public_subnet_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_route_table_association" "private_subnet_association_a" {
  route_table_id = aws_route_table.private_route_table_a.id
  subnet_id      = aws_subnet.private_subnet_a.id
}


# ... (Previous code for VPC, subnets, IGW, route tables, NAT Gateway) ...

# Security Group for Public Subnet (Allowing SSH and HTTP from anywhere)
resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Allow SSH and HTTP from anywhere"
  vpc_id      = aws_vpc.Terraform.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (for demonstration)
    description = "SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
    description = "HTTP access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public_sg"
  }
}

# Security Group for Private Subnet (Allowing SSH from your IP and all outbound)
resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow SSH from your IP and all outbound"
  vpc_id      = aws_vpc.Terraform.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your actual IP address for SSH access
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"] # Important: Allow outbound to the internet (via NAT)
  }

  tags = {
    Name = "private_sg"
  }
}

# Example EC2 instance in the public subnet
resource "aws_instance" "public_instance" {
  ami           = "ami-085ad6ae776d8f09c" # Replace with your desired AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  tags = {
    Name = "public-instance"
  }
}

# Example EC2 instance in the private subnet
resource "aws_instance" "private_instance" {
  ami           = "ami-085ad6ae776d8f09c" # Replace with your desired AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_a.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  tags = {
    Name = "private-instance"
  }
  # IMPORTANT: No public IP assigned
}