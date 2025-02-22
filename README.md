# Gradle workflows for specmatic

## Usage


1. Add a `version` property in `gradle.properties` in the repository

  ```properties
  # gradle.properties
  version=1.2.3-SNAPSHOT
  ```

2. Create the following github workflow `.github/workflows/gradle.yml`

  ```yaml
  name: Java Build with Gradle

  on:
    push:
      branches: [ "main" ]
    pull_request:
      branches: [ "main" ]

  jobs:
    build:
      runs-on: ubuntu-latest
      permissions:
        contents: write # This is required so that the dependency check can push dependency graph to the github repository
      steps:
        - uses: znsio/specmatic-github-workflows/action-build-gradle@main
          with:
            gradle-extra-args: "-Pfoo=bar" # pass any extra gradle args here
  ```
