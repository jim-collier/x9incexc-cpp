#!/bin/bash

##	Purpose: Custom build script
##	History:
##		- 20200821 JC: Created because I have no f'ing idea what I'm doing.


function fMain(){

	clear

	local -r serialDT="$(date "+%Y%m%d-%H%M%S")"
	local -r outputName_Sqlite3="sqlite3.o"
	local -r outputName_main="x9incexc"

	## Remove collisions
	if [[ -f "build/obj/${outputName_Sqlite3}_${serialDT}" ]]; then  rm "build/obj/${outputName_Sqlite3}_${serialDT}"; fi
	if [[ -f "build/${outputName_main}_${serialDT}" ]]; then         rm "build/${outputName_main}_${serialDT}"; fi
	if [[ -f "build/obj/${outputName_Sqlite3}_new" ]]; then          rm "build/obj/${outputName_Sqlite3}_new"; fi
	if [[ -f "build/obj/${outputName_main}_new" ]]; then             rm "build/obj/${outputName_main}_new"; fi

#	## Compile sqlite3
#	cd 'src/sqlite-amalgamation'
#	fEchoAndDo "gcc -c -DSQLITE_DEFAULT_FOREIGN_KEYS=1 -o ../../build/obj/${outputName_Sqlite3}_new sqlite3.c -lpthread -ldl"
#	if [[ -f "../../build/obj/${outputName_Sqlite3}" ]]; then mv  "../../build/obj/${outputName_Sqlite3}"  "../../build/obj/${outputName_Sqlite3}_${serialDT}"; fi
#	mv  "../../build/obj/${outputName_Sqlite3}_new"  "../../build/obj/${outputName_Sqlite3}"
#	cd ../..

	## Compiling main
	cd "src"
	fEchoAndDo "g++ -c -std=c++1z -DSQLITE_DEFAULT_FOREIGN_KEYS=1 -Isqlite-amalgamation -o ../build/obj/${outputName_main}.o_new main.cpp  -lpthread -ldl"
	if [[ -f "../build/obj/${outputName_main}.o" ]]; then mv  "../build/obj/${outputName_main}.o"  "../build/obj/${outputName_main}.o_${serialDT}"; fi
	mv  "../build/obj/${outputName_main}.o_new"  "../build/obj/${outputName_main}.o"
	cd ..

	## Link
	fEchoAndDo "g++ -std=c++1z -DSQLITE_DEFAULT_FOREIGN_KEYS=1 -Isrc/sqlite-amalgamation -o build/${outputName_main}_new build/obj/${outputName_main}.o build/obj/${outputName_Sqlite3} -lpthread -ldl"
	if [[ -f "build/${outputName_main}" ]]; then mv  "build/${outputName_main}"  "build/${outputName_main}_${serialDT}"; fi
	mv  "build/${outputName_main}_new"  "build/${outputName_main}"
	chmod +x "build/${outputName_main}"

	echo
	ls -lA --color=always "build/${outputName_main}"
	echo
	echo "[ Running: build/${outputName_main} --version ]"
	echo
	build/${outputName_main} --version
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