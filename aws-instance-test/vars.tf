variable "AWS_REGION" {
    default = "ap-southeast-1"
}

variable "AMIS" {
    type = map(string)
    default = {
        ap-southeast-1 = "ami-072bfa63601a77ee4"
    }
}