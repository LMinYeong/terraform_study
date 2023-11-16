data "aws_ami" "amzn2-linux-ami" {
  most_recent = true
  owners      = ["amazon"]

  #[!]Region별 ami id 다름 → name으로 찾아서 사용?
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
