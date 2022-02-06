variable "region" {
  description = "this the aws region for all of our deployment"
  default     = "us-east-1"
}

variable "cidr_block" {
  description = "cidr block for creating public subnet"
  type        = string
  default     = "10.0.1.0/24"
}