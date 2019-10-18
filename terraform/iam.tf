resource "aws_iam_role" "ec2_hocr_scraper" {
  name = "ec2_hocr_scraper"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    env = terraform.workspace
  }
}

resource "aws_iam_instance_profile" "ec2_hocr_scraper" {
  name = "ec2_hocr_scraper"
  role = aws_iam_role.ec2_hocr_scraper.name
}

resource "aws_iam_role_policy" "ec2_hocr_scraper" {
  name = "ec2_hocr_scraper"
  role = aws_iam_role.ec2_hocr_scraper.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.hocr_data.arn}"
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.hocr_data.arn}/*"
    }
  ]
}
EOF
}
