#data "aws_ip_ranges" "singapore_ec2" {
#  regions  = ["ap-southeast-1"]
#  services = ["ec2"]
#}

resource "aws_security_group" "lmy-tf-allow-ssh" {
  vpc_id = aws_vpc.lmy-terraform-test.id
  name        = "lmy-tf-allow-ssh"
  description = "security group that allows ssh and all egress traffic"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
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
    Name       = "lmy-tf-allow-ssh"
    #CreateDate = data.aws_ip_ranges.singapore_ec2.create_date
    #SyncToken  = data.aws_ip_ranges.singapore_ec2.sync_token
  }
}
