# terraform 
# Create VPC
resource "aws_vpc" "lks_vpc" { //main(lks_vpc) bebas bisa diganti, terserah.
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "lks-vpc"
  }
}

# Subnet Public
resource "aws_subnet" "lks_public_subnet_1a" {
  vpc_id     = aws_vpc.lks_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "lks-public-subnet-1a"
  }
}

resource "aws_subnet" "lks_public_subnet_1b" {
  vpc_id     = aws_vpc.lks_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "lks-public-subnet-1b"
  }
}

# Subnet Private
resource "aws_subnet" "lks_private_subnet_1a" {
  vpc_id     = aws_vpc.lks_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "lks-private-subnet-1a"
  }
}

resource "aws_subnet" "lks_private_subnet_1b" {
  vpc_id     = aws_vpc.lks_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "lks-private-subnet-1b"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "lks_igw" {
  vpc_id = aws_vpc.lks_vpc.id

  tags = {
    Name = "lks-igw"
  }
}

# Elastic IP(eip) for Nat Gateway
resource "aws_eip" "lks_eip" {
    domain =  "vpc"
  
}

# Nat Gateway
resource "aws_nat_gateway" "lks_nat" {
  allocation_id = aws_eip.lks_eip.id
  subnet_id     = aws_subnet.lks_public_subnet_1a.id

  tags = {
    Name = "lks-nat"
  }
}

# Route Table Public + Route
resource "aws_route_table" "lks_rtb_public" {
  vpc_id = aws_vpc.lks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lks_igw.id
  }

  tags = {
    Name = "lks-rtb-public"
  }
}

# Route Table private
resource "aws_route_table" "lks_rtb_private" {
  vpc_id = aws_vpc.lks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.lks_nat.id
  }

  tags = {
    Name = "lks-rtb-private"
  }
}

# Association Subnet Public
resource "aws_route_table_association" "lks_public_subnet_1a_association" {
  subnet_id      = aws_subnet.lks_public_subnet_1a.id
  route_table_id = aws_route_table.lks_rtb_public.id
}

resource "aws_route_table_association" "lks_public_subnet_1b_association" {
  subnet_id      = aws_subnet.lks_public_subnet_1b.id
  route_table_id = aws_route_table.lks_rtb_public.id
}

# Association Subnet Private
resource "aws_route_table_association" "lks_private_subnet_1a_association" {
  subnet_id      = aws_subnet.lks_private_subnet_1a.id
  route_table_id = aws_route_table.lks_rtb_private.id
}

resource "aws_route_table_association" "lks_private_subnet_1b_association" {
  subnet_id      = aws_subnet.lks_private_subnet_1b.id
  route_table_id = aws_route_table.lks_rtb_private.id
}