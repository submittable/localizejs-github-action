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
ALPHABETIZE=$10

LANGUAGES_ARR=$(echo $LANGUAGES | tr "," "\n")

mkdir ~/.localize
mkdir -p $GITHUB_WORKSPACE/$OUTPUTPATH

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

alphabetize_keys() {
  target_file="$1"
  echo "Sorting keys of $target_file"

  # sort in two steps to account for cosmic rays interrupting inline piped read
  sorted_json=$(jq --sort-keys '.' $target_file)
  echo "${sorted_json}" > $target_file
}

restructure_files() {
  for lang in $LANGUAGES_ARR
    do
      mkdir -p $GITHUB_WORKSPACE/$OUTPUTPATH/$lang
      mv $GITHUB_WORKSPACE/$OUTPUTPATH/$lang.json $GITHUB_WORKSPACE/$OUTPUTPATH/$lang/translations.json

      if [ "$ALPHABETIZE" = "true" ]; then
        alphabetize_keys $GITHUB_WORKSPACE/$OUTPUTPATH/$lang/translations.json
      fi
    done
  mkdir -p $GITHUB_WORKSPACE/$OUTPUTPATH/en
  cp -p $GITHUB_WORKSPACE/$OUTPUTPATH/en.json $GITHUB_WORKSPACE/$OUTPUTPATH/en/translations.json

  if [ "$ALPHABETIZE" = "true" ]; then
    alphabetize_keys $GITHUB_WORKSPACE/$OUTPUTPATH/en/translations.json
  fi
}

if [ "$ACTION" = "push" ]; then
  create_config
  localize push
  exit 0
elif [ "$ACTION" = "pull" ]; then
  create_config
  localize pull
  if [ "$INPUTPATH" != "$OUTPUTPATH" ]; then
    cp -p $GITHUB_WORKSPACE/$INPUTPATH/en.json $GITHUB_WORKSPACE/$OUTPUTPATH/en.json
  fi
  if [ "$RESTRUCTURE" = "true" ]; then
    restructure_files
  elif [ "$ALPHABETIZE" = "true" ]; then
    # alpha for non-restructured output
    for lang in $LANGUAGES_ARR; do
      alphabetize_keys $GITHUB_WORKSPACE/$OUTPUTPATH/$lang.json
    done
  fi
  exit 0
fi

exit 1
