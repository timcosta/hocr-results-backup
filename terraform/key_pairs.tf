resource "aws_key_pair" "tim_mbp_2015" {
  key_name   = "tim_mbp_2015_hocr"
  public_key = file("~/.ssh/id_rsa.pub")
}
