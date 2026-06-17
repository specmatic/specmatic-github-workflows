#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${ORCHESTRATOR_RUN_SUFFIX:-}" ]]; then
  exit 0
fi

echo "### Orchestrator" >> "$GITHUB_STEP_SUMMARY"
echo "Run: ${ORCHESTRATOR_RUN_SUFFIX}" >> "$GITHUB_STEP_SUMMARY"

if [[ ! "${ENTERPRISE_VERSION:-}" =~ -SNAPSHOT$ ]]; then
  exit 0
fi

if [[ -n "${GRADLE_SNAPSHOT_INIT_SCRIPT_PATH:-}" ]]; then
  mkdir -p "$HOME/.gradle/init.d"
  cp "${GRADLE_SNAPSHOT_INIT_SCRIPT_PATH}" "$HOME/.gradle/init.d/specmatic-snapshots.init.gradle"
fi

if [[ "${SETUP_SNAPSHOT_DOCKER_IMAGE:-false}" == "true" ]]; then
  if [[ -n "${DOCKER_HUB_USERNAME:-}" && -n "${DOCKER_HUB_TOKEN:-}" ]]; then
    echo "${DOCKER_HUB_TOKEN}" | docker login -u "${DOCKER_HUB_USERNAME}" --password-stdin
  fi

  docker pull specmatic/enterprise-snapshot
  docker tag specmatic/enterprise-snapshot specmatic/enterprise:latest
fi
