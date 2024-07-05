#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ensure Homebrew is installed and updated
install_homebrew() {
    if ! command_exists brew; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Homebrew is already installed"
    fi
    brew update
}

# Function to install a tool if not already installed
install_tool() {
    local tool_name=$1
    local install_command=$2
    if ! command_exists "$tool_name"; then
        echo "Installing $tool_name..."
        eval "$install_command"
        if [ $? -ne 0 ]; then
            echo "Error installing $tool_name. Exiting."
            exit 1
        fi
    else
        echo "$tool_name is already installed"
    fi
}

# Function to verify installations and report errors
verify_installation() {
    local tool_name=$1
    local check_command=$2
    echo "Verifying $tool_name installation..."
    if ! eval "$check_command"; then
        echo "Error: $tool_name verification failed."
        exit 1
    fi
}

# Install and configure necessary tools
install_homebrew
install_tool "java-runtime" "brew install --cask temurin"
install_tool "git" "brew install git"
install_tool "docker" "brew install --cask docker"
install_tool "minikube" "brew install minikube"
install_tool "oc" "curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/macosx/oc.tar.gz && tar -xvzf oc.tar.gz && sudo mv oc /usr/local/bin && rm oc.tar.gz"
install_tool "java" "brew install openjdk"
install_tool "python3" "brew install python"
install_tool "mvn" "brew install maven"
install_tool "ansible" "brew install ansible"
install_tool "terraform" "brew install terraform"
install_tool "node" "brew install node"
install_tool "kubectl" "brew install kubectl"

# Post-installation configurations for Java, Python, and Maven
echo 'export JAVA_HOME=$(brew --prefix openjdk)/libexec/openjdk.jdk/Contents/Home' >> ~/.zprofile
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.zprofile
echo 'export PATH="/usr/local/opt/python/libexec/bin:$PATH"' >> ~/.zprofile
echo 'export MAVEN_HOME=$(brew --prefix maven)' >> ~/.zprofile

echo 'export PATH=$MAVEN_HOME/bin:$PATH' >> ~/.zprofile
echo 'export TMPDIR=/usr/local/var/tmp' >> ~/.zprofile
# Additional configurations or setups:
# You can add more commands here as needed, such as setting up Docker configurations,
# configuring Kubernetes (kubectl), setting environment variables, etc.

export MINIKUBE_HOME=$HOME/.minikube

# Source the profile to ensure environment variables are available
source ~/.zprofile

# Verify installations
verify_installation "git" "git --version"
verify_installation "docker" "docker --version"
verify_installation "minikube" "minikube version"
verify_installation "oc" "oc version"
verify_installation "java" "java -version"
verify_installation "python3" "python3 --version"
verify_installation "mvn" "mvn --version"
verify_installation "ansible" "ansible --version"
verify_installation "terraform" "terraform --version"
verify_installation "node" "node --version"
verify_installation "kubectl" "kubectl version --client"

echo "All tools installed and verified successfully."