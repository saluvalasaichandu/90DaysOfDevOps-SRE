resource "aws_instance" "my_ec2"{
    tags={
        Name= var.iname
        Region= "Dev"
    }
    ami = var.ami_id
    instance_type= var.itype
    key_name= var.key
    availability_zone= var.az
    root_block_device{
        volume_size= var.volume_size
    }
    }