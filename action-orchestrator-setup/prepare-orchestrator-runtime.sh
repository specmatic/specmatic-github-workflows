#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${ORCHESTRATOR_RUN_SUFFIX:-}" ]]; then
  exit 0
fi

echo "### Orchestrator" >> "$GITHUB_STEP_SUMMARY"
echo "Run: ${ORCHESTRATOR_RUN_SUFFIX}" >> "$GITHUB_STEP_SUMMARY"

mkdir -p "$HOME/.m2"
cat > "$HOME/.m2/settings.xml" <<'EOF'
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
    <profiles>
        <profile>
            <id>specmatic-snapshots</id>
            <repositories>
                <repository>
                    <id>central</id>
                    <url>https://repo1.maven.org/maven2</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </repository>
                <repository>
                    <id>specmatic-snapshots</id>
                    <url>https://central.sonatype.com/repository/maven-snapshots</url>
                    <releases>
                        <enabled>false</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
            </repositories>
            <pluginRepositories>
                <pluginRepository>
                    <id>central</id>
                    <url>https://repo1.maven.org/maven2</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </pluginRepository>
                <pluginRepository>
                    <id>specmatic-snapshots</id>
                    <url>https://central.sonatype.com/repository/maven-snapshots</url>
                    <releases>
                        <enabled>false</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </pluginRepository>
            </pluginRepositories>
        </profile>
    </profiles>
    <activeProfiles>
        <activeProfile>specmatic-snapshots</activeProfile>
    </activeProfiles>
</settings>
EOF

mkdir -p "$HOME/.gradle/init.d"
cat > "$HOME/.gradle/init.d/specmatic-snapshots.init.gradle" <<'EOF'
allprojects {
    repositories {
        maven {
            url = uri("https://central.sonatype.com/repository/maven-snapshots")
            mavenContent {
                snapshotsOnly()
            }
        }
    }
}
EOF

if [[ -n "${DOCKER_HUB_USERNAME:-}" && -n "${DOCKER_HUB_TOKEN:-}" ]]; then
  echo "${DOCKER_HUB_TOKEN}" | docker login -u "${DOCKER_HUB_USERNAME}" --password-stdin
fi

docker pull specmatic/enterprise-snapshot
docker tag specmatic/enterprise-snapshot specmatic/enterprise:latest
