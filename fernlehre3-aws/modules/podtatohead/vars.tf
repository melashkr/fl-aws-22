variable "podtato_version" {
  type = string
}

variable "hats_version" {
  type = string
}

variable "left_arm_version" {
  type = string
}

variable "right_arm_version" {
  type = string
}

variable "right_leg_version" {
  type = string
}

variable "left_leg_version" {
  type = string
}

variable "podtato_name" {
    type = string
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "min_instances" {
  type = number
  default = 1
}

variable "max_instances" {
  type = number
  default = 1
}

variable "desired_instances" {
  type = number
  default = 1
}

variable "app_name" {
  type = string
}

variable "GITHUB_USER" {
  type    = string
  sensitive = true
}

variable "GITHUB_CLIENT_ID" {
  type    = string
  sensitive = true
}

variable "GITHUB_CLIENT_SECRET" {
  type    = string
  sensitive = true
}