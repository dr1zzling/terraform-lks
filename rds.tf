# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "lks-rds-subnet-group"
  subnet_ids = [
    aws_subnet.lks_public_subnet_1a.id,  
    aws_subnet.lks_public_subnet_1b.id   
  ]

  tags = {
    Name = "lks-rds-subnet-group"
  }
}

# RDS 
resource "aws_db_instance" "rds_instance" {
  identifier             = "lks-db-erzy"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id] # pakai SG EC2
  publicly_accessible    = true
  username               = "admin"
  password               = "Admin123"
  skip_final_snapshot    = true
  multi_az               = false

  tags = {
    Name = "lks-rds"
  }
}

# Output endpoint RDS
output "rds_endpoint" {
  description = "Endpoint RDS MySQL untuk CloudShell"
  value       = aws_db_instance.rds_instance.endpoint
}

# Output RDS ID
output "rds_instance_id" {
  description = "RDS Instance ID"
  value       = aws_db_instance.rds_instance.id
}
