#!/bin/bash
# shellquizz.sh
# Shellquizz main script.

# History
# 23/09/2014 - Paulo Ortolan - Script creation

source shellquizz_lib.sh

retrieveQuizzInformations scifimovies.quizz

retrieveQuestions

for ((i=0; i < ${#array[*]}; i++))
do
    echo "[$i]"
    retrieveQuestionInformation "${array[i]}"
done
