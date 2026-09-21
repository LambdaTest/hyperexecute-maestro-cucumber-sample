#!/bin/bash
# Discovers Gherkin feature files under features/ios/, one per HyperExecute test.
# Optionally scope to a single tag the way `cucumber-js --tags @smoke` would:
#   TAGS=smoke ./discover/ios.sh
if [ -n "$TAGS" ]; then
  find features/ios -name "*.feature" -exec grep -l "@${TAGS}\b" {} \; | sort
else
  find features/ios -name "*.feature" | sort
fi
