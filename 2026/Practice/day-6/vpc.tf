resource "aws_vpc" "myvpc" {
  cidr_block= "10.0.0.0/16"
  tags={
    Name= "vpc-1"
  }
  enable_dns_hostnames= true
}

resource "aws_subnet""mysubnet" {
    vpc_id =aws_vpc.myvpc.id
    availability_zone= "us-east-1a"
    cidr_block= "10.0.1.0/24"
    map_public_ip_on_launch= true
    tags={
        Name= "public-subnet-1"
    }
}
resource "aws_subnet""mysubnet2" {
    vpc_id =aws_vpc.myvpc.id
    availability_zone= "us-east-1a"
    cidr_block= "10.0.2.0/24"
    map_public_ip_on_launch= true
    tags={
        Name= "public-subnet-2"
    }
}

resource "aws_internet_gateway" "myigw" {
    vpc_id= aws_vpc.myvpc.id
    tags={
        Name= "my-igw"
    }
}


resource "aws_route_table" "myrt" {
    vpc_id= aws_vpc.myvpc.id
    route {
        cidr_block= "0.0.0.0/0"
        gateway_id= aws_internet_gateway.myigw.id
        }
}

resource "aws_route_table_association" "myrta" {
    subnet_id= aws_subnet.mysubnet.id
    route_table_id= aws_route_table.myrt.id
}
resource "aws_route_table_association" "myrta2" {
    subnet_id= aws_subnet.mysubnet2.id
    route_table_id= aws_route_table.myrt.id
}



resource "aws_subnet""pvtsubnet1" {
    vpc_id =aws_vpc.myvpc.id
    availability_zone= "us-east-1a"
    cidr_block= "10.0.3.0/24"
    map_public_ip_on_launch= false
    tags={
        Name= "private-subnet-1"
    }
}
resource "aws_subnet""pvtsubnet2" {
    vpc_id =aws_vpc.myvpc.id
    availability_zone= "us-east-1a"
    cidr_block= "10.0.4.0/24"
    map_public_ip_on_launch= false
    tags={
        Name= "private-subnet-2"
    }
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-eip"
  }
}
resource "aws_nat_gateway" "mynat" {
    
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.mysubnet.id

  depends_on = [aws_internet_gateway.myigw]
    tags={
        Name= "my-nat"
    }
}

resource "aws_route_table" "myrt-pvt" {
    vpc_id= aws_vpc.myvpc.id
    route {
        cidr_block= "0.0.0.0/0"
        nat_gateway_id= aws_nat_gateway.mynat.id
        }
}

resource "aws_route_table_association" "myrta-pvt1" {
    subnet_id= aws_subnet.pvtsubnet1.id
    route_table_id= aws_route_table.myrt-pvt.id
}
resource "aws_route_table_association" "myrta-pvt2" {
    subnet_id= aws_subnet.pvtsubnet2.id
    route_table_id= aws_route_table.myrt-pvt.id
}