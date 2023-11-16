# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
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

}