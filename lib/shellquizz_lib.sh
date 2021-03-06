#!/bin/bash
# Shellquizz lib script.

# History
# 23/09/2014 - Paulo Ortolan - Script creation
# 23/09/2014 - Paulo Ortolan - Adding more functions
# 24/09/2014 - Paulo Ortolan - New algorithm for retrieving question informations
# 26/09/2014 - Paulo Ortolan - Adding UI
# 01/10/2014 - Paulo Ortolan - Algorithm for questions
# 05/10/2014 - Paulo Ortolan - Result screen
# 13/10/2014 - Paulo Ortolan - Documentation and result screen finished.
# 15/10/2014 - Paulo Ortolan - Putting the question title on COLUMN variable of zenity-list dialog
# 15/10/2014 - Paulo Ortolan - Moving this file to lib directory to protect library code. Adaptations were made.
# 26/11/2015 - Paulo Ortolan - Directory changes due decision to make a .deb file
# 26/11/2015 - Paulo Ortolan - Added setup function, that creates shellquiz folder hidden in $HOME.
# 27/11/2015 - Paulo Ortolan - Added copy to configuration file and logMessage function

# Constants
# Version
VERSION="1.1"
# Shellquizz base directory
SHELLQUIZZ_BASE_DIR="/usr/share/shellquizz"
# Quizzes directory
ORIGINAL_QUIZZ_FOLDER=$SHELLQUIZZ_BASE_DIR"/quizzes"
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
README_DOC=$SHELLQUIZZ_BASE_DIR"/docs/README"
# The howto document
HOWTO_DOC=$SHELLQUIZZ_BASE_DIR"/docs/HOWTO"
# Select a quizz label
SELECT_QUIZZ="Select a quizz"
# Shellquizz $HOME folder
SHELLQUIZ_HOME_FOLDER=$HOME"/.shellquizz"
# Results folder
RESULT_FOLDER=$SHELLQUIZ_HOME_FOLDER"/result"
# Quizzes directory
QUIZZ_FOLDER=$SHELLQUIZ_HOME_FOLDER"/quizzes"
# Final result file
FINAL_RESULT_FILE=$RESULT_FOLDER"/result.html"
# Configuration file
SHELLQUIZZ_CONF=$SHELLQUIZ_HOME_FOLDER"/shellquizz.conf"

# Global Variables
# Quizz file
QUIZZ_FILE="$QUIZZ_FOLDER/"
# Quizz title to be displayed on dialog titles
QUIZZ_TITLE=""
# Quizz author to be displayed on about screen
QUIZZ_AUTHOR=""
# Quizz author e-mail to be displayed on about screen
QUIZZ_AUTHOR_EMAIL=""
# Quizz about file
QUIZZ_ABOUT=$QUIZZ_FOLDER"/"
# Quizz question file
QUIZZ_QUESTION=$QUIZZ_FOLDER"/"
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

# logMessage
# Appends a message into $SHELLQUIZ_HOME_FOLDER/shellquizz.log message
# logMessage <message>
function logMessage() {
	LOG_FILE=$SHELLQUIZ_HOME_FOLDER"/shellquizz.log"
	MESSAGE=$1
	
	if [ ! -f $LOG_FILE ]
	then
		echo "[shellquizz] Shellquizz $VERSION log" > $LOG_FILE
	fi
	
	echo "[shellquizz] $MESSAGE" >> $LOG_FILE
}

