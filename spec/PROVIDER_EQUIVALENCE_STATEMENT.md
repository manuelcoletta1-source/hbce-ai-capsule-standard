# Provider Equivalence Statement (Normative)

## Scope

This document defines the structural equivalence of LLM providers within the HBCE AI Capsule Standard.

## Principle

All LLM providers are treated as interchangeable execution engines operating inside the same deterministic capsule envelope.

The capsule layer is authoritative.
The provider layer is replaceable.

## Structural Invariants

The following fields MUST remain invariant across providers:

- Canonical input text
- Canonical output text
- SHA256(input)
- SHA256(output)
- chain.entry computation
- Policy pack enforcement
- Ed25519 signature over ascii(chain.entry)

Changing the provider MUST NOT alter:

- Hash computation rules
- Signature rules
- Append-only chain behavior
- Policy enforcement logic

## Provider-Specific Fields

The following fields MAY vary:

- provider.name
- provider.model_id
- provider.request_id
- provider.params

No provider-specific field may influence deterministic verification.

## Verification Neutrality

Verification logic MUST NOT depend on provider identity.
Verification logic MUST depend only on:

- Canonical data
- Hashes
- Policy
- Signature

## Compliance

A provider is considered HBCE-compatible if:

1. It produces deterministic canonical input/output artifacts.
2. It allows execution parameters to be declared.
3. Its execution result can be wrapped inside a Capsule Event.

## Conclusion

The HBCE AI Capsule Standard is provider-agnostic by design.

Provider replacement does not affect:
- Verification outcome
- Chain integrity
- Signature validity
- Policy enforcement

End of normative statement.
