#!/bin/bash

# Update packages and install dependencies
sudo apt update -y
sudo apt install -y openjdk-17-jdk wget unzip
sudo apt upgrade

# Download and install SonarQube
SONARQUBE_VERSION=9.9.5.90363
SONARQUBE_ZIP="sonarqube-${SONARQUBE_VERSION}.zip"
SONARQUBE_URL="https://binaries.sonarsource.com/Distribution/sonarqube/${SONARQUBE_ZIP}"

wget ${SONARQUBE_URL}
unzip ${SONARQUBE_ZIP}
sudo mv "sonarqube-${SONARQUBE_VERSION}" /opt/sonarqube

# Create a user and group for SonarQube
sudo groupadd sonar
sudo useradd -d /opt/sonarqube -g sonar sonar

# Change ownership of the SonarQube directory
sudo chown -R sonar:sonar /opt/sonarqube

# Create a systemd service file for SonarQube
cat <<EOF | sudo tee /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start SonarQube
sudo systemctl daemon-reload
sudo systemctl start sonarqube
sudo systemctl enable sonarqube

# Check SonarQube status
sudo systemctl status sonarqube
