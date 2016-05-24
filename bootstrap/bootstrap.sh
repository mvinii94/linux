#!/bin/bash
GREEN='\e[0;32m'
RED='\e[1;31m'
YELLOW='\e[33m'
BLUE='\e[34m'
END='\e[0m' 
DONE=$(echo -e "[ ${GREEN}DONE${END} ]")
ERROR=$(echo -e "[ ${RED}ERROR${END} ]")
WARNING=$(echo -e "[ ${YELLOW}WARNING${END} ]")
DATE=$(date +"%H:%M:%S %d-%m-%Y")

######## Functions ###########
function LOG(){
  echo -e "[${DATE}] - ${1}" 
}

function HEADER(){
 echo -e "${BLUE}##############################################################################################${END}"
 echo -e "${BLUE}# ${1}"
 echo -e "${BLUE}##############################################################################################${END}"
}

EXTRACT () {
   if [ -f $1 ] ; then
       case $1 in
        *.tar.bz2)      tar xvjf $1 ;;
        *.tar.gz)       tar xvzf $1 ;;
        *.tar.xz)       tar Jxvf $1 ;;
        *.bz2)          bunzip2 $1 ;;
        *.rar)          unrar x $1 ;;
        *.gz)           gunzip $1 ;;
        *.tar)          tar xvf $1 ;;
        *.tbz2)         tar xvjf $1 ;;
        *.tgz)          tar xvzf $1 ;;
        *.zip)          unzip $1 ;;
        *.Z)            uncompress $1 ;;
        *.7z)           7z x $1 ;;
        *)              echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}

#USAGE:
#HEADER "testando o site"
#LOG "${DONE}"
#LOG "${ERROR} - deploy error"
#echo "[${DATE}]"
#echo "${DONE}"
#echo "${WARNING}"
#echo "${ERROR}"
