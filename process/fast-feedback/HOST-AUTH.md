# Reviewer follow-up: authenticated hosts and self-contained checks

Devon's [review of #148](https://github.com/servil-software-factory/bench-hashes/pull/148) identified two useful prerequisites: authenticate the benchmark host and make the fault controls runnable outside Sam's environment. Both are implemented in source [`50a8f2621c8511463ceafee8738f5908552c44c2`](https://github.com/samshackleton-tech/bench-hashes/commit/50a8f2621c8511463ceafee8738f5908552c44c2), on the integration tip proposed by #150.

## Host authentication

The client requires a known ED25519 host key with strict SSH checking. `pinned-run trust HOST KEY.pub` enrolls a key supplied through the trusted provisioning channel, prints its fingerprint and refuses a changed existing key. The bootstrap saves the server's public key and fingerprint for that enrollment. Connection sharing uses a fresh `pinned-` namespace, so earlier unverified control connections cannot bypass the new check. Transport failures also stop optional version/status requests.

The two pilot hosts were enrolled from their current managed bootstrap/shell sessions. Future enrollment remains an explicit bootstrap step. The existing EPYC pin was left intact; other fleet hosts need enrollment before use with this client.

Live checks used fresh SSH connections, with sharing disabled for the controls:

- Correct enrolled pin: the host returned its VERIFIED run status.
- Missing pin: request rejected with `Host key verification failed`.
- Changed pin: request rejected with `Host key verification failed`.
- The final source also rejected missing/changed pins through the optional status path instead of returning an empty status.

`host-auth-live-control.json` records the first two negative controls at source 651cf3d; `host-auth-status-control.json` records the final status controls at full source 50a8f262. These controls exercised the local client's authentication path; the suite executions below are pinned remote runs.

## Self-contained reviewer command

```sh
python3 tools/pinned-run/check.py --output /tmp/pinned-run-check
```

The command uses standard Python, Git and OpenSSH. Each fault is applied to a temporary source copy after asserting exactly one match. The original checkout stays unchanged. Tests use ordinary temporary directories, so neither Sam's `replace` executable nor `~/work` is a prerequisite.

The final pinned checks ran with an empty HOME and PATH restricted to `/usr/bin:/bin`. Their wrapper required `replace` to be absent and confirmed that the suite created no HOME/work directory:

- `host-auth-final-clean-ice-20261107T191900-2e295a28`: VERIFIED, **44 tests and fifteen fault controls**, 6.2 s accepted→finished.
- `host-auth-final-clean-arm-20261107T191902-c98cbd8c`: VERIFIED, **44 tests and fifteen fault controls**, 6.4 s accepted→finished.

The three new plants disable host checking, accept a changed enrollment key and ignore an optional request's transport failure. Each fails its named test. Earlier 43-test/fourteen-control checks at 651cf3d are retained too.

`host-auth-startup-aa-ice-20261107T191623-03b0c39e`, at source 651cf3d, passed the existing startup A/A instrument over the authenticated transport: **17.2 s**, eight Level judgments and no load-warning output. Its full source, script, runner and phase identities are in `host-auth-runs/`.

## Explicit request identity

A final transport pass added `IdentitiesOnly=yes`, so a request uses the named everyday key rather than an agent's alternate identity. Source **`c4e57ee2e465a5f9a8b7c272006047bbc65b1702`** passed **44 tests and sixteen fault controls** with empty HOME and system-only PATH on both pilot hosts:

- `explicit-key-clean-ice-20261107T200000-8ab93b88`.
- `explicit-key-clean-arm-20261107T200004-c2e578d5`.

The extra plant enables implicit identities and fails the transport-argument test. Both hosted Linux CI jobs also passed all sixteen controls; their logs are indexed in `CI.md`.

This source is installed locally and request-deployed on both pilot hosts. #150 carries these follow-up commits together with collection and exact-commit preparation. John owns organization integration.

— Sam Shackleton
