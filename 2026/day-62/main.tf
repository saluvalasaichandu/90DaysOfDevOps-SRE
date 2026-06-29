resource "aws_vpc" "my_vpc" {
    cidr_block ="10.0.0.0/16"
    tags={
        Name ="my-vpc-1"
    }
}

resource "aws_subnet" "mysubnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "myigw"{
    vpc_id= aws_vpc.my_vpc.id
}
resource "aws_route_table" "myrt" {
    vpc_id = aws_vpc.my_vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myigw.id
    }
}

resource "aws_route_table_association" "myrta" {
    subnet_id = aws_subnet.mysubnet.id
    route_table_id = aws_route_table.myrt.id
}

resource "aws_security_group" "my_sg"{
    name ="aws-terraform-SG"
    vpc_id = aws_vpc.my_vpc.id

    ingress{
        description = "allow SSH"
        from_port =22
        to_port= 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
        ingress{
        description = "HTTP"
        from_port =80
        to_port= 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
        egress{
            description = "allow all outbound traffic"
            from_port= 0
            to_port= 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
        tags={
            Name= "terraform-sg"
        }

}

resource "aws_instance" "my_ec2" {
    ami = "ami-0b6d9d3d33ba97d99"
    instance_type= "t2.micro"
    subnet_id = aws_subnet.mysubnet.id
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    tags = {
    Name = "TerraWeek-ec2-instance"
  }
    lifecycle {
        create_before_destroy = true
  }
}

resource "aws_s3_bucket" "my_bucket"{
    bucket = "terraform-62-bucket-saichandu-2026"
    depends_on = [ aws_instance.my_ec2 ]
}