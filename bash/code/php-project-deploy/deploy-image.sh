#!/bin/bash

# Variables used in this script have already been initialized. However, to keep all used variables in a single place, I have listed all the variables used in this script
    # AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
    # DOCKER_REGISTRY=$DOCKER_REGISTRY
    # DOCKER_REPOSITORY=$DOCKER_REPOSITORY
    # APP_VERSION=$APP_VERSION
    # GITLAB_SSH_PRIVATE_KEY=$GITLAB_SSH_PRIVATE_KEY

DOCKER_IMAGE=$DOCKER_REGISTRY/$DOCKER_REPOSITORY:$APP_VERSION


# Function to handle errors during application setup
application_error_handler() {
  echo "Error: Something went wrong while performing commands on the Application."
  exit 1
}


# Login to AWS Elastic Container Registry
echo "Logging in to AWS Elastic Container Registry...."


# Get the login password for the Docker registry
login_password=$(aws ecr get-login-password --region "$AWS_DEFAULT_REGION")


# Login to the Docker registry
if ! echo "$login_password" | docker login --username AWS --password-stdin "$DOCKER_REGISTRY"; then
    echo "Error: Logging into AWS Elastic Container Registry failed"
    exit 1
fi


# Pull Docker image from AWS ECR
echo "Pulling Image from $DOCKER_IMAGE..."
if ! docker pull "$DOCKER_IMAGE"; then
    echo "Error: Pulling Image from $DOCKER_REGISTRY/$DOCKER_REPOSITORY:$APP_VERSION failed"
    exit 1
fi


# Configure the ssh-agent and private key
echo "Configuring SSH-Agent..."
eval "$(ssh-agent -s)"

echo "Adding Private Key to SSH-Agent..."
if ! echo "$GITLAB_SSH_PRIVATE_KEY" | ssh-add -; then
    echo "Error: SSH Agent Configuration Failed..."
    exit 1
fi


# delete existing repository
dir="$HOME/app"
if [ -d "$dir" ]; then
    echo -e "Existing Repository Detected\n Deleting existing Repository..."
    sudo rm -rf "$dir"
fi


# Clone gitlab repository
echo "Pulling Repository from Gitlab..."
ssh -o StrictHostKeyChecking=no git@gitlab.com
if ! git clone git@gitlab.com:sanjeevbhusal/php-internship-project.git app; then
    echo "Error: Cloning Repository Failed..."
    exit 1
fi


# changing to application directory
echo "Switching directory to 'app'"
cd app || exit


# Switch to the 'ci-test' branch
echo "Switching to 'ci-test' branch"
git switch ci-test


# Stop all running Docker containers
echo "Stopping all running containers..."
docker-compose down


# Tag recently pulled Docker image
echo "Tagging recently pulled Docker Image '$DOCKER_REGISTRY/$DOCKER_REPOSITORY:$APP_VERSION' as 'php-app'"
docker tag "$DOCKER_IMAGE" php-app


# Start new containers
echo "Starting new containers..."
if ! docker-compose up -d; then
    echo "Error: Something went wrong while starting new containers."
    exit 1
fi


# If any error occurs from any of the commands, run the error handler function .
trap application_error_handler ERR


# perform application level commands
echo "Copying '.env.example' as '.env'"
cp .env.example .env

echo "Installing Application Dependencies..."
docker-compose exec app composer install

echo "Generating Application Key..."
docker-compose exec app php artisan key:generate

echo "Performing Migration..."
docker-compose exec app php artisan migrate


# stop running error handler function even if error occurs
trap - ERR


# give permisson to apache to serve the files
if ! docker-compose exec app chown -R www-data:www-data /var/www/app; then
    echo "Error: Apache couldnot get permissions for '/var/www/app' directory."
    exit 1
fi


# remove all the previous/unnecessary images 
echo "Removing all previous images on the system..."
docker image prune -a -f


