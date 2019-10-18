resource "aws_security_group" "allow_external_ssh" {
  name        = "allow_external_ssh_hocr"
  description = "Allow SSH traffic from public IP addresses"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "public_egress" {
  name        = "public_egress_hocr"
  description = "Allow traffic to all IP addresses"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
