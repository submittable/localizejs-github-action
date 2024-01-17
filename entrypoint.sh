#!/bin/sh -l

API_KEY=$1
PROJECT_ID=$2
FORMAT=$3
ACTION=$4
TYPE=$5
LANGUAGES=$6
FILEPATHS=$7

LANGUAGES_ARR=$(echo $LANGUAGES | tr "," "\n")
FILEPATHS_ARR=$(echo $FILEPATHS | tr "," "\n")

mkdir ~/.localize
mkdir $GITHUB_WORKSPACE/translations/

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
    echo "  - $lang: $GITHUB_WORKSPACE/translations/$lang.json" >> ~/.localize/config.yml
  done
echo "push:
  sources:" >> ~/.localize/config.yml

for filepath in $FILEPATHS_ARR
do
  echo "  - file: $GITHUB_WORKSPACE/$filepath/en.json" >> ~/.localize/config.yml
done


if [ "$ACTION" = "push" ]; then
  localize push
  exit 0
elif [ "$ACTION" = "pull" ]; then
  localize pull
  exit 0
fi

exit 1
