adamsAppleDir=$codeDir/AdamsApple
colorizeLocation=$adamsAppleDir/shell/colorize/colorize.py
ccdLocation=$adamsAppleDir/shell/ccd/ccd.py
relocateHomepagerizerLocation=$adamsAppleDir/shell/relocate_homepagerizer_homepage/main.py
extSsdLocation=/Volumes/inland
codeDir=$extSsdLocation/code

# Use colors for 'ls'
export CLICOLOR=1

# Specify which 'ls' colors to use
export LSCOLORS=ExFxBxDxCxegedabagacad

# Set default editors
export EDITOR=vim
export VISUAL="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"

################################################################################
# "Private" variables - don't touch these.
################################################################################
# Thu 10/02/2014 - 04:51 PM
# If true, calls to 'log' will visibly log the text.
loggerEnabled=true

# Tue 03/03/2015 - 10:37 AM
# This is used in enabling silent functions. See pushLogSetting for details.
loggerStack=()
################################################################################

# Tue 03/24/2015 - 02:37 PM
# Ensures a path is in your PATH variable, that way you can source your Bash
# profile multiple times without appending the same directories to your PATH
# like you'd be doing if you did export PATH="$PATH:~/tools"
#
# Code taken from:
# http://denihow.com/add-directory-to-path-if-its-not-already-there/
function ensureInPath() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$PATH:$1"
    fi
}

# Fri 10/01/2021 - 04:22 PM - mkdir and cd into it in one command. The name of
# the function is the name of the person who told me to make this command. :)
function lepko() {
    mkdir $1 && cd $1
}

# Change the prompt to show the current directory
# E.g. "~/foo/bar>"
# See "man zshmisc" for more information.
# https://stackoverflow.com/a/2534676
function setPromptColor() {
    autoload -U colors && colors

    # Prompt with a regular text color:
    PS1="🍎 %{%F{69}%}%2~%{$reset_color%}%{$fg[cyan]%}>%{$reset_color%}"
}

setPromptColor

# Typos
alias Cd='cd'
alias cD='cd'
alias CD='cd'
alias dir='ls'
alias copy='cp'
alias start='open' # "start ." is what you'd type on Windows for "open ." on Unix

# Shortcuts
alias s='$VISUAL'
alias k='kubectl'
alias rgi='rg -i'
alias bat='bat --theme=OneHalfDark' # https://github.com/sharkdp/bat
alias cat='bat --paging=never --style=plain' # use bat in non-interactive mode and with no line numbers

# Alias ps (thanks, HiDeoo!).
alias psa='ps aux'
alias psg='ps aux | grep -i'

# Alias ls
alias lsg='ls | grep -i'

# Misc. aliases
alias diffLastCommit='lastCommitDiff'

# Tue 11/24/2020 - 08:41 AM
# Heck if I'm ever going to remember this.
# @see http://data.agaric.com/get-git-diff-previous-commit
function lastCommitDiff() {
    colorize "^gDiffing last commit"
    git diff HEAD^ HEAD
}

# Tue 11/24/2020 - 08:43 AM
# @see https://stackoverflow.com/a/2232490
function lastCommitStatus() {
    colorize "^gShowing status of last commit"
    git log --name-status HEAD^..HEAD
}

# Tue 07/15/2014 - 05:35 PM
# Simple shortcut to edit this file (I wrote this long before I switched
# to zsh).
function editbash() {
    colorize "^gEditing ~/.zshrc"
    s ~/.zshrc
}

# Tue 07/15/2014 - 05:35 PM
# Simple shortcut to source this file.
function sourcebash() {
    colorize "Doing ^gsource ~/.zshrc"
    source ~/.zshrc
}

# Tue 02/22/2022 - 01:54 PM
# Import something like "homepage (12).html" to be my index.html
function updateHomepage() {
    python3 "$relocateHomepagerizerLocation"
}

# Tue 07/15/2014 - 06:36 PM
# Thin wrapper around Colorize.
function colorize() {
    python3 $colorizeLocation "$@"
}

