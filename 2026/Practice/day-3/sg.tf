resource "aws_security_group" "mysg" {
    ingress{
        description="allow SSH"
        from_port=22
        to_port=22
        protocol= "tcp"  //type will be SSH but protocol will be mostly TCP for all the cases
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        description="allow HTTP"
        from_port=80
        to_port=80
        protocol= "tcp" //type will be HTTP but protocol will be mostly TCP for all the cases
        cidr_blocks = ["0.0.0.0/0"]
    }
        ingress{
        description="allow HTTPS"
        from_port=443
        to_port=443
        protocol= "tcp" //type will be HTTPS but protocol will be mostly TCP for all the cases
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        from_port=0
        to_port=0
        protocol= "-1" // allow all ports for outgoing traffic
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}