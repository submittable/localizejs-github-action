#!/bin/sh -l

API_KEY=$1
PROJECT_ID=$2
FORMAT=$3
ACTION=$4
TYPE=$5
LANGUAGES=$6
INPUTPATH=$7
OUTPUTPATH=$8 # this should be a temp location.

LANGUAGES_ARR=$(echo $LANGUAGES | tr "," "\n")

mkdir ~/.localize
mkdir $GITHUB_WORKSPACE/$OUTPUTPATH

echo "
api:
  project: $PROJECT_ID
  token: $API_KEY
format: $FORMAT
type: $TYPE
pull:
  targets:" >> ~/.localize/config.yml
for lang in $LANGUAGES_ARR
  do
    echo "  - $lang: $GITHUB_WORKSPACE/$OUTPUTPATH/$lang.json" >> ~/.localize/config.yml
  done
echo "push:
  sources:" >> ~/.localize/config.yml

echo "  - file: $GITHUB_WORKSPACE/$INPUTPATH/en.json" >> ~/.localize/config.yml


if [ "$ACTION" = "push" ]; then
  localize push
  exit 0
elif [ "$ACTION" = "pull" ]; then
  localize pull
  cp $GITHUB_WORKSPACE/$INPUTPATH/en.json $GITHUB_WORKSPACE/$OUTPUTPATH/en.json
  exit 0
fi

exit 1
