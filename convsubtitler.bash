#!/bin/bash
# Author: MichalM.Mac

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Config defaults

ENCODING_FROM='CP1250'
ENCODING_TO='UTF-8'
SUB_EXTENSION='.srt'
SILENT='false'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_error() {
  echo "$@" 1>&2;
}

function usage() {
cat <<EOF

  convsubtitler: Converts subtitle files to different encoding using iconv

  convsubtitler.bash [ -s ] [ -s ENCODING_FROM ] [ -t ENCODING_TO ] [ -e SUB_EXTENSION ] file|directory...

  -h  
    Show this help.
    
  -s 
    Silent mode. Do not print any output related to subtitle conversion.
    
  -f ENCODING_FROM
    Current subtitle encoding. See man iconv_open for list of valid encodings.
    Default is 'CP1250'.

  -t ENCODING_TO
    Subtitle files will be converted to this encoding. See man iconv_open for list of valid encodings.
    Default is 'UTF-8'.
    
  -e SUB_EXTENSION
    File extension of subtitle files to be found when searching directory provided as an argument.
    Default is '.srt'.
    
EOF
}

function parse_opts() {
  while getopts "hf:t:se:" opt; do
    case $opt in
      h)
        usage
        exit 0
        ;;
      f)
        ENCODING_FROM="${OPTARG%/}"
        ;;
      t)
        ENCODING_TO="${OPTARG%/}"
        ;;
      s)
        SILENT="true"
        ;;
      \?)
        print_error "Invalid option: -$OPTARG"
        quit
        ;;
      :)
        print_error "Option -$OPTARG requires an argument."
        exit 1
        ;;
    esac
  done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

convert_sub_encoding(){
  if file --mime-encoding "$1"  | grep -iq "$ENCODING_TO"; then
    [ "$SILENT" == "true" ] ||
      print_error "Error: File $1 is alredy encoded in $ENCODING_TO"
  else
    mv "$1" "${1}_temp"
    iconv -f "$ENCODING_FROM" -t "$ENCODING_TO" "${1}_temp" > "$1" && rm "${1}_temp" 
    [ "$SILENT" == "true" ] ||
      echo "Converted file $1 encoding from ${ENCODING_FROM} to ${ENCODING_TO}"
  fi
}

find_subs(){
  find "$1" -name "*${SUB_EXTENSION}" | 
    while read file; do 
      convert_sub_encoding "$file"
    done 
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function main() {
  
  # Process input
  parse_opts "$@"
  shift "$((OPTIND-1))"
  
  if [ $# -eq 0 ]; then
    echo "Error: No Aruments specified -> Nothing to do."  
  fi     
 
  # Convert subtitle files
  while [ $# -gt 0 ]
  do
    if [ -d "$1" ]; then
      find_subs "$1"
    elif [ -f "$1" ]; then
      convert_sub_encoding "$1"
    else
      print_error "Error: $1 is not valid file or directory"  
    fi
       
    shift
  done
  }
main "$@"