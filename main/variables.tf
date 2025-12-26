variable "aws_region" {
  description = "AWS region for the dev environment. Defaults to Ohio(ap-south-1)"
  type        = string
  default     = "ap-south-1"
}

variable "provider_environment" {
  description = "The environment where the resoures would be created"
  type        = string
  default     = "test"
}

variable "ssh_public_key_ct_server" {
  description = "Public SSH key for ct server"
  type        = string
  sensitive   = true

}


