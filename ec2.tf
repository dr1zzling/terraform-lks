resource "aws_instance" "lks_ec2" {
  ami                    = "ami-08982f1c5bf93d976" 
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.lks_public_subnet_1a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

   user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello from Terraform EC2" > /var/www/html/index.html
              EOF

  tags = {
    Name = "lks-ec2"
  }
}
