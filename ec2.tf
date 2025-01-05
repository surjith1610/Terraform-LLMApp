resource "aws_security_group" "webapp_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "web application security group"
  }

  depends_on = [aws_vpc.vpc]
}

# Create EC2 Instance
resource "aws_instance" "web_app_instance" {
  ami                         = var.ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.webapp_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.ec2_instance_volume_size
    volume_type           = var.ec2_volumetype
    delete_on_termination = true
  }

  disable_api_termination = false

  user_data = <<-EOF
    #!/bin/bash
    LOG_DIR="/home/legacy/MentalHealthCounsellor/logs"
    LOG_FILE="$LOG_DIR/user-data-log.txt"
    WEBAPP_LOG="$LOG_DIR/webapp.log"

    # Ensure the logs directory exists
    if [ ! -d "$LOG_DIR" ]; then
      mkdir -p "$LOG_DIR" || echo "Error creating logs directory" >> "$LOG_FILE"
    fi

    if [ ! -f "$WEBAPP_LOG" ]; then
      touch "$WEBAPP_LOG" || echo "Error creating webapp.log file" >> "$LOG_FILE"
    fi

    LOG_FILE="/home/legacy/MentalHealthCounsellor/logs/user-data-log.txt"

    echo "Starting user data script..." >> "$LOG_FILE"

    echo "Setting environment variables..." >> "$LOG_FILE"
    {
    echo "GROQ_API_KEY='${var.groq_api_key}'" >> /etc/environment
    echo "OPEN_AI_API_KEY='${var.open_ai_api_key}'" >> /etc/environment
    echo "GROQ_API_KEY='${var.groq_api_key}'" >> /home/legacy/MentalHealthCounsellor/app/.env
    echo "OPEN_AI_API_KEY='${var.open_ai_api_key}'" >> /home/legacy/MentalHealthCounsellor/app/.env
    } || echo "Error setting environment variables" >> "$LOG_FILE"

    echo "Activating environment..." >> "$LOG_FILE"

    source /etc/environment || echo "Error sourcing environment variables" >> "$LOG_FILE"
    source /home/legacy/MentalHealthCounsellor/app/.env || echo "Error sourcing environment variables" >> "$LOG_FILE"


    echo "Checking if $WEBAPP_LOG is writable..." >> "$LOG_FILE"
    if [ -w "$WEBAPP_LOG" ]; then
      echo "$WEBAPP_LOG is writable." >> "$LOG_FILE"
    else
      echo "$WEBAPP_LOG is not writable. Making it writable." >> "$LOG_FILE"
      chmod +w "$WEBAPP_LOG" || echo "Error making $WEBAPP_LOG writable" >> "$LOG_FILE"
      fi

    echo "Reloading and restarting services..." >> "$LOG_FILE"
    # Reload and restart services after loading environment variables
    systemctl daemon-reload || echo "Error reloading systemd" >> "$LOG_FILE"
    systemctl enable MentalHealthCounsellor.service || echo "Error enabling webapp service" >> "$LOG_FILE"
    systemctl restart MentalHealthCounsellor.service || echo "Error restarting webapp service" >> "$LOG_FILE"

    echo "User data script completed." >> "$LOG_FILE"
EOF

  tags = {
    Name = "web_app_instance"
  }

  depends_on = [aws_internet_gateway.igw, aws_subnet.public_subnets, aws_security_group.webapp_sg]
}
