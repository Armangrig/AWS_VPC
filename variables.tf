#  variable "instance_name" {
#  description = "Value of the Name tag for the EC2 instance"
#  type        = string
#  default     = "gugushik"
#}


variable "task_name" {
  type    = string
  default = "s3_to_tfcloud"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
