# HBCE AI CAPSULE SPEC v1 (Normative)

**Status:** Draft (v1)  
**Scope:** Vendor-neutral AI execution capsule, audit-first, fail-closed.

## 1. Definitions
- **Provider:** external or internal LLM engine (OpenAI, Anthropic, local runtime).
- **Execution Manifest:** metadata describing how the provider was called.
- **Capsule Event:** immutable record containing canonical texts + hashes + chain link.
- **Attestation:** Ed25519 signature over the event’s `chain.entry`.

## 2. Design Posture (MUST)
Systems conforming to this spec MUST:
- be **FAIL_CLOSED** on verification or policy mismatch.
- minimize data storage (GDPR_MIN) by preferring hashes and canonical texts only when needed.
- support **APPEND_ONLY** chained events.
- be deterministic in verification (PASS/FAIL only).

## 3. Canonicalization
- `input.canonical` and `output.canonical` are UTF-8 text.
- Hash function is SHA-256 over the UTF-8 bytes.
- Newline normalization: implementations SHOULD normalize `\r\n` to `\n` before hashing if the platform may alter newlines.

## 4. Capsule Event Object
A Capsule Event MUST contain:
- `spec`: string identifier
- `event_id`: integer monotonic
- `ts`: ISO 8601 timestamp with timezone
- `ipr_ai`: identity of the AI capsule executor (e.g., IPR-AI-0001)
- `ipr_operator`: identity of the human operator (e.g., IPR-3)
- `provider.name`: provider slug (e.g., "openai", "anthropic")
- `provider.model_id`: model identifier
- `policy.policy_pack_id`
- `input.canonical`, `input.sha256`
- `output.canonical`, `output.sha256`
- `chain.prev`, `chain.entry`, `chain.algo`
- `sign.alg`, `sign.key_id`, `sign.pub_ref`, `sign.sig`

## 5. Chain Entry Derivation (MUST)
Implementations MUST compute:

`base = prev|input_sha256|output_sha256|policy_pack_id|ts|ipr_ai|ipr_operator`

`chain.entry = sha256(base)`

The `chain.entry` MUST be lowercase hex (64 chars).

## 6. Signature (MUST when policy requires)
When policy enforces signatures:
- Signature algorithm MUST be Ed25519.
- Signature payload MUST be `ascii(chain.entry)` bytes (64 bytes).
- `sign.sig` MUST be Base64 (standard alphabet). Implementations SHOULD accept URL-safe base64 by normalization.

## 7. Provider Execution Manifest (RECOMMENDED)
For cloud providers, the system SHOULD store:
- provider name and model id
- request parameters (temperature, top_p, max_tokens, tool usage, etc.)
- request_id when available
- a hash of the system prompt/template if used

This does not make the model deterministic; it makes the execution **auditable**.

## 8. Verification Output (MUST)
Verification MUST return PASS/FAIL only.
On FAIL, the system MAY provide diagnostics for operators, but MUST treat verification as deny-by-default.

## 9. Conformance
A system is conformant if it:
- recomputes hashes and chain entry deterministically
- verifies Ed25519 signature according to §6 when required
- enforces policy packs fail-closed
