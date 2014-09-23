#!/bin/awk -f
BEGIN {
	FS=";";
}
{
	if ( conf == "readme" ) {
		print $1
	}

	if ( conf == "howto" ) {
		print $2
	}

	if ( conf == "about" ) {
		print $3
	}
}
