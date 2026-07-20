resource "aws_instance" "myec2" {
    for_each = var.ssc 
    ami = each.value.ami_id
    instance_type = each.value.itype
    tags ={
        Name = each.value.iname
    }
}