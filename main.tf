terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"  # Set the region to ap-south-1
}

# Create a new S3 bucket with a unique name
resource "aws_s3_bucket" "my_new_bucket" {
  bucket = "newswebsite-aws-s3-bucket-pranay-new-20231014"  # Ensure this name is unique
}

# Security group for EC2 instance
resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    from_port   = 22         # SSH port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from any IP (modify as needed)
  }

  ingress {
    from_port   = 80         # HTTP port
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from any IP
  }

  ingress {
    from_port   = 5601       # Kibana port
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow Kibana access from any IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"        # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance for the ELK stack
resource "aws_instance" "elk_instance" {
  ami                    = "ami-09b0a86a2c84101e1"  # Ubuntu 22.04 AMI
  instance_type          = "t2.micro"
  key_name               = "my-new-key-pair"    # Replace with your existing key pair name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]  # Use security group

  tags = {
    Name = "ELK-Instance"
  }

  # User data to install and configure ELK stack
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y openjdk-11-jdk
              echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" >> /etc/apt/sources.list.d/elastic-7.x.list
              wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
              apt-get update
              apt-get install -y elasticsearch logstash kibana
              systemctl enable elasticsearch
              systemctl enable logstash
              systemctl enable kibana
              systemctl start elasticsearch
              systemctl start logstash
              systemctl start kibana
              EOF
}

# Output the instance's public IP
output "instance_ip" {
  value = aws_instance.elk_instance.public_ip
}
