# HBCE AI Capsule Standard (Vendor-neutral)

This repository defines a **vendor-neutral, audit-first AI execution capsule** that can wrap any LLM provider (OpenAI, Anthropic, local/open-weights) into a deterministic, verifiable structure.

The capsule does **not** claim to “encapsulate a model’s weights” when the provider is cloud-based.
Instead, it encapsulates the **execution contract**: inputs, outputs, policy, identity, hashing, signature, and append-only chaining.

## Goals
- Provider-agnostic: OpenAI / Anthropic / local LLMs.
- EU-first posture: GDPR minimization, auditability, fail-closed enforcement.
- Deterministic verification: PASS/FAIL only.
- Append-only chain with signed entries.

## Core Objects
- **Execution Manifest**: what was executed (provider, model id, parameters, request_id if any).
- **Capsule Event**: canonical input/output + hashes + chain entry.
- **Attestation**: Ed25519 signature over `ascii(chain.entry)` (hex string).

## Files
- `spec/CAPSULE_SPEC_v1.md` — normative spec
- `schemas/*.schema.json` — JSON Schemas
- `examples/openai_event.json` — example capsule event for OpenAI
- `examples/anthropic_event.json` — example capsule event for Anthropic

## Verification Rule (normative)
`chain.entry = sha256(prev|input_sha256|output_sha256|policy_pack_id|ts|ipr_ai|ipr_operator)`

Signature payload (normative):
`ascii(chain.entry)` bytes (64-char lowercase hex) signed with Ed25519.

## License
MIT (suggested) or your preferred EU-friendly license.
