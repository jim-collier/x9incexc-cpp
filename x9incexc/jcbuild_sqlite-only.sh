#!/bin/bash

##	Purpose: Custom build script
##	History:
##		- 20200821 JC: Created because I have no f'ing idea what I'm doing.


function fMain(){

	clear

	local -r serialDT="$(date "+%Y%m%d-%H%M%S")"
	local -r outputName_Sqlite3="sqlite3"

	## Remove collisions
	if [[ -f "build/obj/${outputName_Sqlite3}_${serialDT}" ]]; then  rm "build/obj/${outputName_Sqlite3}_${serialDT}"; fi
	if [[ -f "build/obj/${outputName_Sqlite3}_new" ]]; then          rm "build/obj/${outputName_Sqlite3}_new"; fi

	## Compile sqlite3
	cd 'src/sqlite-amalgamation'
#	fEchoAndDo "gcc -c -DSQLITE_DEFAULT_FOREIGN_KEYS=1 -o ../../build/obj/${outputName_Sqlite3}_new sqlite3.c -lpthread -ldl"
	fEchoAndDo "gcc    -DSQLITE_DEFAULT_FOREIGN_KEYS=1 -o ../../build/obj/${outputName_Sqlite3}_new sqlite3.c -lpthread -ldl"
	if [[ -f "../../build/obj/${outputName_Sqlite3}" ]]; then mv  "../../build/obj/${outputName_Sqlite3}"  "../../build/obj/${outputName_Sqlite3}_${serialDT}"; fi
	mv  "../../build/obj/${outputName_Sqlite3}_new"  "../../build/obj/${outputName_Sqlite3}"
	cd ../..

	echo
	ls -lA --color=always "build/"
	echo
	echo "[ Done. ]"
	echo
}


function fEchoAndDo(){
	echo "[ Executing: $* ]"
	eval "$*"
}

set -e
set -E
fMain