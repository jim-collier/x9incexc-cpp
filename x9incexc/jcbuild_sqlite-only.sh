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

	## Sqlite3 compile-time flags; possibly have no effect in golang (unless using it to compile sqlite3 into program from source), but just in case:
	local sqlite3CompileFlags=""
	sqlite3CompileFlags="${sqlite3CompileFlags} -DSQLITE_OMIT_LOAD_EXTENSION"  #................: Solves a Go problem related to static linking.
	sqlite3CompileFlags="${sqlite3CompileFlags} -DSQLITE_DEFAULT_FOREIGN_KEYS=1"  #.............: 1=Enable foreign key constraints by defualt. (0 is default only for backward compatibility.)
	sqlite3CompileFlags="${sqlite3CompileFlags} -DSQLITE_THREADSAFE=0"  #.......................: 0=single-threaded, 1=fully multithreaded, 2=multithreaded but only one db connection at a time. Default=1, Sqlite3 recommended=0.
	sqlite3CompileFlags="${sqlite3CompileFlags} -DSQLITE_DEFAULT_WAL_SYNCHRONOUS=1"  #..........: Sqlite3 recommended (faster than default and safe).
	sqlite3CompileFlags="${sqlite3CompileFlags} -DSQLITE_DEFAULT_LOCKING_MODE=1"  #.............: 1=Exclusive lock. Usually no reason not to, for 1db per 1app.
    sqlite3CompileFlags="${sqlite3CompileFlags} -DSQLITE_DQS=0"  #..............................: Sqlite3 recommended. Disables the double-quoted string literal misfeature, originally intended to be compatible with older MySql databases.
    sqlite3CompileFlags="${sqlite3CompileFlags} -DSQLITE_DEFAULT_MEMSTATUS=0"  #................: Sqlite3 recommended. causes the sqlite3_status() to be disabled. Speeds everything up.
    sqlite3CompileFlags="${sqlite3CompileFlags} -DSQLITE_LIKE_DOESNT_MATCH_BLOBS"  #............: Sqlite3 recommended. Speeds up LIKE and GLOB operators.
    sqlite3CompileFlags="${sqlite3CompileFlags} -DSQLITE_MAX_EXPR_DEPTH=0"  #...................: Sqlite3 recommended. Simplifies the code resulting in faster execution, and helps the parse tree to use less memory.
    sqlite3CompileFlags="${sqlite3CompileFlags} -DSQLITE_OMIT_DEPRECATED"  #....................: Sqlite3 recommended.
    sqlite3CompileFlags="${sqlite3CompileFlags} -DSQLITE_OMIT_PROGRESS_CALLBACK"  #.............: Sqlite3 recommended.
    sqlite3CompileFlags="${sqlite3CompileFlags} -DSQLITE_OMIT_SHARED_CACHE"  #..................: Sqlite3 recommended. Speeds up.
    sqlite3CompileFlags="${sqlite3CompileFlags} -DSQLITE_USE_ALLOCA"  #.........................: Sqlite3 recommended. Make use of alloca() if exists.
	sqlite3CompileFlags="$(fStrNormalize_byecho "${sqlite3CompileFlags}")"  #...................: Normalize string

	## Compile sqlite3
	cd 'src/sqlite-amalgamation'

	## Compile only, to .o object file; don't link
#	fEchoAndDo "gcc -c ${sqlite3CompileFlags} -o ../../build/obj/${outputName_Sqlite3}_new sqlite3.c -lpthread -ldl"
	
	## Compile and link to .so or .dll
	fEchoAndDo "gcc    ${sqlite3CompileFlags} -o ../../build/obj/${outputName_Sqlite3}_new sqlite3.c -lpthread -ldl"

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

function fStrNormalize_byecho(){
	local argStr="$*"
	argStr="$(echo -e "${argStr}")" #.................................................................. Convert \n and \t to real newlines, etc.
	argStr="${argStr//$'\n'/ }" #...................................................................... Convert newlines to spaces
	argStr="${argStr//$'\t'/ }" #...................................................................... Convert tabs to spaces
	argStr="$(echo "${argStr}" | awk '{$1=$1};1' 2>/dev/null || true)" #............................... Collapse multiple spaces to one and trim
	argStr="$(echo "${argStr}" | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//' 2>/dev/null || true)" #..... Additional trim
	echo "${argStr}"
}

set -e
set -E
fMain