resource "aws_instance" "ubuntuserver" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ubuntudeployer.key_name
  subnet_id              = aws_subnet.main-public.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  user_data_base64       = data.cloudinit_config.userdata.rendered


  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.path_private_key)
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx -y"
    ]
  }

  tags = merge(local.common_tags, { Name = "ubuntuserver", Company = "EliteSolutionsIT", "Dummy" = "dummytag" })
}

///key
resource "aws_key_pair" "ubuntudeployer" {
  key_name   = join("-", [local.network.Environment, "ubuntuserverKey"])
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDgLEV7ZLoOlbLrvb8MzsZwzoiHUh/LIJXF8QQmL9oR3nM2OjngbAG83OqSRzvsnehCc8RQER1ItL49OdjCpPs+lfY8UQt/6Gzdu5LwqyydgmPw44hizHiNTBSDy7yWP1+o4f4Z7thOeAsUcOedZuMW6mK7wE027b6+xcCaVZM9t0rhbpNfllYGOF6o44bgUbU5tXmoDbBBm8Ww4TtVnV0Bs7mPJgsiwC8f0pt5WV6ARhvf1vlPuCISXNq/oKLMnnfIR3SO6YzJYbQVHSxJRame1+ceCR3H97YdfRDFe3IJONKOxfSOXcCTfIB5dLOGSFlSSn0q0JgTdQaZs+4Bg1Do2ed8D4e9sfYj02xIbuWKywup52BZchWpNSb2Hwj8q0Ow9nr359WtNWR1WwcwfO3aHuZx8jKqpdH2wV/E/Xob5psmipbUvJw1AtQcMF+Z0l4qN5FDijpxt+4OQuPUfKlN1wTGVBscaHzT977kassHs9/GowoZCaE2NAcdeyb2C0= lbena@LAPTOP-QB0DU4OG"
}

///Security Group
resource "aws_security_group" "allow_ssh" {
  name        = join("-", [local.network.Environment, "allow_ssh"])
  description = "Allow RDP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["70.114.65.185/32"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["70.114.65.185/32"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["70.114.65.185/32"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 5432
    to_port     = 5432
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
    Name        = "ubuntu-sg"
    Environment = "dev"
    Managedwith = "terraform"
  }
}