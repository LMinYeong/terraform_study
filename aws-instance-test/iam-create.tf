# IAM Role - Trust relationship 작성
data "aws_iam_policy_document" "lmy-tf-trust-relationship-doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# (1) IAM Role 생성
resource "aws_iam_role" "lmy-tf-role" {
  name               = "lmy-tf-role"
  assume_role_policy = data.aws_iam_policy_document.lmy-tf-trust-relationship-doc.json
}

# (2) IAM Instance profile  생성
resource "aws_iam_instance_profile" "lmy-tf-role-profile" {
  name = "lmy-tf-role-profile"
  role = aws_iam_role.lmy-tf-role.name
}

# (3) IAM Policy 생성 - IAM Role에 IAM Policy 할당하는 방법
data "aws_iam_policy_document" "lmy-tf-ec2-policy-doc" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "lmy-tf-policy" {
  name        = "lmy-tf-policy"
  description = "A terraform test policy"
  policy      = data.aws_iam_policy_document.lmy-tf-ec2-policy-doc.json
}

resource "aws_iam_role_policy_attachment" "lmy-tf-policy-attach" {
  role       = aws_iam_role.lmy-tf-role.name
  policy_arn = aws_iam_policy.lmy-tf-policy.arn
}

# (4) Role Policy(s3) 생성 - IAM Role을 지정하는 방법
resource "aws_iam_role_policy" "lmy-tf-s3-policy" {
  name = "lmy-tf-s3-policy"
  role = aws_iam_role.lmy-tf-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::lmy-tf-bucket",
              "arn:aws:s3:::lmy-tf-bucket/*"
            ]
        }
    ]
}
EOF

}