/*
// Create bastion instance
resource "aws_instance" "bastion" {
  ami = var.ami
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public[0].id
  security_groups = [ aws_security_group.bastion.id ]
  key_name = var.key
  tags = {
    "Name" = "example-bastion"
  }
}

*/

// Create web instance
resource "aws_instance" "web" {
  ami                    = "ami-0aa2b7722dc1b5612"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.key
  iam_instance_profile   = "ec2-acces-s3"
  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    apt-get install -y ansible
    apt-get install -y mysql-server
    apt-get install -y python3.8
    apt-get install -y python3-pip
    echo "This is AWS!" > /var/www/html/index.html
    EOF
  tags = {
    Name = "final-web"
  }

}
