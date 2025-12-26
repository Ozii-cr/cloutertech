variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
  sensitive   = true
}

variable "ami" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "instance_name" {
  description = "Name of the instance"
  type        = string
}

variable "volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 8
}

variable "instance_state" {
  description = "Desired state of the instance (running or stopped)"
  type        = string
  default     = "running"

  validation {
    condition     = contains(["running", "stopped"], var.instance_state)
    error_message = "Allowed values for instance_state are 'running' or 'stopped'."
  }
}

variable "enable_eip" {
  description = "Boolean flag to enable Elastic IP assignment"
  type        = bool
  default     = false
}

variable "enable_web_server" {
  description = "Whether to provision a web server on the instance"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "Custom user_data script. If empty uses default web server script"
  type        = string
  default     = ""
}

variable "user_full_name" {
  description = "Full name to display on the web page"
  type        = string
  default     = "Richard Coker"
}
