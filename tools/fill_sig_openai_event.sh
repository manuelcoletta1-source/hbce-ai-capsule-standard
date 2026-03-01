#!/usr/bin/env bash
set -euo pipefail

# HBCE AI Capsule Standard — minimal signature autofill
# Writes Ed25519 signature (base64) into examples/real_openai_gpt_event_signed.json
# Payload: ascii(chain.entry)

REPO_DIR="$(pwd)"
EVENT_JSON="${REPO_DIR}/examples/real_openai_gpt_event_signed.json"

PRIV="/home/manuelcoletta1/joker-c2.key"
PUB="/home/manuelcoletta1/joker-c2.pub"

PAYLOAD="${REPO_DIR}/payload.txt"
SIGBIN="${REPO_DIR}/sig.bin"

python3 - <<'PY'
import json
p="examples/real_openai_gpt_event_signed.json"
d=json.load(open(p,"r",encoding="utf-8"))
entry=d["chain"]["entry"]
open("payload.txt","wb").write(entry.encode("ascii"))
print("entry:", entry, "len:", len(entry))
PY

openssl pkeyutl -sign -inkey "${PRIV}" -rawin -in "${PAYLOAD}" -out "${SIGBIN}"
openssl pkeyutl -verify -pubin -inkey "${PUB}" -rawin -in "${PAYLOAD}" -sigfile "${SIGBIN}" >/dev/null

SIG_B64="$(base64 -w 0 "${SIGBIN}")"

python3 - <<PY
import json
p="examples/real_openai_gpt_event_signed.json"
d=json.load(open(p,"r",encoding="utf-8"))
d["sign"]["sig"]="${SIG_B64}"
open(p,"w",encoding="utf-8").write(json.dumps(d,indent=2,ensure_ascii=False)+"\n")
print("OK: sig written (base64 len:", len("${SIG_B64}"), ")")
PY
