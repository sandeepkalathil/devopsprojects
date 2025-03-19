#!/bin/bash
              # Install Java
              apt-get update

               # Install required packages
              apt-get update
              apt-get install -y gnupg curl
              sudo apt install openjdk-17-jdk -y


              # Add the correct Jenkins repository key
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
                /usr/share/keyrings/jenkins-keyring.asc > /dev/null

              # Add Jenkins repository
              echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
                /etc/apt/sources.list.d/jenkins.list > /dev/null

              # Update package lists again
              apt-get update

              # Install Java and Jenkins
              apt-get install -y openjdk-17-jdk jenkins

              # Enable and start Jenkins service
              systemctl enable jenkins
              systemctl start jenkins

              # Install AWS CLI
              apt-get install -y unzip
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install


              # Install Docker
              apt-get install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
              add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
              apt-get update
              apt-get install -y docker-ce docker-ce-cli containerd.io
              usermod -aG docker ubuntu
              usermod -aG docker jenkins

              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-composevv