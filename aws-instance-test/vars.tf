variable "AWS_REGION" {
    default = "ap-southeast-1"
}

variable "AMIS" {
    type = map(string)
    default = {
        ap-southeast-1 = "ami-09964535fc01efa5f"
    }
}