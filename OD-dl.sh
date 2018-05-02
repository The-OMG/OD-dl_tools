#!/usr/bin/env bash


################################################################################
####     Will quickly generate a urls.txt of a http open directory          ####
####            and download each file in parallel with axel.               ####
################################################################################
####                                Usage:                                  ####
####            OD-dl.sh "https://the-eye.eu/public" "theeye"               ####
################################################################################
#							      ___           ___           ___                            #
#							     /  /\         /__/\         /  /\                           #
#							    /  /::\       |  |::\       /  /:/_                          #
#							   /  /:/\:\      |  |:|:\     /  /:/ /\                         #
#							  /  /:/  \:\   __|__|:|\:\   /  /:/_/::\                        #
#							 /__/:/ \__\:\ /__/::::| \:\ /__/:/__\/\:\                       #
#							 \  \:\ /  /:/ \  \:\~~\__\/ \  \:\ /~~/:/                       #
#							  \  \:\  /:/   \  \:\        \  \:\  /:/                        #
#							   \  \:\/:/     \  \:\        \  \:\/:/                         #
#							    \  \::/       \  \:\        \  \::/                          #
#							     \__\/         \__\/         \__\/                           #
#                                                                              #
################################################################################
#### rclone credit        : https://github.com/ncw/rclone
###  Install rclone       : https://rclone.org/install/
###  Install rclone       : "brew install rclone"

#### GNU parallel credit  : https://www.gnu.org/software/parallel/
###  Install GNU parallel : "sudo apt-get install parallel"
###  Install GNU parallel : "brew install parallel"

#### axel credit          : https://github.com/axel-download-accelerator/axel
###  Install axel         : https://github.com/axel-download-accelerator/axel/releases
###  Install axel         : "brew install axel"
################################################################################

# name of the folder that all output files will go.
projectPATH=("${HOME}"/files/"$2")

# Path to the urls.txt file. Is used as input for downloading with axel
URLS=("${HOME}"/files/"$2"/urls.txt)

function jim() {
  "$@" || { echo "he's dead jim: $@" && exit 1;}
}

function project_folder() {
  mkdir -p "${projectPATH[*]}"
}

function rclone_tree() {
  # Arguments for the rclone package.
  # "RCLONE_CONFIG_ZZ_TYPE="  : Allows use of rclone with a http remote without a Config file.
  # "RCLONE_CONFIG_ZZ_URL="   : Tells rclone what website its working with.
  # "--fast-list": "Use recursive list if available. Uses more memory but fewer transactions."
  # "--all"      : "All files are listed (list . files too)."
  # "--full-path": "Print the full path prefix for each file."
  # "--noindent" : "Don't print indentation lines."
  # "--noreport" : "Turn off file/directory count at end of tree listing."
  # "--checkers=": "Number of checkers to run in parallel. (default 8)"
  # "--output="  : "Output to file instead of stdout."
  local rloneARGS=("--all" "--fast-list" "--noindent" "--full-path" "--noreport" "--checkers=4" "--output=${URLS[@]}")
  RCLONE_CONFIG_ZZ_TYPE=http RCLONE_CONFIG_ZZ_URL=$1 rclone tree zz: "${rloneARGS[@]}"
}

function OD_structure() {
  local parallelARGS=("--jobs=4" "--joblog=${projectPATH[*]}/OD-dl.log")
  parallel "${parallelARGS[@]}" mkdir -p "${projectPATH[*]}"{.} :::: "${URLS[@]}"
}

function parallelize() {
  # Arguments for the GNU parallel package.
  # "--link"        : "If multiple input sources are given, one argument will be read from each of the input sources."
  # "--jobs=n"      : "Run n jobs in parallel."
  # "--delay=n"     : "Delay the start of new jobs n amount of seconds."
  # "--joblog="     : "Path to logfile of the jobs completed so far."
  # "--shuf"        : "Shuffle order that jobs are ran."
  # " :::: "        : "argfiles. Unlike other options for GNU parallel :::: is placed after the command and before the arguments."
  local parallelARGS=("--jobs=4" "--delay=3" "--joblog=${projectPATH[*]}/OD-dl.log" "--shuf" "--link")
  # Arguments for the axel package.
  # "--output=x"  : "Data will be downloaded to this file or directory."
  # "--no-clobber": "Skip download if a file with the same name already exists in the current folder and no state file is found."
  local axelARGS=("--output=${projectPATH[*]}{2}" "--no-clobber")
  parallel "${parallelARGS[@]}" axel ${axelARGS[@]} "${1}"{1} :::: "${URLS[@]}" "${URLS[@]}"
}

jim project_folder && jim rclone_tree "$@" &&  OD_structure "$@" && jim parallelize "$@"
echo ""
echo "Was that quick or what?"
