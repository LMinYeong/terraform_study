# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "example" {
    ami = lookup(var.AMIS, var.AWS_REGION, "")
    #ami = data.aws_ami.amzn2-linux-ami.image_id

    instance_type = "t2.micro"
    tags =  {
        Name = "LMY"
        Service = var.test
    }

    provisioner "local-exec" {
        command = "echo ${self.private_ip} >> private_ips.txt"
    }

    provisioner "file" {
      source = "private_ips.txt"
      destination = "/home/ec2-user/private_ips.txt"
    }

}