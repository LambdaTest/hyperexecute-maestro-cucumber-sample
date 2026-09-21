#!/bin/bash
# MAESTRO_BIN is set to ./support/run-maestro-jar.sh by yaml/ios/ios-realdevice.yaml's
# `env:` block, so the same step definitions shell out to the downloaded maestro.jar
# instead of the `maestro` CLI used by the simulator profile.

FEATURE_FILE="$1"
REPORT_NAME=$(basename "$FEATURE_FILE" .feature)
TAGS_FILTER=""
if [ -n "$TAGS" ]; then
  TAGS_FILTER="--tags @${TAGS}"
fi

mkdir -p reports
npx cucumber-js --profile ios $TAGS_FILTER --format "junit:reports/${REPORT_NAME}.xml" "$FEATURE_FILE"
