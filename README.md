# localizejs-github-action

A Github Actions integration for Localize.js; use it to push the primary string file for your project and to pull your translated files.

## Inputs

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
- SIMPLE_JSON
- XLIFF
- XML
- YAML
- YML

## `action`

**Required** The action to peform-- either 'push' or 'pull'

## `type`

The type of translation-- either 'phrase' or 'glossary'
Default: 'phrase'

## Example usage

```yml
uses: actions/localizejs-github-action@v1
  with:
    localize-api-key: 'api_key'
    localize-project-id: 'my-translated-project'
    action: 'pull'
```

## Full Publish Workflow

```yml
name: Localization - Publish strings
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
      - uses: sammcoe/localizejs-github-action@v1.0
        with:
          localize-api-key: ${{ secrets.LOCALIZE_API_KEY }}
          localize-project-id: [your-project-id]
          action: "push"
```

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
      - uses: sammcoe/localizejs-github-action@v1.0
        with:
          localize-api-key: ${{ secrets.LOCALIZE_API_KEY }}
          localize-project-id: [your-project-id]
          action: "pull"
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
