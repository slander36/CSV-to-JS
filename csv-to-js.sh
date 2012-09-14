#!/bin/sh

if [ "${1}" == "-?" ]; then
	echo "USAGE:"
	echo "	csv_to_js.sh (-f|-l) [-h] [-d DELIM] [-?] [file]"
	echo ""
	echo "OPTIONS:"
	echo "	DO NOT STACK OPTIONS (e.g. ${0} -fhd ; is NOT allowed)"
	echo "	-f	Class element is in the first column"
	echo "	-l	Class element is in the last column"
	echo "	-h	File contains a header row"
	echo "	-d	Specify a delimiter (comma is default)"
	echo "	-?	Get Usage (this file)"
	echo ""
	echo "FILE:"
	echo "	Default delimiter is comma, so specify alternate or comma will be used"
	echo "	Signed ints and floats allowed"
	echo "	FOR HEADER ROW: No quotes required/allowed, but watch your commas"
	exit 0
fi;

COUNT=$#

TRUE=1
FALSE=0
TEMP=`date +%s`.tmp

FRONT=${FALSE}
HEADER=${FALSE}
DELIM=,
NEWLINE==
DATA=""

while [ "${1}" != "" ]; do
	case ${1} in
		-f )	FRONT=${TRUE}
			;;
		-l )	FRONT=${FALSE}
			;;
		-h )	HEADER=${TRUE}
			;;
		-d )	shift
					DELIM=${1}
			;;
		*.data ) DATA=${1}
			;;
		* )		echo "Unknown Option Encountered ${1}"
					echo ""
					${0} -?
					exit -1
			;;
	esac
	shift
done

NAME=`echo "${DATA%.*}" | sed -r "s/\s//g"`

JS=${NAME}.js

echo "/* Created with csv_to_js (c) Sean Lander */" > ${JS}
echo "" >> ${JS}
echo "/* Creating Data object ${NAME} */" >> ${JS}

echo "${NAME} = {};" >> ${JS}

if [ ${FRONT} != ${FALSE} ]; then
	sed -r "s/^([a-zA-Z0-9.\-]+),(.*)$/\2,\1/g" ${DATA} > ${TEMP}
else
	cat ${DATA} > ${TEMP}
fi;

if [ $HEADER == $TRUE ]; then
	echo "${NAME}.header = [`head -1 $DATA | sed -r "s/${DELIM}/,/g"`];" >> ${JS}
	echo "${NAME}.data = [" >> ${JS}
	tail -n +2 ${TEMP} | head -n -1 | sed -r "s/${DELIM}/,/g" | sed -r "s/^/\[/g" | sed -r "s/$/\],\
		/g" >> ${JS}
	tail -1 ${TEMP} | sed -r "s/${DELIM}/,/g" | sed -r "s/^/\[/g" | sed -r "s/$/\]\
		/g" >> ${JS}
	echo "];" >> ${JS}
else
	echo "${NAME}.data = [" >> ${JS}
	tail -n +1 ${TEMP} | head -n -1 | sed -r "s/${DELIM}/,/g" | sed -r "s/^/\[/g" | sed -r "s/$/\],\
		/g" >> ${JS}
	tail -1 ${TEMP} | sed -r "s/${DELIM}/,/g" | sed -r "s/^/\[/g" | sed -r "s/$/\]\
		/g" >> ${JS}
	echo "];" >> ${JS}
fi;

rm ${TEMP}

exit 0
