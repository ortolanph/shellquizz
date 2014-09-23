#!/bin/awk -f
BEGIN {
	FS=";";
}
{
	if ( element == "title" ) {
		print $1
	}

	if ( element == "options" ) {
		print "\"" $2 "\" \"" $3 "\" \"" $4 "\" \"" $5 "\" \"" $6 "\""
	}

	if ( element = "answer" ) {
		print $7
	}
}
