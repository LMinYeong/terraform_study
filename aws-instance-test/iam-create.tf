# (1) IAM Role 생성
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

resource "aws_iam_role" "lmy-tf-role" {
  name               = "test-role"
  assume_role_policy = data.aws_iam_policy_document.lmy-tf-trust-relationship-doc.json
}

# (2) IAM Instance profile  생성
resource "aws_iam_instance_profile" "lmy-tf-role-profile" {
  name = "lmy-tf-role-profile"
  role = aws_iam_role.lmy-tf-role.name
}

# (3) IAM Policy 생성 
data "aws_iam_policy_document" "lmy-tf-policy-doc" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lmy-tf-policy" {
  name        = "lmy-tf-policy"
  description = "A terraform test policy"
  policy      = data.aws_iam_policy_document.lmy-tf-policy-doc.json
}

# (4) IAM Role에 IAM Policy 할당
resource "aws_iam_role_policy_attachment" "lmy-tf-policy-attach" {
  role       = aws_iam_role.lmy-tf-role.name
  policy_arn = aws_iam_policy.lmy-tf-policy.arn
}