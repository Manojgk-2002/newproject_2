provider "aws" {
}
resource "aws_instance" "ubuntu"{
	ami=var.ami
	instance_type=var.inst_type
	key_name=aws_key_pair.deployer.key_name
}
resource "aws_eip" "elasti_ip"{
domain   = "vpc"
instance= aws_instance.ubuntu.id
}
