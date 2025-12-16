# Running CI Jobs and Secure Dispatch Guide

This guide explains how to run the CI jobs (including container and self-hosted variants) safely and how to provide temporary credentials if required.

## Jobs you can run
- build (matrix: Python 3.9, 3.10, 3.11)
- container-emerald
- container-spaceforge
- container-diamond-carmon-lattice
- self-hosted-emerald
- self-hosted-spaceforge
- self-hosted-diamond-carmon-lattice

## Option A — Create a short-lived PAT and let me dispatch
1. Create a short-lived PAT (classic) with scopes:
   - `workflow`
   - `repo` (only if the repo is private)
2. Share the PAT securely (paste it in chat once) or run the `scripts/dispatch_workflow.sh` locally (recommended) with the PAT in an env var.
3. Example dispatch command (run locally):

```bash
# Example: dispatch the container-diamond-carmon-lattice job
PAT=<your_pat_here>
JOB=container-diamond-carmon-lattice
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $PAT" \
  https://api.github.com/repos/Space-LEAF-corp/First-Quantum-ATOM/actions/workflows/ci.yml/dispatches \
  -d '{"ref":"main","inputs":{"job":"'$JOB'"}}'
```

4. Revoke the PAT in GitHub after the run.

## Option B — Run from the Actions UI (recommended, safer)
1. Go to the repository `Actions` tab → select `CI` → **Run workflow**.
2. Choose the `job` input from the dropdown (e.g., `container-diamond-carmon-lattice`) and click **Run workflow**.
3. Copy the run URL and paste it here; I will follow logs and report the outcome.

## Option C — Private container images
If a container image is private on GHCR or another registry:
1. Add the registry credentials as repository secrets: `GHCR_USERNAME` and `GHCR_PAT` (or `REGISTRY_USERNAME` / `REGISTRY_PASSWORD`).
2. The workflow contains a conditional login step that will run if `GHCR_USERNAME` and `GHCR_PAT` are present.

## What I will do after you trigger a run
- Monitor logs, summarize pass/fail status, runtime, and any errors.
- If images are missing or access is denied, I will report the exact error and remediation steps.

---
If you prefer, I can trigger jobs for you if you supply a short-lived PAT or you can run from the UI and share the run URL.