# Tue 11/24/2020 - 03:36 PM
# Print time in UTC
function utc() {
    colorize "LOCAL: ^y$(date)"
    colorize "UTC  : ^g$(date -u)"
}

function ffgit() {
    git ls-files | grep -i $1
}

# Tue 11/24/2020 - 04:18 PM
# Just a reminder on how to revert.
function gitRevert() {
    colorize "Usage: git revert ^gCOMMIT_HASH ^=(look at ^ggit log^= for the hash)"
}

# Thu 07/10/2014 - 06:05 PM
# "Find file" - searches recursively for a file whose name you pass.
# It doesn't take long to type this command out manually, but I always
# seem to forget the command.
#
# Most of the time, you'll need to call this with quotation marks, so you should
# do it all the time. The times you don't need it are when the pattern you're
# searching for doesn't appear in the currently directory.
#
# Examples:
# ff "*Phone*"
# ff "something with spaces.txt"
function ff() {
    if [[ "$1" == "" ]]; then
        colorize "^rUsage: ff <file to find>"
        colorize "Does a case-sensitive recursive search for <file to find>."
        return
    fi

    ffCommon "$1" false
}

# Thu 02/17/2022 - 01:11 PM
# Thin wrapper around `ff` to search for particular file types since zsh would
# otherwise require quotation marks, which are annoying to type.
function fftype() {
    if [[ "$1" == "" ]]; then
        colorize "^rUsage: fftype <file type to find>, e.g. fftype py"
        return
    fi

    ff "*.$1"
}

# Thu 10/02/2014 - 07:20 PM
# Same as 'ff' but case-insensitive.
function ffi() {
    if [[ "$1" == "" ]]; then
        colorize "^rUsage: ffi <file to find>"
        colorize "Does a case-insensitive recursive search for <file to find>."

        return
    fi

    ffCommon "$1" true
}

# Thu 10/02/2014 - 07:38 PM
# [private function] - do not call this directly
# Used by ff and ffi.
function ffCommon() {
    local fileName=$1
    local caseInsensitive=$2
    local nameArg=-name

    if [[ "$fileName" == "" ]]; then
        colorize "^rYou should not call this function directly."
        return
    fi

    if [[ $caseInsensitive == true ]]; then
        nameArg=-iname
    fi

    colorize "Finding file(s): find . $nameArg \"^g$1^w\""
    find . $nameArg "$fileName"
}

# Thu 07/10/2014 - 06:06 PM
# "Find string in file" - searches all files recursively for the string that
# you've passed in.
#
# Arg1: the string to search for. The user can choose to provide quotes if they want.
# Arg2: the file types to include in the search.
#
# E.g.
# fs "string with spaces"
# fs foo *.txt
# fs "a single backslash \\\\ looks like that"   (you need to escape the backslash once for Bash and once for regex)
function fs() {
    if [[ "$1" == "" ]]; then
        colorize "^rUsage: fs <string to find in files> [files to match]"
        colorize "Does a case-sensitive recursive search for <string> in files."
        return
    fi

    fsCommon "$1" "" "$2"
}

# Mon 08/11/2014 - 12:59 PM
# [private function] - do not call this directly
# Implementation for fs and fsi.
#
# Arg1: the string to find
# Arg2: any additional arguments to "find", e.g. -i. Pass " " if you don't want to specify this argument.
# Arg3 (optional): if present, only files of this type will be searched.
function fsCommon() {
    local searchString=$1
    local addlArgs=$2
    local include=$3

    if [[ "$searchString" == "" ]]; then
        colorize "^rYou should not call this function directly."
        return
    fi

    local addlArgsStr=
    if [[ -n $addlArgs ]]; then
        addlArgsStr="^w(additional args: ^g$addlArgs^w)"
    fi

    if [[ -n "$include" ]]; then
        colorize "Searching for ^g$searchString^w in files matching ^g$include $addlArgsStr"
        if [[ -f $include || -d $include ]]; then
            colorize "^yWarning: ^r\"$include\"^y exists in the current directory, which likely means you passed something like *.txt to this function, and bash automatically converted it into an existing path. To fix this, surround the argument in double quotes."
        fi
        grep $addlArgs -r -n "$searchString" ./ --include=$include
    else
        colorize "Searching for the string ^g$searchString^w in files $addlArgsStr"
        grep $addlArgs -r -n "$searchString" ./
    fi
}

