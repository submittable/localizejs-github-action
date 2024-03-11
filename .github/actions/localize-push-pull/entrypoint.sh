#!/bin/sh -l

API_KEY=$1
PROJECT_ID=$2
FORMAT=$3
ACTION=$4
TYPE=$5
LANGUAGES=$6
INPUTPATH=$7
OUTPUTPATH=$8 # this should be a temp location.
RESTRUCTURE=$9

LANGUAGES_ARR=$(echo $LANGUAGES | tr "," "\n")

mkdir ~/.localize
mkdir $GITHUB_WORKSPACE/$OUTPUTPATH

create_config() {
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
}

restructure_files() {
  for lang in $LANGUAGES_ARR
    do
      mkdir $GITHUB_WORKSPACE/$OUTPUTPATH/$lang
      mv $GITHUB_WORKSPACE/$OUTPUTPATH/$lang.json $GITHUB_WORKSPACE/$OUTPUTPATH/$lang/translations.json
    done
    mkdir $GITHUB_WORKSPACE/$OUTPUTPATH/en
    cp $GITHUB_WORKSPACE/$OUTPUTPATH/en.json $GITHUB_WORKSPACE/$OUTPUTPATH/en/translations.json
}

if [ "$ACTION" = "push" ]; then
  create_config
  localize push
  exit 0
elif [ "$ACTION" = "pull" ]; then
  create_config
  localize pull
  cp $GITHUB_WORKSPACE/$INPUTPATH/en.json $GITHUB_WORKSPACE/$OUTPUTPATH/en.json
  if [ "$RESTRUCTURE" = "true" ]; then
    restructure_files
  fi
  exit 0
fi

exit 1
