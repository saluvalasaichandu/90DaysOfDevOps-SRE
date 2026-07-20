resource "aws_instance" "myec2" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"
  tags = {
    Name = "my-ec2-weServer"
  }
  key_name = "saichandu-key"
  root_block_device {
    volume_size = 8
  }
  availability_zone = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.mysg.id] //this SG will attach to EC2
  
  }