# Mon 08/04/2014 - 04:25 PM
# Same as 'fs' ("find string") but fsi is case-insensitive.
function fsi() {
    if [[ "$1" == "" ]]; then
        colorize "^rUsage: fsi <string to find in files> [files to match]"
        colorize "Does a case-insensitive recursive search for <string> in files."
        return
    fi

    fsCommon "$1" -i "$2"
}

# Mon 08/11/2014 - 12:16 PM
# Find directory recursively
function fd() {
    if [[ "$1" == "" ]]; then
        colorize "^rUsage: fd <directory name>"
        colorize "This function finds directories recursively."
        return
    fi

    colorize "Searching for the directory ^g$1 ^w(case-insensitive)"
    find ./ -iname "$1" -type d
}

# Mon 07/14/2014 - 05:19 PM
# Copies the current directory to the clipboard.
function getcd() {
    pwd | tr -d '\n' | pbcopy
    colorize "^wCopied ^g${PWD} ^wto the clipboard"
}

# Thu 10/02/2014 - 04:48 PM
# Logs the given text using colorize. This is intended for use by other
# functions in this file so that `loggerEnabled` can be respected.
function log() {
    if [[ $loggerEnabled == true ]]; then
        colorize $@
    fi
}

# Thu 10/02/2014 - 04:48 PM
# Turns logging off
function turnLogOff() {
    loggerEnabled=false
}

# Thu 10/02/2014 - 04:48 PM
# Turns logging on
function turnLogOn() {
    loggerEnabled=true
}

# Tue 03/03/2015 - 10:36 AM
# It doesn't make sense to intrument every function with a "silent" option, so
# instead you're now able to push/pop the current log setting. If you want a
# silent function, you should do this:
#  pushLogSetting
#  turnLogOff
#  <perform any actions>
#  popLogSetting
function pushLogSetting() {
    loggerStack=("$loggerEnabled" "${loggerStack[@]}")
}