# setup
# Creates shellquiz directory to store results file, default quiz and user quizzes
# setup
function setup() {
	# Checks if there's no $HOME/.shellquizz and creates it
	if [ ! -d $SHELLQUIZ_HOME_FOLDER ]
	then
		mkdir -p $SHELLQUIZ_HOME_FOLDER
		logMessage "Folder $SHELLQUIZ_HOME_FOLDER created"
	fi
	
	# Checks if there's no $HOME/.shellquizz/result and creates it
	if [ ! -d $RESULT_FOLDER ]
	then
		mkdir -p $RESULT_FOLDER
		logMessage "Folder $RESULT_FOLDER created"
	fi
	
	# Checks if there's no $HOME/.shellquizz/quizzes and creates it
	if [ ! -d $QUIZZ_FOLDER ]
	then
		mkdir -p $QUIZZ_FOLDER
		logMessage "Folder $QUIZZ_FOLDER created"
	fi
	
	# Checks if there's shellquizz.conf file on $HOME/.shellquizz/ and copies it if don't
	CONFIGURATION_FILE=$SHELLQUIZ_HOME_FOLDER"/shellquizz.conf"
    if [ ! -f $CONFIGURATION_FILE ]
    then
		logMessage "Copying $SHELLQUIZZ_BASE_DIR/shellquizz.conf file to $SHELLQUIZ_HOME_FOLDER"
        cp $SHELLQUIZZ_BASE_DIR"/shellquizz.conf" $CONFIGURATION_FILE
        logMessage "Files copied to $CONFIGURATION_FILE"
    fi	
	
	# Copies the quizzes to created folder
	if [ ! "$( ls -A $QUIZZ_FOLDER )" ]
    then
		logMessage "Copying $ORIGINAL_QUIZZ_FOLDER files to folder $QUIZZ_FOLDER"
        cp $ORIGINAL_QUIZZ_FOLDER/* $QUIZZ_FOLDER/.
        logMessage "Files copied to folder $QUIZZ_FOLDER"
    fi
	
}

# retrieveInformation
# Retrieves an information on the configuration (shellquizz.conf) file.
# retrieveInformation FILE KEY_NAME
function retrieveInformation() {
    echo $(awk -f $SHELLQUIZZ_BASE_DIR/lib/InformationRetriever.awk < $1 -v key=$2)
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

   for QUIZZ in $(ls $QUIZZ_FOLDER | grep ".quizz")
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
    QUIZZ_FILE=$QUIZZ_FOLDER"/"$1

    if [ -z $1 ]
    then
        exit
    fi

    QUIZZ_TITLE=$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_TITLE )
    QUIZZ_AUTHOR=$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_AUTHOR )
    QUIZZ_AUTHOR_EMAIL=$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_AUTHOR_EMAIL )
    QUIZZ_ABOUT=$QUIZZ_FOLDER"/"$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_ABOUT )
    QUIZZ_QUESTION=$QUIZZ_FOLDER"/"$( retrieveInformation $QUIZZ_FILE $H_QUIZZ_QUESTION )
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

# computeResults
# Creates the result file html page.
# computeResults
function computeResults() {
    if [ -f $FINAL_RESULT_FILE ]
    then
        rm $FINAL_RESULT_FILE
    fi

cat > $FINAL_RESULT_FILE <<EOF
<!DOCTYPE html>
<html>
 <head>
  <meta http-equiv="Content-Type" content="text/html" charset="utf-8">
  <title>Shell Quizz - Results</title>
 </head>
 <body style="font-family: sans">
  <h1>Shell Quizz</h1>
  <h2>Results</h2>
  <p>Congratulations to finish the quizz $QUIZZ_TITLE!</p>
  <table>
   <tr style="font-size: 2em">
    <td style="text-align: center"><strong>Total<br/>Questions</strong></td>
    <td style="text-align: center"><strong>Correct<br/>Answers</strong></td>
    <td style="text-align: center"><strong>Wrong<br/>Answers</strong></td>
   </tr>
   <tr style="font-size: 4em">
    <td style="color: navy; text-align: center">$TOTAL_QUESTIONS</td>
    <td style="color: green; text-align: center">$TOTAL_CORRECT</td>
    <td style="color: red; text-align: center">$TOTAL_WRONG</td>
   </tr>
  </table>
  <p>Tell <a href="mailto:$QUIZZ_AUTHOR_EMAIL">$QUIZZ_AUTHOR ($QUIZZ_AUTHOR_EMAIL)</a> about your experience. Contribute!</p>
  <p>Thanks for using shellquiz! Have fun!</p>
 </body>
</html>
EOF

}

# showResultsDialog
# Shows the results file.
# showResultsDialog
function showResultsDialog() {
    zenity --text-info \
           --title="$DEFAULT_TITLE" \
           --height=$DEFAULT_HEIGHT \
           --width=$DEFAULT_WIDTH \
           --filename=$FINAL_RESULT_FILE \
           --html
}

# main
# The main funcion.
# main
function main() {
	setup
    showReadmeDialog
    showHowtoDialog
    retrieveQuizzInformations $( selectQuizz )
    showAboutDialog

    retrieveQuestions

    for (( q=0 ; q<$TOTAL_QUESTIONS ; q++ ))
    do
        retrieveQuestionInformation "${QUIZZ_QUESTIONS[$q]}"

        MY_ANSWER=$( zenity --list \
                            --title="$DEFAULT_TITLE" \
                            --height=$DEFAULT_HEIGHT \
                            --width=$DEFAULT_WIDTH \
                            --column="$QUESTION_TITLE" \
                            $QUESTION_OPTIONS )

        checkDialogAction
 
        if [ "$MY_ANSWER" == "$QUESTION_ANSWER" ]
        then
            TOTAL_CORRECT=$(( $TOTAL_CORRECT + 1 ))
        else
            TOTAL_WRONG=$(( $TOTAL_WRONG + 1 ))
        fi
    done

    computeResults
    showResultsDialog
}
