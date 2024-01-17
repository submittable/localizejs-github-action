#!/bin/sh -l

LANGUAGES=$1
INPUTPATH=$2
OUTPUTPATH=$3

LANGUAGES_ARR=$(echo $LANGUAGES | tr "," "\n")


for lang in $LANGUAGES_ARR
do
  objects=$(jq -r '.dictionary[] | "\"" + .phraseKey + "\"" + ":", "\"" + .translation[].value +"\"" + ","' $INPUTPATH/$lang.json)
  trimmed=$(echo $objects | sed 's/.$//')
  mkdir $OUTPUTPATH
  mkdir $OUTPUTPATH/$lang
  echo '{' $trimmed '}' | jq -r '.' > $OUTPUTPATH/$lang/translation.json
done
