provider "aws" {
  region = "us-east-1"
}


resource "aws_iam_role" "ec2-admin-role" {
  name = "ec2-admin-role"

  assume_role_policy="{\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n      {\n        \"Action\": \"sts:AssumeRole\",\n        \"Principal\": {\n          \"Service\": \"ec2.amazonaws.com\"\n        },\n        \"Effect\": \"Allow\",\n        \"Sid\": \"\"\n      }\n    ]\n  }\n"
}

resource "aws_iam_policy" "admin-accss-policy" {
  name = "admin-accss-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": "*",
          "Resource": "*"
      }
  ]
}
  EOF
}

resource "aws_iam_policy" "s3-access-policy" {
  name = "s3-access-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": "s3:*",
          "Resource": "*"
      }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2-role-s3-access-policy-attachment" {
  policy_arn = "${aws_iam_policy.s3-access-policy.arn}"
  role = "${aws_iam_role.ec2-admin-role.id}"
}

resource "aws_iam_role_policy_attachment" "ec2-role-admin-access-policy-attachment" {
  policy_arn = "${aws_iam_policy.admin-accss-policy.arn}"
  role = "${aws_iam_role.ec2-admin-role.id}"
}


resource "aws_iam_group" "admin-group" {
  name = "admin-group"
}

resource "aws_iam_user" "user_rohit" {
  name = "rohit"
}

resource "aws_iam_group_membership" "admin-group-memebership" {
  group = "${aws_iam_group.admin-group.id}"
  name = "admin-group-memebership"
  users = ["${aws_iam_user.user_rohit.id}"]
}

resource "aws_iam_group_policy_attachment" "admin-group-policy-attachemnt" {
  group = "${aws_iam_group.admin-group.id}"
  policy_arn = "${aws_iam_policy.admin-accss-policy.arn}"
}
