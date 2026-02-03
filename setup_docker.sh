#!/bin/bash

# We don't want to use Docker Desktop due to its licensing and resource usage.
# Instead, we will set up a Docker environment using Colima, optimized for Apple Silicon Macs.
# This script installs necessary tools, configures Colima, and sets up Docker context.

# we like colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}===> start setup of docker environment (colima edition) <===${NC}\n"

# 1. Homebrew Check
if ! command -v brew &> /dev/null; then
    echo "Brew not found. Please install Homebrew first: https://brew.sh/"
    exit 1
fi

# 2. tools installation
echo -e "${GREEN}1. Installing tools via Brew...${NC}"
brew install colima docker docker-compose docker-buildx lazydocker

# 2a. docker cli plugins setup
mkdir -p ~/.docker/cli-plugins
ln -sfn $(brew --prefix)/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
ln -sfn $(brew --prefix)/opt/docker-buildx/bin/docker-buildx ~/.docker/cli-plugins/docker-buildx

# 3. colima
echo -e "${GREEN}2. Starting Colima with Apple Silicon optimizations...${NC}"
colima stop # If it's already running, to apply settings
colima start \
    --cpu 4 \
    --memory 8 \
    --disk 100 \
    --mount-type=virtiofs \
    --vm-type=vz \
    --vz-rosetta

# 4. Set Docker Context
echo -e "${GREEN}3. Configuring Docker Context...${NC}"
docker context use colima

# 5. Setup check
echo -e "${BLUE}===> Setup completed! <===${NC}"
echo -e "Docker Version: $(docker --version)"
echo -e "Colima Status:  $(colima status)"
echo -e "\n${BLUE}Tip:${NC} Use '${GREEN}lazydocker${NC}' for an overview of your containers."
