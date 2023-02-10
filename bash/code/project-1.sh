#!/bin/bash

# This bash script is used to clone a github repository.

echo -e "This script is used to download a git repository.\n"

# Get the URL of the repository to clone 
echo -n "Step 1: Enter the Url of the repository: "
read URL

# Cloning the repository
echo -e "\nStep 2: Cloning the repository\n"
git clone $URL
status=$?


# Check if the repository is installed correctly
echo ""

if [ $status -eq 0 ]; then
    echo -e "Sucess: Repository download succedded."
else
    echo -e "Error: Repositry download failed"
    exit 1
fi