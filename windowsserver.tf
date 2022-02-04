resource "aws_instance" "windowsServer" {
  ami                    = "ami-0aad84f764a2bd39a"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = aws_subnet.main-public.id
  vpc_security_group_ids = [aws_security_group.allow_rdp.id]

  tags = {
    Name        = "windowsServer"
    Environment = "dev"
    Managedwith = "terraform"
  }
}

///key
resource "aws_key_pair" "deployer" {
  key_name   = "windowsServerKey"
  public_key = file(var.key_path)
}

///Security Group
resource "aws_security_group" "allow_rdp" {
  name        = "allow_rdp"
  description = "Allow RDP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["70.114.65.185/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "windows-sg"
    Environment = "dev"
    Managedwith = "terraform"
  }
}