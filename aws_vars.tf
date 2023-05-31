// Set vpc's az
variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

// Set anywhere cidr
variable "cidr_all" {
  type    = string
  default = "0.0.0.0/0"
}

// Set rds username
variable "rds_username" {
  type = string
}

// Set rds password
variable "rds_password" {
  type = string
}

// Set encrypt key
variable "key" {
  type    = string
  default = "jason-bastion"
}

// Set instance ami
variable "ami" {
  type    = string
  default = "ami-005f9685cb30f234b"
}

// Set instance type
variable "type" {
  type    = string
  default = "t2.micro"
}

// route 53 zone
variable "zone" {
  type    = string
  default = "internship.msppoc.com"
}