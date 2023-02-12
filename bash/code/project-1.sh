#!/bin/bash

# This bash script is used to clone a github repository and start the application.

# Set default value for the variable  
PROJECT_NAME="pythonApp"


# Check if command line argument was supplied
while getopts "n:" argument; do
    case $argument in 
        n) PROJECT_NAME="$OPTARG" ;;
        \?)  exit 1 ;;
    esac
done


if [ -d $PROJECT_NAME ]; then
    # If directory already exists, exit the script 
    echo -e "Directory '$PROJECT_NAME' already exists. Pass a different name to the script using -n flag.\nExample: ./project-1.sh -n newname\nAborting the operation"
    exit 1
fi

# Get the URL of the repository to clone 
echo -n "Step 1: Enter the Url of the repository: "
read URL

# Cloning the repository
echo -e "\nStep 2: Cloning the repository\n"
git clone $URL $PROJECT_NAME

# Check if the repository is installed correctly
if [ $? -eq 0 ]; then
    echo -e "Sucess: Repository download succedded\n"
else
    echo -e "Error: Repositry download failed\n"
    # exit 1
fi

# Move inside projects directory
cd $PROJECT_NAME

# Create a virtual environment
echo -e "Step 3: Creating the virtual environment\n"
python3 -m venv venv

# Activate Virtual environment
echo -e "Step 4: Activating the virtual environment\n"
source venv/bin/activate

# Installing all the dependencies
echo -e "Step 5: Installing all the dependencies\n"
pip install -r requirements.txt

# Seeding database
echo -e -n "\nStep6: "
python seed_database.py

# Display success message
echo -e "\nSucess: Project has been installed succesfully\n"

# Running the project
echo -e "Step6: Starting the Application Server..\n"
python wsgi.py