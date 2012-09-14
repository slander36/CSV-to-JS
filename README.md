CSV-to-JS
=========

Script for converting CSV files into JS objects for direct embedding into webpages (useful for HTML5 presentations lacking internet for whatever reason)

USAGE:
	csv_to_js.sh (-f|-l) [-h] [-d DELIM] [-?] [file]

OPTIONS:
	DO NOT STACK OPTIONS (e.g. ${0} -fhd ; is NOT allowed)
	-f	Class element is in the first column
	-l	Class element is in the last column
	-h	File contains a header row
	-d	Specify a delimiter (comma is default)
	-?	Get Usage (this file)

FILE:
	Default delimiter is comma, so specify alternate or comma will be used
	Signed ints and floats allowed
	FOR HEADER ROW: No quotes required/allowed, but watch your commas
