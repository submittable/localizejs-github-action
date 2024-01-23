# localizejs-github-action

A Github Actions integration for Localize.js; use it to push the primary string file for your project and to pull your translated files.

## Inputs

## Input file
This action uses the LocalizeJS cli application which requires the input file to be named `language_code.json`. 

## `localize-api-key`

**Required** The Localize.js account API key

## `localize-project-id`

**Required** ID for the Localize.js project to translate

## `file-format`

The file format to use in all push and pull actions
Default: "SIMPLE_JSON"
Options:

- ANDROID_XML
- CSV
- GETTEXT_PO
- JSON
- IOS_STRINGS
- IOS_STRINGSDICT
- PO
- RESX
- SIMPLE_JSON (Works with i18next. Not supported by all project types.)
- XLIFF
- XML
- YAML
- YML

## `action`

**Required** The action to peform-- either 'push' or 'pull'

## `type`

The type of translation-- either 'phrase' or 'glossary'
Default: 'phrase'

## `langauges`

**Required** A comma separated list of desired langages. Langauges must first be enabled in the LocalizeJS project.

## `input-path`

**Required** The path to the input file. EG `AccountsFrontend/public/locales`. Path must be a folder containing a file named `en.json`

## `output-path`

**Required** The path to the desired output location. Should be a directory without the end slash. EG `AccountsFrontend/public/locales`

## `restructure-files`

If true output files will be moved and renamed to the file structure expected by i18next. EG `{output-path}/{language_code}/translations.json`

## Example usage

## Daily fetch workflow

```yml
name: Localization - Fetch strings
on:
  schedule:
    # * is a special character in YAML so you have to quote this string
    - cron: "0 0 * * *"
  workflow_dispatch:
jobs:
  fetch:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: submittable/localizejs-github-action/.github/actions/localize-push-pull@main
        with:
          localize-api-key: ${{ secrets.LOCALIZE_API_KEY }}
          localize-project-id: [your-project-id]
          file-format: "SIMPLE_JSON"
          action: "pull"
          languages: "fr,es,haw,am,de,ru,cs,el,he,hu,km-KH,ko,lo,pl,vi,zh,zh-TW,ar,bs,fr-CA,hi,id,it,ja,lt,pa,so,th,uk,pt,sr-LA,tl,ht,hmn"
          input-path: "[path to the directory containing your input file]" # directory must contain en.json
          output-path: "[desired output path]" # path to directory without end slash. EG: `account-name/strings`
          restructure-files: true
      - name: Get current date
        id: date
        run: echo "::set-output name=date::$(date +'%Y-%m-%d')"
      - uses: gr2m/create-or-update-pull-request-action@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          title: Localization string updates - ${{ steps.date.outputs.date }}
          body: Please review the updated string values, approve, and merge the PR.
          branch: localization-updates-${{ steps.date.outputs.date }}
          author: "github-actions[bot] <41898282+github-actions[bot]@users.noreply.github.com>"
          path: "strings/"
          commit-message: "Updating localized strings with new translations from Localize.js"
          labels: localization
```

## Example publish workflow

```yml
name: LocalizationPublishStrings
on:
  push:
    branches: [main]
  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:
jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: submittable/localizejs-github-action/.github/actions/localize-push-pull@main
        with:
          localize-api-key: ${{ secrets.LOCALIZE_API_KEY }}
          localize-project-id: [your-project-id]
          file-format: "SIMPLE_JSON"
          action: "push"
          languages: "fr,es,haw,am,de,ru,cs,el,he,hu,km-KH,ko,lo,pl,vi,zh,zh-TW,ar,bs,fr-CA,hi,id,it,ja,lt,pa,so,th,uk,pt,sr-LA,tl,ht,hmn"
          input-path: "AccountsFrontend/public/locales" #path used as example only. 
          output-path: "AccountsFrontend/public/locales" #path used as example only. 
```