# Tue 03/03/2015 - 10:37 AM
# Corresponding 'pop' function for the log setting.
function popLogSetting() {
    if [[ ${#loggerStack} -eq 0 ]]; then
        return
    fi

    local top
    top=${loggerStack[${#loggerStack}-1]}

    # Remove the first element now
    loggerStack=("${loggerStack[@]:1}")
    loggerEnabled=$top
}

# Allow for quick navigation of your filesystem.
# Example usage:
# ccd ~ Co sr stu
# This would move you to the folder ~/Code/src/stuff because it's translated as:
# cd ~
# cd Co
# cd Co*  (this is tried because "Co" doesn't exist)
# cd sr
# cd sr*
# etc.
#
# Other features:
# * "..." and "...." can be used to go up multiple directories at a time.
# * If your directory can't be found, this will fall back to case-insensitivity.
function ccd() {
    # This can't be a local variable or else the error code is always 0
    output=$(python3 $ccdLocation "$@")
    local errcode=$?
    if [ $errcode -eq 0 ]; then
        colorize "→ ^g$output"
        cd $output
    else
        colorize "^rFailed: ^=$output"
    fi
}

# Tue 08/26/2014 - 06:04 PM
# Read the 'usage' below to find out WHAT this does, but as for WHY:
# I found that I copy file paths from finder or from other command output and
# then I want to be in the directory of that file. This function allows me to be
# there without having to delete the filename off of the path.
function cdo() {
    if [[ "$1" == "" ]]; then
        colorize "^rUsage: cdo <path>"
        colorize "This does a 'cd' on <path> if it's a directory, but when it's a file, it will do a 'cd' on the file's parent path."
        return
    fi

    if [[ -d "$1" ]]; then
        cd "$1"
    else
        local directory=`dirname "$1"`
        colorize "Switching into ^g$directory"
        cd "$directory"
    fi
}

# These functions make use of "ccd" so that you can do something like
# "home Lib Appl Goo" to get to "~/Library/Application Support/Google"
function home() {
    cd ~
    ccd "$@"
}
function temp() {
    cd ~/tmp
    ccd "$@"
}
function tmp() {
    cd ~/tmp
    ccd "$@"
}
function code() {
    cd $extSsdLocation/code
    ccd "$@"
}
function desktop() {
    cd ~/Desktop
    ccd "$@"
}
function ext() {
    cd $extSsdLocation
    ccd "$@"
}

function parse_git_branch() {
  git branch --show-current 2>/dev/null|sed 's/^/ (/;s/$/)/'
}
function parse_git_left() {
  git rev-list --left-only --count @{u}... 2>/dev/null|sed '/^0/d;s/^/ -/'
}
function parse_git_right() {
  git rev-list --right-only --count @{u}... 2>/dev/null|sed '/^0/d;s/^/ +/'
}

# Wed 07/30/2014 - 11:48 AM
# This changes the tab title of iTerm.
# Usage: title any number of args for the title
# E.g. title Code Tab
#
# If you don't provide an argument then it will attempt to pull the name
# of your directory name. Failing that, it'll revert to "(bash)", which
# is as close to the default "bash" as I can get.
function title() {
    local finalTitle=$@
    local output=

    if [ -z "$1" ]; then
        finalTitle=`basename ${PWD}`
        output="Setting tab title to the current dir name: ^g$finalTitle"
    else
        output="Setting tab title to ^g$finalTitle"
    fi

    colorize $output
    tabColorBasedOnString $finalTitle

    echo -n -e "\033]0;$finalTitle\007"
}

# Thu 10/02/2014 - 06:26 PM
# This is an iTerm-specific feature that will color the tab title based on
# a string that you pass in.
#
# Results are deterministic; the same input to this function will always give
# the same output.
function tabColorBasedOnString() {
    pushLogSetting
    turnLogOff

    # Put the string through an md5 hash.
    local hash=`md5 <<< $1`
    hash=`md5 <<< $hash`
    hash=`md5 <<< $hash`
    hash=`md5 <<< $hash`
    hash=`md5 <<< $hash`

    # Take four characters for each color component.
    local r=${hash:0:4}
    local g=${hash:4:4}
    local b=${hash:6:4}

    # Capitalize the characters since 'bc' requires capitalized hex numberes.
    r=$(tr '[a-z]' '[A-Z]' <<< "$r")

    # 'bc' is a base conversion program; we go from hex to decimal here.
    r=`bc<<<"ibase=16; $r"`

    # Do the same process for green and blue.
    g=$(tr '[a-z]' '[A-Z]' <<< "$g")
    g=`bc<<<"ibase=16; $g"`
    b=$(tr '[a-z]' '[A-Z]' <<< "$b")
    b=`bc<<<"ibase=16; $b"`

    ((r=(r%32)))
    ((g=(g%32)))
    ((b=(b%32)))

    # Make sure the rgb values sum to at least a certain number
    local threshold=300
    local sum=
    ((sum=$r+$g+$b))
    ((numCycles=0))
    while [[ $sum -lt $threshold ]]; do
        # I want the numbers to grow in such a way that the biggest number stays
        # proportionally larger to the others, that way you get more vibrant
        # colors.
        ((r=$r*14/10))
        ((g=$g*14/10))
        ((b=$b*14/10))

        # Some strings will hash to RGB values like [0,7,0] (e.g. "Hi"), which
        # means the colors will never exceed the threshold. When this happens,
        # we artificially increase the numbers.
        ((numCycles=$numCycles+1))
        if [[ $numCycles -gt 16 ]]; then
            ((r=$r+1))
            ((g=$g+1))
            ((b=$b+1))
        fi

        if [[ $r -gt 255 ]]; then r=255; fi
        if [[ $g -gt 255 ]]; then g=255; fi
        if [[ $b -gt 255 ]]; then b=255; fi

        ((sum=$r+$g+$b))
    done
    tabColor $r $g $b
    popLogSetting
}

# Thu 10/02/2014 - 03:42 PM
# In iTerm, you can change the color of tabs. This function lets you do that
# with either an RGB value or with a word (e.g. "red").
function tabColor() {
    if [[ "$1" == "" ]]; then
        colorize "^rUsage: tabColor r g b"
        colorize "Alternatively, you can do tabColor [red|blue|green|...|default]"
        colorize "This is an iTerm-specific command to set the tab color."
        return
    fi

    local r=$1
    local g=$2
    local b=$3

    if [[ "$2" == "" ]]; then
        local colorToLower=$(tr '[A-Z]' '[a-z]' <<< "$r")
        # Should really just use an associative array here...
        if [[ "$colorToLower" == "red" ]]; then r=255; g=0; b=0;
        elif [[ "$colorToLower" == "blue" ]]; then r=0; g=0; b=255;
        elif [[ "$colorToLower" == "green" ]]; then r=0; g=255; b=0;
        elif [[ "$colorToLower" == "pink" ]]; then r=255; g=0; b=255;
        elif [[ "$colorToLower" == "purple" ]]; then r=128; g=64; b=128;
        elif [[ "$colorToLower" == "yellow" ]]; then r=255; g=255; b=0;
        elif [[ "$colorToLower" == "orange" ]]; then r=255; g=128; b=0;
        elif [[ "$colorToLower" == "cyan" ]]; then r=0; g=255; b=255;
        elif [[ "$colorToLower" == "white" ]]; then r=255; g=255; b=255;
        elif [[ "$colorToLower" == "black" ]]; then r=0; g=0; b=0;
        elif [[ "$colorToLower" == "default" ]]; then
            # Reset to default
            echo -e -n "\033]6;1;bg;*;default\a"
            return
        else
            log "^rColor not recognized: ^w$colorToLower"
            return
        fi
    fi

    echo -e -n "\033]6;1;bg;red;brightness;${r}\a"
    echo -e -n "\033]6;1;bg;green;brightness;${g}\a"
    echo -e -n "\033]6;1;bg;blue;brightness;${b}\a"

    log "Changing tab color to (^r${r}^w,^g${g}^w,^c${b}^w) (this only works in iTerm)."
}

# Activate Chrome
function c() {
    colorize "^gActivating Chrome"
    osascript -e 'tell application "Chrome" to activate'
}

# Fri 07/11/2014 - 06:15 PM
# This is just for if "colorize.py" doesn't exist.
# First arg: foreground color
# Second arg: background color
# Third arg: text to write (no need for newline)
#
# Colors:
# 0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=pink, 6=cyan, 7=white
#
# e.g. colorizeSimple 5 3 "this \n is \n very \n noisy \n text"
function colorizeSimple() {
    printf "\033[3${1};4${2}m${3}\033[0m\n"
}

# Make sure colorize exists.
if [[ ! -f $colorizeLocation ]]; then
    colorizeSimple 1 0 "You do not have colorize.py (or the path you have in your bash_profile is wrong)."
    colorizeSimple 1 0 "Type 'editbash' and fix it by setting colorizeLocation correctly."
fi

# Thu 03/25/2021 - 08:30 AM - this is just an example of how to prompt in ZSH
# It waits for you to press a single key without even having to hit enter.
# It doesn't work in Bash.
# See https://stackoverflow.com/a/61353538
function testprompt() {
    if read -q "choice?Proceed (y/n)? "; then
        echo "\nYou chose YES."
    else
        echo "\nYou chose NO (typed '$choice')"
    fi
}

# Fri 02/03/2023 - 10:31 AM
function weather() {
    # See https://wttr.in/:help
    # "u" forces Fahrenheit.
    # "F" removes the "follow on Twitter" thing at the end
    curl "wttr.in/seattle?u&F"
}

# Tue 06/06/2023 - macOS "find" but excludes directories.
function findf() {
    local searchPath=$1

    if [[ "$1" == "" ]]; then
        searchPath=.
    fi

    find $searchPath -type f
}

source ~/.zsh/plugins_after.zsh

# Tue 10/12/2021 - 07:46 AM
# https://iterm2.com/documentation-shell-integration.html
# At the very least, this gives ⌘⇧↑ and ⌘⇧↓ for navigating between the
# last commands you've typed.
source ~/.iterm2_shell_integration.zsh
