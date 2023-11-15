variable "AWS_REGION" {
    default = "ap-southeast-1"
}

#[!]Region별 ami id 다름
#variable "AMIS" {
#    type = map(string)
#    default = {
#        ap-southeast-1 = "ami-09964535fc01efa5f"
#    }
#}

variable "test" {
  type = string
  description = "cloud에서 설정해씁니다."
}

variable "root_password" {
  type = string
  description = "cloud에서 설정해씁니다."
}