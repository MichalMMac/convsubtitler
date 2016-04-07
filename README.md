# convsubtitler

iconv wrapper for batch subtitle encoding converstion

## Notes

`convsubtitler` atempts to convert supplied files from one encoding to another. You can supply files or directories as arguments. Directories are search for subtitle files using `find` with file extension as a filter.

Files are converted in place. If you want to retain original files, back them up before conversion or tweak `convsubtitler` script.

Use at your own risk.

## Usage
	
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