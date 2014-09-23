#!/bin/bash
# Shellquizz lib script.

# History
# 23/09/2014 - Paulo Ortolan - Script creation

# Constants
# Configuration file
SHELLQUIZZ_CONF=shellquizz.conf

# Functions

# retrieveConfigurationInformation
# Retrieves an information on the configuration (shellquizz.conf) file.
# retrieveConfigurationInformation [readme,howto,about]
function retrieveConfigurationInformation() {
    echo $(awk -f lib/configurationRetriever.awk < $SHELLQUIZZ_CONF -v conf=$1)
}

# showReadmeDialog
# Shows the README file in the docs dir
# showReadmeDialog
function showReadmeDialog() {
    README=$( retrieveConfigurationInformation readme )

    if [ $README -eq 1 ]
    then
        echo "Read me dialog will be shown."
    else
        echo "Read me dialog will not be shown."
    fi
}

# showHowtoDialog
# Shows the HOWTO file in the docs dir
# showHowtoDialog
function showHowtoDialog() {
    HOWTO=$( retrieveConfigurationInformation howto )

    if [ $HOWTO -eq 1 ]
    then
        echo "Read me dialog will be shown."
    else
        echo "Read me dialog will not be shown."
    fi
}

# showAboutDialog
# Shows the «quizz_name».about file
# showAboutDialog
function showAboutDialog() {
    ABOUT=$( retrieveConfigurationInformation about )

    if [ $ABOUT -eq 1 ]
    then
        echo "Read me dialog will be shown."
    else
        echo "Read me dialog will not be shown."
    fi
}
