provider "aws" {
}
resource "aws_instance" "ubuntu"{
ami=var.ami
instance_type=var.inst_type
key_name=aws_key_pair.deployer.key_name
}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqxpz5ibQ2o1M+Ev/9WojWlJoSaae4KaF/udQaIKk9a LENOVO@DESKTOP-CHKEU50"

}
