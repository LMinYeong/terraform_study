# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "example" {
    #ami = lookup(var.AMIS, var.AWS_REGION, "")
    ami = data.aws_ami.amzn2-linux-ami.image_id

    instance_type = "t2.micro"
    tags =  {
        Name = "LMY"
        Service = var.test
    }

    connection {
        type     = "ssh"
        user     = "root"
        password = var.root_password
        host     = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            "echo ${self.private_ip} >> private_ips.txt"
        ]
    }
    
}