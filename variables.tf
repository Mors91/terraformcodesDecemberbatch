variable "region" {
  description = "this the aws region for all of our deployment"
  default     = "us-east-1"
}

variable "cidr_block" {
  description = "cidr block for creating public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Instamce size of ubuntu server"
  type        = string
  default     = "t2.micro"
}

variable "path_private_key" {
  description = "Private key file path to remote connectivity for ubuntu server"
  type        = string
  default     = "ubuntuserverkey"
}

variable "password" {
  description = "database password"
  type        = string
  default     = "Gfsa%njXV6d"
}

variable "cidr_blockB" {
  description = "Subnet cidr block for second public subnet"
  type        = string
  default     = "10.0.3.0/24"
}