#!/bin/bash
# Shellquizz lib script.

# History
# 23/09/2014 - Paulo Ortolan - Script creation
# 23/09/2014 - Paulo Ortolan - Adding more functions
# 24/09/2014 - Paulo Ortolan - New algorithm for retriving question informations
# 26/09/2014 - Paulo Ortolan - Adding UI

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
# The default height
DEFAULT_HEIGHT=600
# The default width
DEFAULT_WIDTH=800
# The default title
DEFAULT_TITLE="Shell Quizz"
# The readme document
README_DOC=$PWD"/docs/README"
# The howto document
HOWTO_DOC=$PWD"/docs/HOWTO"
# Select a quizz label
SELECT_QUIZZ="Select a quizz"
# Select the correct answer label
SELECT_QUIZZ="Select the correct answer"
# Final result file
FINAL_RESULT_FILE="result.html"

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
# Questions
QUIZZ_QUESTIONS=()
# The question title
QUESTION_TITLE=""
# The question options formatted as '"#1" "#2" "#3" "#4" "#5"'
QUESTION_OPTIONS=""
# The question answer
QUESTION_ANSWER=""
# Total Questions
TOTAL_QUESTIONS=0
# Total Correct
TOTAL_CORRECT=0
# Total Wrong
TOTAL_WRONG=0

# Functions

# retrieveInformation
# Retrieves an information on the configuration (shellquizz.conf) file.
# retrieveInformation FILE KEY_NAME
function retrieveInformation() {
    echo $(awk -f lib/InformationRetriever.awk < $1 -v key=$2)
}

# checkDialogAction
# Checks the dialog action. If any error occurred or the user has cancelled the action, the system exits.
# checkDialogAction
function checkDialogAction() {
    case $? in
        1)
            exit
            ;;
        -1)
            exit
            ;;
    esac
}

# showReadmeDialog
# Shows the README file in the docs dir.
# showReadmeDialog
function showReadmeDialog() {
    README=$( retrieveInformation $SHELLQUIZZ_CONF readme )

    if [ $README -eq 1 ]
    then
        zenity --text-info \
               --title="$DEFAULT_TITLE" \
               --height=$DEFAULT_HEIGHT \
               --width=$DEFAULT_WIDTH \
               --filename=$README_DOC \
               --html

        checkDialogAction
    fi
}

# showHowtoDialog
# Shows the HOWTO file in the docs dir.
# showHowtoDialog
function showHowtoDialog() {
    HOWTO=$( retrieveInformation $SHELLQUIZZ_CONF howto )

    if [ $HOWTO -eq 1 ]
    then
        zenity --text-info \
               --title="$DEFAULT_TITLE" \
               --height=$DEFAULT_HEIGHT \
               --width=$DEFAULT_WIDTH \
               --filename=$HOWTO_DOC \
               --html

        checkDialogAction
    fi
}

# showAboutDialog
# Shows the «quizz_name».about file.
# showAboutDialog
function showAboutDialog() {
    ABOUT=$( retrieveInformation $SHELLQUIZZ_CONF about )

    if [ $ABOUT -eq 1 ]
    then
        zenity --text-info \
               --title="$QUIZZ_TITLE" \
               --height=$DEFAULT_HEIGHT \
               --width=$DEFAULT_WIDTH \
               --filename=$QUIZZ_ABOUT \
               --html

        checkDialogAction
    fi
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

   echo $QUIZZES
}

# selectQuizz
# Show a list of installed quizzes. When cancelled, the program will quit.
# selectQuizz
function selectQuizz() {
    SELECTED_QUIZZ=$(zenity --list \
                            --title="$DEFAULT_TITLE" \
                            --height=$DEFAULT_HEIGHT \
                            --width=$DEFAULT_WIDTH \
                            --column="$SELECT_QUIZZ" \
                            $( listAllQuizzes ) )

    checkDialogAction
   
    echo $SELECTED_QUIZZ
}

# retrieveQuizzInformations
# Get all informations about the Quizz and store  on global variables.
# retrieveQuizzInformations QUIZZ_FILE_NAME
function retrieveQuizzInformations() {
    QUIZZ_FILE=$QUIZZ_DIR"/"$1

    if [ -z $1 ]
    then
        exit
    fi

    QUIZZ_TITLE=$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_TITLE )
    QUIZZ_AUTHOR=$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_AUTHOR )
    QUIZZ_AUTHOR_EMAIL=$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_AUTHOR_EMAIL )
    QUIZZ_ABOUT=$QUIZZ_DIR"/"$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_ABOUT )
    QUIZZ_QUESTION=$QUIZZ_DIR"/"$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_QUESTION )
}

# retrieveQuestions
# Retrieves the questions in the $QUIZ_QUESTION file.
# retrieveQuestions
function retrieveQuestions() {
    if [ -s $QUIZZ_QUESTION ]
    then
        while read QUESTION
        do
            QUIZZ_QUESTIONS[$TOTAL_QUESTIONS]=$QUESTION

            TOTAL_QUESTIONS=$(( $TOTAL_QUESTIONS + 1 ))
        done < $QUIZZ_QUESTION
    else
        exit
    fi
}

# retrieveQuestionTitle
# Retrives the question title given a question line.
# retrieveQuestionTitle LINE
function retrieveQuestionTitle() {
    echo $1 | cut -d';' -f1
}

# retrieveOptions
# Retrives the question options given a question line.
# retrieveOptions LINE
function retrieveOptions() {
    OPTIONS="$( echo $1 | cut -d';' -f2) "
    OPTIONS=$OPTIONS"$( echo $1 | cut -d';' -f3) "
    OPTIONS=$OPTIONS"$( echo $1 | cut -d';' -f4) "
    OPTIONS=$OPTIONS"$( echo $1 | cut -d';' -f5) "
    OPTIONS=$OPTIONS"$( echo $1 | cut -d';' -f6)"

    echo $OPTIONS
}

# retrieveQuestionAnswer
# Retrives the question answer given a question line.
# retrieveQuestionAnswer LINE
function retrieveQuestionAnswer() {
    echo $1 | cut -d';' -f7
}

# retrieveQuestionInformation
# Retrieves informations on a question line.
# retrieveQuestionInformation STRING
function retrieveQuestionInformation() {
    IFS='%'

    QUESTION_TITLE=$( retrieveQuestionTitle $1 )
    QUESTION_OPTIONS=$( retrieveOptions $1 )
    QUESTION_ANSWER=$( retrieveQuestionAnswer $1 )

    unset IFS
}

# main
# The main funcion.
# main
function main() {
    showReadmeDialog
    showHowtoDialog
    retrieveQuizzInformations $( selectQuizz )
    showAboutDialog

    retrieveQuestions

    for (( q=0 ; q<$TOTAL_QUESTIONS ; q++ ))
    do
        retrieveQuestionInformation "${QUIZZ_QUESTIONS[$q]}"

        MY_ANSWER=$( zenity --list \
                            --title="$QUESTION_TITLE" \
                            --height=$DEFAULT_HEIGHT \
                            --width=$DEFAULT_WIDTH \
                            --column="$SELECT_CORRECT" \
                            $QUESTION_OPTIONS )

        checkDialogAction
 
        if [ "$MY_ANSWER" == "$QUESTION_ANSWER" ]
        then
            TOTAL_CORRECT=$(( $TOTAL_CORRECT + 1 ))
        else
            TOTAL_WRONG=$(( $TOTAL_WRONG + 1 ))
        fi
    done

    echo "Total [$TOTAL_QUESTIONS] Correct [$TOTAL_CORRECT] Wrong [$TOTAL_WRONG]"
}
