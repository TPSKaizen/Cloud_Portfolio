#!/usr/bin/env bash

# Syntax Check
# set -n

## ENV
# NB : Values on the left are bash env vars. 
#      Values on the right are coming from the templatefile function

AGENT_HOSTNAME=${AGENT_HOSTNAME}
AZDO_ORG_URL=${AZDO_ORG_URL}
AZDO_PAT=${AZDO_PAT}
AZDO_POOL=${AZDO_POOL}

## Pre checks

# Select a default agent version if one is not specified
if [ -z "$AZP_AGENT_VERSION" ]; then
  AZP_AGENT_VERSION=3.248.0
fi

# Verify Azure Pipelines token is set
if [ -z "$AZDO_PAT" ]; then
  echo 1>&2 "error: missing AZP_TOKEN environment variable"
  exit 1
fi

# Verify Azure DevOps ORG URL is set
if [ -z "$AZDO_ORG_URL" ]; then
  echo 1>&2 "error: missing AZP_URL environment variable"
  exit 1
fi

# If a working directory was specified, create that directory
if [ -n "$AZP_WORK" ]; then
  mkdir -p "$AZP_WORK"
fi

# Create the Downloads directory under the user's home directory
if [ -n "$HOME/Downloads" ]; then
  mkdir -p "$HOME/Downloads"
fi

# Pull agent set up file as adminuser
su - adminuser -c "
mkdir myagent && cd myagent
wget https://vstsagentpackage.azureedge.net/agent/3.248.0/vsts-agent-linux-x64-3.248.0.tar.gz
tar zxvf vsts-agent-linux-x64-3.248.0.tar.gz
"

# Install agent file as adminuser
su - adminuser -c "
cd /home/adminuser/myagent
./config.sh --unattended \
  --agent "${AGENT_HOSTNAME}" \
  --url "$AZDO_ORG_URL" \
  --auth PAT \
  --token "$AZDO_PAT" \
  --pool "${AZDO_POOL}" \
  --work "_work" \
  --replace \
  --acceptTeeEula & wait $!
"

cd /home/adminuser/myagent

./svc.sh install adminuser

./svc.sh start


# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Java 17
echo "Installing Java 17..."
sudo apt-get install -y openjdk-17-jdk
java -version

# Install Maven

# Download the Maven 3.9.9 version
echo "Downloading Maven 3.9.9..."
wget "https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz"

# Extract the downloaded tar file
echo "Extracting Maven 3.9.9..."
tar -xvzf apache-maven-3.9.9-bin.tar.gz

# Move Maven to /opt directory (or any preferred location)
echo "Moving Maven 3.9.9 to /opt"
sudo mv apache-maven-3.9.9 /opt/maven

# Set environment variables
echo "Setting up environment variables"
echo "export MAVEN_HOME=/opt/maven" >> /etc/profile.d/maven.sh
echo "export PATH=\$PATH:\$MAVEN_HOME/bin" >> /etc/profile.d/maven.sh
echo "export M2_HOME=/opt/maven" >> /etc/profile.d/maven.sh
echo "export PATH=\$PATH:\$M2_HOME/bin" >> /etc/profile.d/maven.sh

# Make the script executable
sudo chmod +x /etc/profile.d/maven.sh

# Apply changes system wide
source /etc/profile.d/maven.sh

# Verify Maven installation
echo "Maven 3.9.9 installation complete."
mvn -version


# Install Docker
echo "Installing Docker..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
docker --version

# Install Trivy (security scanner)
echo "Installing Trivy..."
curl -sfL https://github.com/aquasecurity/trivy/releases/download/v0.29.0/trivy_0.29.0_Linux-64bit.deb -o trivy.deb
sudo dpkg -i trivy.deb
rm trivy.deb
trivy --version

# Install kubectl
echo "Installing kubectl..."
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y kubectl
kubectl version --client

# Install Helm
echo "Installing Helm..."
curl https://get.helm.sh/helm-v3.10.0-linux-amd64.tar.gz -L -o helm.tar.gz
tar -zxvf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
helm version