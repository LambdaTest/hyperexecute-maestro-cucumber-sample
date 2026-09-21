#!/bin/bash
# The test stage runs in a fresh shell, so the PATH exported by
# setup-android.sh's `pre`-stage process doesn't carry over here.
export PATH="$PATH:$HOME/.maestro/bin"

adb devices

FEATURE_FILE="$1"
REPORT_NAME=$(basename "$FEATURE_FILE" .feature)
TAGS_FILTER=""
if [ -n "$TAGS" ]; then
  TAGS_FILTER="--tags @${TAGS}"
fi

mkdir -p reports
npx cucumber-js --profile android $TAGS_FILTER --format "junit:reports/${REPORT_NAME}.xml" "$FEATURE_FILE"
