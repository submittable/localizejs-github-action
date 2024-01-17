#!/bin/sh -l

LANGUAGES=$1
INPUTPATH=$2
OUTPUTPATH=$3

LANGUAGES_ARR=$(echo $LANGUAGES | tr "," "\n")


for lang in $LANGUAGES_ARR
do
  objects=$(jq -r '.dictionary[] | "\"" + .phraseKey + "\"" + ":", "\"" + .translation[].value +"\"" + ","' $GITHUB_WORKSPACE/$INPUTPATH/$lang.json)
  trimmed=$(echo $objects | sed 's/.$//')
  mkdir $GITHUB_WORKSPACE/$OUTPUTPATH
  mkdir $GITHUB_WORKSPACE/$OUTPUTPATH/$lang
  echo '{' $trimmed '}' | jq -r '.' > $GITHUB_WORKSPACE/$OUTPUTPATH/$lang/translation.json
done
