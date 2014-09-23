#!/bin/awk -f
BEGIN {
	FS=";";
}
{
	if ( element == "question.title" ) {
		print $1
	}

	if ( element == "question.options" ) {
		print "\"" $2 "\" \"" $3 "\" \"" $4 "\" \"" $5 "\" \"" $6 "\""
	}

	if ( element = "question.answer" ) {
		print $7
	}
}
