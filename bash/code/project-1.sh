#!/bin/bash
# This bash script is used to clone a github repository and start the application.


# Define Variables  
PROJECT_NAME="pythonApp"


# If appropriate command line argument was supplied, update the variable PROJECT_NAME
while getopts "n:" argument; do
    case $argument in 
        n) PROJECT_NAME="$OPTARG" ;;
        \?)  exit 1 ;;
    esac
done


# The cloned repository will be saved as $PROJECT_NAME. If a directory with this name already exist, exit the script. 
if [ -d "$PROJECT_NAME" ]; then
    echo -e "Directory '$PROJECT_NAME' already exists. Pass a different name to the script using -n flag.\nExample: ./project-1.sh -n newname\nAborting the operation"
    exit 1
fi


# Clone the repository.
echo -n "Step 1: Enter the Url of the repository: "
read -r URL

echo -e "\nStep 2: Cloning the repository\n"
if ! git clone "$URL" "$PROJECT_NAME"; then
    echo -e "Sucess: Repository download succedded\n"
else
    echo -e "Error: Repositry download failed\n"
    exit 1
fi


# Move inside projects directory
cd "$PROJECT_NAME" || exit 


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