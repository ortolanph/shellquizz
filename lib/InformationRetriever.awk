#!/bin/awk -f
BEGIN {
	FS="=";
}
{
	if ( $1 == key ) {
		print $2
	}
}
