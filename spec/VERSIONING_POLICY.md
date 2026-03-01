# HBCE AI Capsule Versioning Policy

## Version Format

MAJOR.MINOR.PATCH

- MAJOR: breaking changes to verification logic
- MINOR: backward-compatible additions
- PATCH: documentation or tooling updates

## Deterministic Rule Stability

Any change affecting:

- chain.entry computation
- signature payload
- policy enforcement logic

REQUIRES a MAJOR version increment.

## Provider Additions

Adding a new provider example does NOT require a MAJOR change.

## Compatibility Guarantee

Verification logic is version-locked.
A verifier must explicitly declare supported capsule spec version.

End of policy.
