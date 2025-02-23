# Gradle workflows for specmatic

## Usage


1. Copy `dependabot.gradle` to your repository
2. Add a `version` property in `gradle.properties` in the repository. Be sure to add the `-SNAPSHOT` suffix, since the release has not been cut, yet.

  ```properties
  # gradle.properties
  version=1.2.3-SNAPSHOT
  ```

3. Create the following github workflow `.github/workflows/gradle.yml`

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

4. Enable dependabot and dependency graph in your project settings at `https://github.com/ORG/REPO/settings/security_analysis`
