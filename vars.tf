variable "vm_user" {
  type    = string
  default = "azureuser"
}

variable "vm_pass" {
  type    = string
  default = "Password123!"
}

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
  type    = string
  default = ""
}

// Set rds password
variable "rds_password" {
  type    = string
  default = ""
}

// Set resource tag
variable "project" {
  type    = string
  default = "tfdeploy"
}

// Set resource tag
variable "state" {
  type    = bool
  default = true
}

// Set resource tag
variable "prefix" {
  type    = string
  default = "task-2"
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


variable "zone" {
  type    = string
  default = "internship.msppoc.com"
}