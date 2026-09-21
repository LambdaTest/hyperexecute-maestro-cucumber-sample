#!/bin/bash
# Discovers Gherkin feature files under features/android/, one per HyperExecute test.
# Optionally scope to a single tag the way `cucumber-js --tags @smoke` would:
#   TAGS=smoke ./discover/android.sh
if [ -n "$TAGS" ]; then
  find features/android -name "*.feature" -exec grep -l "@${TAGS}\b" {} \; | sort
else
  find features/android -name "*.feature" | sort
fi
