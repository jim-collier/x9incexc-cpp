#include <iostream>    // std::cout
#include <vector>      // std::vector
#include <algorithm>   // std::find
#include <string>      // std::string
#include "sqlite-amalgamation/sqlite3.h"
#include "../../0_include/cpp/src/x9toolbox.cpp"

using namespace std;

const std::string ver { u8"0.0.9" };

int main(
	int   argc,   // Number of strings in array argv
	char *argv[], // Array of command-line argument strings
	char *envp[]  // Array of environment variable strings
){

	// Make sure we're using C++17
	if constexpr (false){ cout << u8"FYI: Not C++17\n"; } // This C++17-specific language feature will generate a compile-time error if compiler isn't C++17.

	// Process arguments
	std::string const exec_name = argv[0]; // Name of the current exec program
	std::string all_args; for (int i=1; i<argc; i++) { all_args.append(std::string(argv[i]).append(" ")); }  // All args as string
	if (strIsInCI_v1(" " + all_args + " ", u8" --version ")) {
		fEcho_Clean_v1(u8"Version: " + ver);
		exit(0);
	}

	// Variables
	int returnVal {1};
	sqlite3 *sql3Db;
	char *sql3ErrMsg {0};

	returnVal=0;
	exit(returnVal);
}
