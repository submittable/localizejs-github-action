#!/bin/sh -l

API_KEY=$1
PROJECT_ID=$2
FORMAT=$3
ACTION=$4
TYPE=$5

mkdir ~/.localize

echo "
api:
  project: $PROJECT_ID
  token: $API_KEY
format: $FORMAT
type: $TYPE
pull:
  targets:
  - tl: $GITHUB_WORKSPACE/strings/tl.json
  - zh-TW: $GITHUB_WORKSPACE/strings/zh-TW.json
  - zh: $GITHUB_WORKSPACE/strings/zh.json
  - ko: $GITHUB_WORKSPACE/strings/ko.json
  - vi: $GITHUB_WORKSPACE/strings/vi.json
  - en-GB: $GITHUB_WORKSPACE/strings/en-GB.json
  - ru: $GITHUB_WORKSPACE/strings/ru.json
  - bs: $GITHUB_WORKSPACE/strings/bs.json
  - hi: $GITHUB_WORKSPACE/strings/hi.json
  - ht: $GITHUB_WORKSPACE/strings/ht.json
  - id: $GITHUB_WORKSPACE/strings/id.json
  - th: $GITHUB_WORKSPACE/strings/th.json
  - de: $GITHUB_WORKSPACE/strings/de.json
  - es: $GITHUB_WORKSPACE/strings/es.json
  - ar: $GITHUB_WORKSPACE/strings/ar.json
  - pt: $GITHUB_WORKSPACE/strings/pt.json
  - ja: $GITHUB_WORKSPACE/strings/ja.json
  - fr: $GITHUB_WORKSPACE/strings/fr.json
  - fr-CA: $GITHUB_WORKSPACE/strings/fr-CA.json
  - haw: $GITHUB_WORKSPACE/strings/haw.json
  - am: $GITHUB_WORKSPACE/strings/am.json
  - hmn: $GITHUB_WORKSPACE/strings/hmn.json
  - pa: $GITHUB_WORKSPACE/strings/pa.json
push:
  sources:
  - file: $GITHUB_WORKSPACE/strings/en.json
" >> ~/.localize/config.yml

if [ "$ACTION" = "push" ]; then
  localize push
  exit 0
elif [ "$ACTION" = "pull" ]; then
  localize pull
  exit 0
fi

exit 1
