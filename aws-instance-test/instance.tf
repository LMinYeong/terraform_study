# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

# SSH Key


resource "aws_instance" "example" {
    #ami = lookup(var.AMIS, var.AWS_REGION, "")
    ami = data.aws_ami.amzn2-linux-ami.image_id

    instance_type = "t2.micro"
    tags =  {
        Name = "LMY"
        Service = var.test
    }

    # the VPC subnet
    subnet_id = aws_subnet.lmy-tf-public-1.id

    # the security group
    #security_groups = [ aws_security_group.from_singapore.name ]
    vpc_security_group_ids = [aws_security_group.lmy-tf-allow-ssh.id]

    # the Public SSH key

    # iam role
    iam_instance_profile = data.aws_iam_instance_profile.lmy-vault-join-profile.name
}

# IAM Role - Instace Profile
data "aws_iam_instance_profile" "lmy-vault-join-profile" {
  name = "LMY-Vault-Join"
}

# EBS Volume
resource "aws_ebs_volume" "lmy-tf-ebs-volume-1" {
  # ?
  availability_zone = "${var.AWS_REGION}a"
  size = 20
  type = "gp2"

  tags = {
    Name = "extra volume data"
  } 
}

resource "aws_volume_attachment" "lmy-tf-ebs-volume-1-attachment" {
  device_name = "/dev/xvdh"
  volume_id = aws_ebs_volume.lmy-tf-ebs-volume-1.id
  instance_id = aws_instance.example.id
  stop_instance_before_detaching = true
}


