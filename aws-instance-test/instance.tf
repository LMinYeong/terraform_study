# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

# SSH Key - private key
resource "tls_private_key" "lmy-tf-private-key" {
  algorithm = "RSA"
  rsa_bits = 4096
}
# SSH Key - public key
resource "aws_key_pair" "lmy-tf-pem-key" {
  key_name = "lmy-tf-key"
  public_key = tls_private_key.lmy-tf-private-key.public_key_openssh
}

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
    # Default VPC
    #security_groups = [ aws_security_group.from_singapore.name ]
    # Custom VPC
    vpc_security_group_ids = [aws_security_group.lmy-tf-allow-ssh.id]

    # the Public SSH key
    key_name = aws_key_pair.lmy-tf-pem-key.key_name
    
    # remote-exec : aws_instance.example(LMY 인스턴스)에서 수행
    provisioner "remote-exec" {
        connection {
          type = "ssh"
          user = "ec2-user"
          private_key = tls_private_key.lmy-tf-private-key.private_key_openssh
          host = self.public_ip
        }

        inline = [ 
            "mkdir $HOME/test"
         ]
    }

    # iam role
    # iam_instance_profile = "LMY-Vault-Join" => X 사용 불가.
    # iam_instance_profile = aws_iam_instance_profile.lmy-tf-role-profile.name
    iam_instance_profile = data.aws_iam_instance_profile.lmy-vault-join-profile.name
}

### pem_key 출력 확인
output "pem_key" {
  value = tls_private_key.lmy-tf-private-key.private_key_openssh
  sensitive = true
}

# 기존 생성되어 있는 IAM Role - Instace Profile 사용
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


