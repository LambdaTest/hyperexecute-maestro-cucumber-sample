const { execFileSync } = require('child_process');
const path = require('path');

// Runs a single Maestro flow file and lets it throw (failing the Cucumber
// step) if the underlying assertion/action fails. Flows don't re-launch the
// app unless they explicitly call `launchApp`, so state carries across steps
// within one scenario the same way it would across `maestro test` calls in
// the same device session.
function runFlow(relativeFlowPath) {
  const flowPath = path.join(__dirname, '..', '..', 'flows', relativeFlowPath);
  const maestroBin = process.env.MAESTRO_BIN || 'maestro';
  execFileSync(maestroBin, ['test', flowPath, '--format', 'junit', '--debug-output', './MaestroLogs'], {
    stdio: 'inherit',
  });
}

module.exports = { runFlow };
