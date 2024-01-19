#!/bin/sh -l

LANGUAGES=$1
INPUTPATH=$2 # this should be a temp location created by previous script. Remove before exit. 
OUTPUTPATH=$3

LANGUAGES_ARR=$(echo $LANGUAGES | tr "," "\n")


for lang in $LANGUAGES_ARR
do
  mkdir $GITHUB_WORKSPACE/$OUTPUTPATH
  mkdir $GITHUB_WORKSPACE/$OUTPUTPATH/$lang
  mv $GITHUB_WORKSPACE/$INPUTPATH/$lang.json $GITHUB_WORKSPACE/$OUTPUTPATH/translation.json
done

rm -rf $INPUTPATH