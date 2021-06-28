# localizejs-github-action

A Github Actions integration for Localize.js

## Inputs

## `localize-api-key`

**Required** The Localize.js account API key

## `localize-project-id`

**Required** ID for the Localize.js project to translate

## `file-format`

The file format to use in all push and pull actions
Default: "json"

## `action`

**Required** The action to peform-- either push or pull

## `type`

The type of translation-- either phrase or glossary
Default: "phrase"

## Example usage

uses: actions/localizejs-github-action@v1
  with:
    localize-api-key: 'api_key'
    localize-project-id: 'my-translated-project'
    action: 'pull'
