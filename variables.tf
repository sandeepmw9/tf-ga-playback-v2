variable "aws_region" {
  default = "ap-south-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "lab4_vpc"
}


variable "allowed_ports" {
  default = [
    {
      port = "22"
      name = "ssh"
    },
    {
      port = "80"
      name = "http"
    },

    {
      port = "443"
      name = "https"
    }
  ]
}

variable "instance_type" {
  default = "t3.micro"

  validation {
    condition     = contains(["t2.micro", "t2.small", "t3.micro"], var.instance_type)
    error_message = "Invalid instance type. Allowed values are t2.micro, t2.small, t3.micro."
  }
}

variable "instance_name" {
  default = "lab4-instance"
}