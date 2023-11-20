variable "AWS_REGION" {
  default = "ap-southeast-1"
}

#[!]Region별 ami id 다름
variable "AMIS" {
  type = map(string)
  default = {
    ap-southeast-1 = "ami-0ebcd68de1afe59cd"
  }
}

variable "test" {
  type        = string
  description = "cloud에서 설정해씁니다."
}

variable "root_password" {
  type        = string
  description = "cloud에서 설정해씁니다."
}

# VPC Subnet - 새 Variable type 정의
variable "SUBNET_AZ_LIST" {
  type = list(object({
    availability_zone = string
    cidr_block        = string
    map_public_ip_on_launch = bool
  }))

  default = [
    {
      availability_zone = "a"
      cidr_block        = "10.0.1.0/24"
      map_public_ip_on_launch = true
    },
    {
      availability_zone = "a"
      cidr_block        = "10.0.2.0/24"
      map_public_ip_on_launch = false 
    }
  ]
}
