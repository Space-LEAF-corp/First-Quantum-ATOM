#!/usr/bin/env bash
# Helper to dispatch the CI workflow manually using a PAT.
# Usage: PAT=xxx ./scripts/dispatch_workflow.sh container-diamond-carmon-lattice

set -euo pipefail
if [ -z "${1-}" ]; then
  echo "Usage: $0 <job-name>"
  exit 2
fi
JOB="$1"
if [ -z "${PAT-}" ]; then
  echo "Export PAT environment variable first: export PAT='<your_pat>'"
  exit 2
fi
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $PAT" \
  https://api.github.com/repos/Space-LEAF-corp/First-Quantum-ATOM/actions/workflows/ci.yml/dispatches \
  -d "{\"ref\":\"main\",\"inputs\":{\"job\":\"${JOB}\"}}"
