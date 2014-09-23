#!/bin/bash
# Shellquizz lib script.

# History
# 23/09/2014 - Paulo Ortolan - Script creation
# 23/09/2014 - Paulo Ortolan - Adding more functions

# Constants
# Configuration file
SHELLQUIZZ_CONF="shellquizz.conf"
# Quizzes directory
QUIZZ_DIR=$PWD"/quizzes"
# Header for quizz title
H_QUIZZ_TITLE="quizz.title"
# Header for quizz author name
H_QUIZZ_AUTHOR="quizz.author.name"
# Header for quizz author e-mail
H_QUIZZ_AUTHOR_EMAIL="quizz.author.email"
# Header for quizz about file
H_QUIZZ_ABOUT="quizz.about"
# Header for quizz question file
H_QUIZZ_QUESTION="quizz.questions"


# Global Variables
# Quizz file
QUIZZ_FILE=$QUIZZ_DIR"/"
# Quizz title to be displayed on dialog titles
QUIZZ_TITLE=""
# Quizz author to be displayed on about screen
QUIZZ_AUTHOR=""
# Quizz author e-mail to be displayed on about screen
QUIZZ_AUTHOR_EMAIL=""
# Quizz about file
QUIZZ_ABOUT=$QUIZZ_DIR"/"
# Quizz question file
QUIZZ_QUESTION=$QUIZZ_DIR"/"

# Functions

# retrieveInformation
# Retrieves an information on the configuration (shellquizz.conf) file.
# retrieveInformation FILE KEY_NAME
function retrieveInformation() {
    echo $(awk -f lib/InformationRetriever.awk < $1 -v key=$2)
}

# showReadmeDialog
# Shows the README file in the docs dir.
# showReadmeDialog
function showReadmeDialog() {
    README=$( retrieveInformation $SHELLQUIZZ_CONF readme )

    if [ $README -eq 1 ]
    then
        echo "Read me dialog will be shown."
    else
        echo "Read me dialog will not be shown."
    fi
}

# showHowtoDialog
# Shows the HOWTO file in the docs dir.
# showHowtoDialog
function showHowtoDialog() {
    HOWTO=$( retrieveInformation $SHELLQUIZZ_CONF howto )

    if [ $HOWTO -eq 1 ]
    then
        echo "Read me dialog will be shown."
    else
        echo "Read me dialog will not be shown."
    fi
}

# showAboutDialog
# Shows the «quizz_name».about file.
# showAboutDialog
function showAboutDialog() {
    ABOUT=$( retrieveInformation $SHELLQUIZZ_CONF about )

    if [ $ABOUT -eq 1 ]
    then
        echo "Read me dialog will be shown."
    else
        echo "Read me dialog will not be shown."
    fi
}

# selectQuizz
# Show a list of installed quizzes. When cancelled, the program will quit.
# selectQuizz
function selectQuizz() {
    echo "Nothing"  
}

# listAllQuizzes
# List all quizzes in a line.
# listAllQuizzes
function listAllQuizzes() {
   QUIZZES=""

   for QUIZZ in $(ls $QUIZZ_DIR | grep ".quizz")
   do
      QUIZZES=$QUIZZES$QUIZZ" "
   done

   echo "["$QUIZZES"]"
}

# retrieveQuizzInformations
# Get all informations about the Quizz and store  on global variables.
# retrieveQuizzInformations QUIZZ_FILE_NAME
function retrieveQuizzInformations() {
    QUIZZ_FILE=$QUIZZ_DIR"/"$1

    QUIZZ_TITLE=$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_TITLE )
    QUIZZ_AUTHOR=$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_AUTHOR )
    QUIZZ_AUTHOR_EMAIL=$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_AUTHOR_EMAIL )
    QUIZZ_ABOUT=$QUIZZ_DIR"/"$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_ABOUT )
    QUIZZ_QUESTION=$QUIZZ_DIR"/"$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_QUESTION )
}
