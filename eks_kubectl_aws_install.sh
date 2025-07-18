#!/bin/bash

set -e

# Install eksctl
echo "Installing eksctl..."
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

# Install AWS CLI
echo "Installing AWS CLI..."
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip
aws --version

# Configure AWS CLI
echo "Configuring AWS CLI..."
aws configure set aws_access_key_id <insert ur access key here>
aws configure set aws_secret_access_key <insert ur secret key here>
aws configure set region us-east-1
aws configure set output json

# Create EKS Cluster
echo "Creating EKS cluster..."
eksctl create cluster \
  --name cluster123 \
  --region us-east-1 \
  --version 1.32 \
  --nodegroup-name ng1 \
  --node-type t2.medium \
  --nodes 2

echo "EKS cluster created successfully!"
