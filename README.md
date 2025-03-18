# Github workflows for specmatic

## Usage

1. Enable dependabot and dependency graph in your project settings at `https://github.com/ORG/REPO/settings/security_analysis`
2. Copy `.github/dependabot.yml` to your repository
3. Add a `version` property in `gradle.properties` in the repository. Be sure to add the `-SNAPSHOT` suffix, since the release has not been cut, yet.
4. Add a `group` property in `gradle.properties` in the repository. Use the pattern `io.specmatic.<modulename>`.
   ```properties
   # gradle.properties
   version=1.2.3-SNAPSHOT
   group=io.specmatic.fluxcapacitor
   ```
5. Create the following workflow(s)

   1. Basic build/test using java 17 and `./gradlew check assemble`

   ```yaml
   # .github/workflows/gradle.yml
   name: Java Build with Gradle

   on:
     push:
       branches: ["main"]
     pull_request:
       branches: ["main"]

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
