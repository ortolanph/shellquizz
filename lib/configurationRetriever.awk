#!/bin/awk -f
BEGIN {
	FS="=";
}
{
	if ( $1 == conf ) {
		print $2
	}
}
