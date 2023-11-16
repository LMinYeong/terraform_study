data "aws_ip_ranges" "singapore_ec2" {
    regions = ["ap-southeast-1"]
    services = ["ec2"]
}

resource "aws_security_group" "from_singapore" {
    name = "from_singapore"

    ingress {
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    
    tags = {
        Name = "from_singapore"
        CreateDate = data.aws_ip_ranges.singapore_ec2.create_date
        SyncToken = data.aws_ip_ranges.singapore_ec2.sync_token
    }
}