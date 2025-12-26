terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = var.ssh_public_key
}

resource "aws_instance" "server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id

  user_data = var.user_data != "" ? var.user_data : var.enable_web_server ? local.default_web_server_user_data : ""

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size = var.volume_size
    encrypted   = true
  }
  tags = {
    Name = var.instance_name
  }
}

resource "aws_eip" "eip" {
  count = var.enable_eip ? 1 : 0
}

resource "aws_eip_association" "eip_assoc" {
  count = var.enable_eip ? 1 : 0

  instance_id   = aws_instance.server.id
  allocation_id = aws_eip.eip[0].id
}

resource "aws_ec2_instance_state" "state" {
  instance_id = aws_instance.server.id
  state       = var.instance_state
}

locals {
  default_web_server_user_data = <<-EOF
    #!/bin/bash
    # Update system
    dnf update -y

    # Install NGINX
    dnf install nginx -y
  
    # Start and enable NGINX
    systemctl start nginx
    systemctl enable nginx
    
    # Create HTML page with user's name
    cat > /usr/share/nginx/html/index.html <<'HTML_EOF'
    <!DOCTYPE html>
    <html>
    <head>
        <title>${var.user_full_name}'s Web Server</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }
            .container {
                text-align: center;
                padding: 50px;
                background-color: rgba(255, 255, 255, 0.95);
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                max-width: 600px;
            }
            .name {
                color: #667eea;
                font-size: 3em;
                font-weight: bold;
                margin: 20px 0;
                padding: 10px;
                background: #f8f9fa;
                border-radius: 8px;
                border-left: 5px solid #667eea;
            }
            .footer {
                margin-top: 30px;
                color: #888;
                font-size: 0.9em;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="name">${var.user_full_name}</div>
            <div class="footer">
                <p>Served by NGINX on EC2</p>
            </div>
        </div>
    </body>
    </html>
    HTML_EOF
    
    # Set proper permissions
    chown -R nginx:nginx /usr/share/nginx/html/
    chmod -R 755 /usr/share/nginx/html/
    
    # Restart NGINX to apply changes
    systemctl restart nginx
  EOF
}