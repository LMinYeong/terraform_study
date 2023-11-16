# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "example" {
    ami = lookup(var.AMIS, var.AWS_REGION, "")
    #ami = data.aws_ami.amzn2-linux-ami.image_id

    instance_type = "t2.micro"
    tags =  {
        Name = "LMY"
        Service = var.test
    }

    security_groups = [ aws_security_group.aws_security_group.from_singapore.id ]

}