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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDA/6zlyF+IOvnM7bPajfg4Fi4FB9Ki7KXcmPjAdVb4mhCnHa9F5GVLftPJkFAH5yjBxVhC9YVaScupK04o1VHHnvUG4OyV5h1P1C1CBFY1xZcRW4aNA30eAQvJBnG4EGn8mPU9Jd8cCaDbU+AeAtYb9l8XjMHnZrwHoUBWMoYOjHb7LiMuxnEcVTYqMuzbCfoorDVSxglML8DNphJoHLSPpz7VZkoFVgox91jErhuxDncR4IZBHTMFbgJBCbd68aYyuR30ErabdPzwC14cUYnfPmYgl1Pahw9iLArNjSB8uaVtbylilC6w6Ris9pdN02kn9prz+SWiDAUxMPUN8HedKgGhr4JQMpzQsY6O2ogFv74fPpWba8UfA2I5XhB4JC1Cau1tZWxd77uHYEHiPINETGcD8BMeNOgVlYkFQYGzjeEWnuP0xTZpyalgliv9FnOkJJ6aEt1iTJy9IW8eUYDhif/Ts0NdVqh9qPjuDVGTXcOTubuWS4QD8NLIm03vOTM= lbena@LAPTOP-QB0DU4OG"
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