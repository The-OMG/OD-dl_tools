#!/bin/bash

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
PROJECTFOLDER="$2"

# Path to the urls.txt file. Is used as input for downloading with axel
URLS="$HOME/files/$PROJECTFOLDER/urls.txt"

# Allows use of rclone with a http remote without a Config file.
export RCLONE_CONFIG_ZZ_TYPE=http
# Tells rclone what website its working with.
export RCLONE_CONFIG_ZZ_URL=$1

# arguments for the rclone package.
#  "--fast-list"  : "Use recursive list if available. Uses more memory but fewer transactions."
# --all             All files are listed (list . files too).
# --full-path       Print the full path prefix for each file.
# --noindent        Don't print indentation lines.
# --noreport        Turn off file/directory count at end of tree listing.
# --checkers int                        Number of checkers to run in parallel. (default 8)
# --output string   Output to file instead of stdout.
rloneARGS="--all --fast-list --full-path --noindent --noreport --checkers=4 --output="$HOME/files/$PROJECTFOLDER""

# Arguments for the GNU parallel package.
# "--link"        : "If multiple input sources are given, one argument will be read from each of the input sources."
# "--jobs=n"      : "Run n jobs in parallel."
# "--delay=n"     : "Delay the start of new jobs n amount of seconds."
# "--joblog="     : "Path to logfile of the jobs completed so far."
# "--shuf"        : "Shuffle order that jobs are ran."
# " :::: "        : "argfiles. Unlike other options for GNU parallel :::: is placed after the command and before the arguments."
parallelARGS="--link --jobs=4 --delay=3 --joblog=alexandria-parallel.log --shuf"

# Arguments for the axel package.
# "--output=x"    : "Data will be downloaded to this file or directory."
# "--no-clobber"    : "Skip download if a file with the same name already exists in the current folder and no state file is found."
axelARGS="--output="$HOME/files/$PROJECTFOLDER" --no-clobber"

mkdir -P "$HOME"/files/"$PROJECTFOLDER"
rclone tree zz: "$rloneARGS"
parallel "$parallelARGS" axel "$axelARGS" "$1"{} :::: "$URLS"
