variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-west-2"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "zone_name" {
  default     = "alvaroga.name"
  description = "Pre-existing zone"
}

variable "subdomain_name" {
  default     = "reaktor"
  description = "Domain name for the app"
}

##
variable "min_size" {
  default     = 2
  description = "Minimum number of instances"
}

variable "max_size" {
  default     = 10
  description = "Maximum number of instances"
}

variable "target_value" {
  default = 75
  description = "Target average CPU for the cluster"
}
##
