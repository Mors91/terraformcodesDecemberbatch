resource "aws_instance" "windowsServer" {
  ami                    = "ami-0aad84f764a2bd39a"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = aws_subnet.main-public.id
  vpc_security_group_ids = [aws_security_group.allow_rdp.id]

  tags = merge(local.common_tags, { Name = "windowsServer" , Company = "EliteSolutionsIT"})
}

///key
resource "aws_key_pair" "deployer" {
  key_name   = "windowsServerKey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCd6i89t5qJrsRvwFs/Wt7aTUFSw0h1zGzqmP2bHMZEr7Z5zOT7zbQf5KxzC76YiuJDR8C5wDHohH4XEF40Ry2xoV+WsGsWI0jRfH/7Z9bePX3+Ck7aF23LGoAtSXPtf8Wkn5R7XJIJpI3qTMIF9kmRX11/tE3o3BDslwtubS5xGcyMrMb3zjKNAuc5cE6h0QSrLXzahRvL2qEwryW0Dg2wr2zkIYyhI1cbUVZiHTsckpNNcic/PmgTaS4in7zMwy2dhHcQIwkOv802ylNfOpppftVz4OnjBlMB7L3EeRJYbRvvx1tRSir43uxpyIoM5JmZygKw44gf+x2/v0PGb6psoKLC3oUCKt0Nm4mf4CrqPFnI+x9AV1M7rdFiCEQRw8yOXH5kvRup0XQnaK96si+I5IlaALKtfOQvIhYziPpY8+QSMindn1roijLq2NwWnKBcSXoqmjq2UKfQ+rbu1UbBZ0sSGfiLWXmBeOIUzNDSFPYGZMbIUyjiZZ/pbnJ9bik= lbena@LAPTOP-QB0DU4OG"
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