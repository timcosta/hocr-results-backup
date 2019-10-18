data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "game_scraper" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "m5.large"
  key_name                    = aws_key_pair.tim_mbp_2015.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.public_egress.id,
    aws_security_group.allow_external_ssh.id
  ]
  iam_instance_profile = aws_iam_instance_profile.ec2_hocr_scraper.id
}
