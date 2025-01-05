variable "vpc_cidr" {
  type        = string
  description = "value of cidr block"
}

variable "vpc_name" {
  type        = string
  description = "value of vpc name"

}

variable "internet_gateway_name" {
  type        = string
  description = "value of internet gateway name"

}

variable "aws_region" {
  type        = string
  description = "value of aws region"

}

variable "ami_id" {
  type        = string
  description = "value of ami id"
}


variable "groq_api_key" {
  description = "Groq API key"
  type        = string
  sensitive   = true
}

variable "open_ai_api_key" {
  description = "OpenAI API key"
  type        = string
  sensitive   = true
}


variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ec2_volumetype" {
  description = "EC2 volume type"
  type        = string
}

variable "ec2_instance_volume_size" {
  description = "EC2 instance volume size"
  type        = number

}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "ec2_launch_template_ssh_key" {
  description = "SSH key name for EC2 launch template"
  type        = string
}
