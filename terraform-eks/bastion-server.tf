### Bastion host Configuration

resource "aws_instance" "jump-server" {
  instance_type               = "t2.micro"
  ami                         = "ami-0ba259e664698cbfc"
  key_name                    = "tfuser"
  vpc_security_group_ids      = ["sg-0fb1052b659369aa8"]
  associate_public_ip_address = true
  subnet_id                   = "subnet-03e0a14f"
  user_data                   = file("initscript.sh")
  availability_zone           = "ap-south-1a"
  iam_instance_profile        = "ec2-admin-role"
  tags = {
    Name         = "Bastion-Server"
    Owner        = "thangadurai.murugan@example.com"
    Project      = "GameApp-development"
    CreationDate = "09/03/2024"
  }
}
