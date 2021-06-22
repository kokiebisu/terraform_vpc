provider "aws" {
  profile = var.profile
  region  = var.region
}

variable "profile" {
  type        = string
  description = "profile"
  default     = "default"
}

variable "region" {
  type        = string
  description = "region"
  default     = "us-east-1"
}