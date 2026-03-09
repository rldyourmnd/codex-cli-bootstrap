## Summary

Describe what changed and why.

## Scope

- [ ] runtime payload
- [ ] shared agent profiles
- [ ] scripts
- [ ] docs
- [ ] CI / GitHub
- [ ] governance / OSS files

## Validation

- [ ] `scripts/check-repo-consistency.sh`
- [ ] `scripts/check-toolchain.sh --strict-codex-only`
- [ ] `scripts/verify.sh`
- [ ] `scripts/audit-codex-agents.sh`
- [ ] `scripts/codex-activate.sh --check-only`
- [ ] `scripts/self-test.sh` if export/install behavior changed
- [ ] `scripts/build-release-bundle.sh --output-dir dist` if release packaging or workflows changed

## Risk And Rollback

List potential risk and how to rollback safely.

## Checklist

- [ ] No secrets or auth state were committed
- [ ] Documentation was updated where behavior or structure changed
- [ ] Portability impact was reviewed
- [ ] No shared/custom skill overlap was introduced
- [ ] Governance/community files remain accurate
