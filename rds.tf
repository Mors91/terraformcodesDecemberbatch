resource "aws_db_subnet_group" "postgresqlsubnet" {
  name = join("-", [local.network.Environment, "postgresqlsubnet"])

  subnet_ids = [aws_subnet.main-public.id, aws_subnet.main-public-2.id]

  tags = merge(local.common_tags, { Name = "postgresqlsubnet", Company = "EliteSolutionsIT" })
}

resource "aws_db_parameter_group" "postgresqlsubnet_param" {
  name   = join("-", [local.network.Environment, "postgresqlsubnet-param"])
  family = "postgres11"

  #   parameter {
  #       name = "character_set_client"
  #       value = "utf8mb4"
  #   }
}

resource "aws_db_instance" "postgresdb" {
  allocated_storage       = 10 #100 GB of storage, gives us more IOPS than a lower number
  engine                  = "postgres"
  engine_version          = "11.10"
  instance_class          = "db.t3.micro" #use micro if you want to use the free tier
  identifier              = "postgres"
  name                    = "postgresadmin"
  username                = "postgresadminuser" #username
  password                = var.password        #password
  db_subnet_group_name    = aws_db_subnet_group.postgresqlsubnet.name
  parameter_group_name    = aws_db_parameter_group.postgresqlsubnet_param.name
  multi_az                = false #set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]
  storage_type            = "gp2"
  backup_retention_period = 30                                       #how long you’re going to keep your backups
  availability_zone       = aws_subnet.main-public.availability_zone # prefered AZ
  skip_final_snapshot     = true
  publicly_accessible     = true #skip final snapshot when doing terraform destroy
  tags                    = merge(local.common_tags, { Name = "postgreSQLdb", Company = "EliteSolutionsIT" })
}