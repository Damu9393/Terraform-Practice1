# creation of VPC
resource "aws_vpc" "damu" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name= "terraform "
    }
}

#creation of public subnet 
resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.damu.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true 
    tags = {
        Name = terraform-public-subnet
    }
}

#creation of private subnet 
resource "aws_subnet" "private-subnet" {
    vpc_id = aws_vpc.damu.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = false
    tags = {
      Name = "terrafom-private-subnet"
    }
  
}

# creation of internet gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.damu.id
  tags = {
    Name = "terraform-ig"
  }
  
}
# creation of public RT
resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.damu.id
  route { 
    gateway_id = aws_internet_gateway.ig.id
    cidr_block = "0.0.0.0/0" # allow all trafic 
  }
  tags = {
    Name = "public-RT"
  }
  
}
