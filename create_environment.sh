#!/bin/bash
# ask the name before logging into the app
echo "could you provide your name"
read user_name;
# create the main directory
main_directory=submission_reminder_${user_name}
mkdir -p $main_directory/{app,config,modules,assets}

touch $main_directory/config/config.env
touch $main_directory/app/reminder.sh && chmod u+x $main_directory/app/reminder.sh
touch $main_directory/modules/functions.sh && chmod u+x $main_directory/modules/functions.sh
touch $main_directory/startup.sh && chmod u+x $main_directory/startup.sh
touch $main_directory/assets/submissions.txt
echo 'student, assignment, submission status
elou, Shell Navigation, submitted
kevine, Shell Navigation, not submitted
garnaue, Shell Navigation, not submitted
kalsa, Shell Navigation, not submitted
keza, Shell Navigation, submitted
ange, Shell Navigation, not submitted
kessy, Shell Navigation, submitted' > $main_directory/assets/submissions.txt
echo '# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2' > $main_directory/config/config.env
echo '#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)
        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}' > $main_directory/modules/functions.sh
echo '#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"
# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file' > $main_directory/app/reminder.sh
echo '#!/bin/bash
./$main_directory/app/reminder.sh' > $main_directory/startup.sh
chmod +x $main_directory/startup.sh
echo "set up environment has been  successfully completed :$main_directory"

