data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "local_file" "ec2_login_key" {
  filename = "ec2_login_key"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_instance" "ec2_instance" {
  depends_on                  = [aws_key_pair.ec2_login_key] #depends on block for handling failures due to resource dependency
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2_login_key.key_name
  security_groups             = [aws_security_group.lab4_sg.id]

  tags = {
    Name      = "${var.instance_name}-${random_string.suffix.id}-${terraform.workspace}"
    terraform = true
  }

  timeouts { #timeouts for handling failures while resource creation
    create = "10m"
    delete = "1h"
  }

  lifecycle { #using lifecycle block to control distruction of resources
    create_before_destroy = true


    precondition {
      condition     = data.local_file.ec2_login_key.filename != null
      error_message = "Key pair does not exist. Please create it before applying Terraform."
    }

    postcondition {
      condition     = self.public_ip != null
      error_message = "EC2 instance did not receive a public IP. Check subnet settings or modify the instance configuration."
    }

  }


  connection {
    user        = "ubuntu"
    private_key = data.local_file.ec2_login_key.content
    host        = self.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "echo hello from $(hostname)"
    ]
    #  on_failure = "continue"
    #  retries = 3
    #  retry_interval = 5
  }

}

resource "aws_key_pair" "ec2_login_key" {
  key_name   = "ec2_login_key"
  public_key = file("ec2_login_key.pub")
}

