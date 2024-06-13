terraform {
    required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.52.0"
    }
    }
}

provider "aws" {
    region = "eu-central-1"  # Replace as needed
}

resource "aws_security_group" "allow_ssh_http" {
    vpc_id = "vpc-3614fe5c"  # Replace with your VPC ID

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "sonarqube" {
    ami           = "ami-01e444924a2233b07"  # Ubuntu for Frankfurt region [replace as needed]
    instance_type = "t2.medium"
    security_groups = [aws_security_group.allow_ssh_http.name]

    user_data = file("setup-sonarqube.sh")

    tags = {
    Name = "SonarQube-Server"
    }
}
