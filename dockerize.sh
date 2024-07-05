#!/bin/bash

# Prompt for Docker Hub username and password
read -p "Enter your Docker Hub username: " DOCKER_USERNAME
read -sp "Enter your Docker Hub password: " DOCKER_PASSWORD
echo

# Variables
IMAGE_NAME="demo-app"
TAG="latest"

# Build the Spring Boot application
echo "Building the Spring Boot application..."
./mvnw clean package

if [ $? -ne 0 ]; then
  echo "Maven build failed. Exiting."
  exit 1
fi

# Build the Docker image
echo "Building the Docker image..."
docker build -t $IMAGE_NAME .

if [ $? -ne 0 ]; then
  echo "Docker build failed. Exiting."
  exit 1
fi

# Log in to Docker Hub
echo "Logging in to Docker Hub..."
echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin

if [ $? -ne 0 ]; then
  echo "Docker login failed. Exiting."
  exit 1
fi

# Tag the Docker image
echo "Tagging the Docker image..."
docker tag $IMAGE_NAME $DOCKER_USERNAME/$IMAGE_NAME:$TAG

if [ $? -ne 0 ]; then
  echo "Docker tag failed. Exiting."
  exit 1
fi

# Push the Docker image to Docker Hub
echo "Pushing the Docker image to Docker Hub..."
docker push $DOCKER_USERNAME/$IMAGE_NAME:$TAG

if [ $? -ne 0 ]; then
  echo "Docker push failed. Exiting."
  exit 1
fi

echo "Docker image pushed successfully!"

# Cleanup
echo "Cleaning up..."
mvn clean
docker rmi $IMAGE_NAME
docker rmi $DOCKER_USERNAME/$IMAGE_NAME:$TAG

echo "Done!"