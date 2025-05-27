# Github workflows for specmatic

## Usage

1. Enable dependabot and dependency graph in your project settings at `https://github.com/ORG/REPO/settings/security_analysis`
2. Create the following workflow(s)

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
         - uses: specmatic/specmatic-github-workflows/action-build-gradle@main
           with:
             gradle-extra-args: "-Pfoo=bar" # pass any extra gradle args here
   ```

## Scripts in the bin dir

1. For the fetch scripts, create a `~/.m2/settings.xml` file. Be sure to define `SPECMATIC_GITHUB_USER` and `SPECMATIC_GITHUB_TOKEN` in your shell.

   ```xml
   <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
       <profiles>
           <profile>
               <activation>
                 <activeByDefault>true</activeByDefault>
               </activation>
               <id>default</id>
               <repositories>
                   <repository>
                       <id>central</id>
                       <url>https://repo.maven.apache.org/maven2</url>
                   </repository>
                   <repository>
                       <id>confluent</id>
                       <url>https://packages.confluent.io/maven</url>
                   </repository>
                   <repository>
                       <id>specmaticPrivate</id>
                       <url>https://maven.pkg.github.com/specmatic/specmatic-private-maven-repo</url>
                   </repository>
               </repositories>
           </profile>
       </profiles>
       <servers>
           <server>
               <id>specmaticPrivate</id>
               <username>${env.SPECMATIC_GITHUB_USER}</username>
               <password>${env.SPECMATIC_GITHUB_TOKEN}</password>
           </server>
       </servers>
   </settings>
   ```
