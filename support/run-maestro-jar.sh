#!/bin/bash
# Thin wrapper so step_definitions/support/maestro.js can invoke the jar-based
# Maestro (used for iOS real devices) the same way it invokes the `maestro` CLI.
exec java -jar ./maestro.jar "$@"
