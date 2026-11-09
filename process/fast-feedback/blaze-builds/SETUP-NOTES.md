# Setup receipts and limits

This study made no speed measurement. Shell/network observations below are setup outcomes, not performance samples.

- Discovery found main d42956161394326e6329acca15180739cf278259, stable pointer0.20261027.0 and canary pointer0.20261105.4. The optional main rust-toolchain.toml URL returned404; the toolchain is documented elsewhere.
- The first release-document downloader selected `discovery/stable/docs` and `discovery/canary/docs`, but stable/canary already named pointer files. Writes failed with ENOTDIR. Those documents were fetched into `discovery/release-stable/docs` and `discovery/release-canary/docs`; no measurement used either failed destination.
- The stable release has no B3SUMS URL (404). The published SHA256SUMS was checked; the BLAKE3 digest was independently computed with official b3sum1.8.7 and retained.
- Pinned first item failed on host HTTP403 before writing its release manifest. Its complete failed run is retained. The single transport repair changed only archive acquisition: locally downloaded GitHub release bytes, published SHA256 verification, exclusive-lock transfer to hash-named immutable host inputs, then recheck in the repaired job.
- The first local SSH provisioning command failed on permissions of `/etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf`. Using `ssh -F /dev/null` avoided that system configuration. ED25519 host selection, enrolled host-key checking and IdentitiesOnly remained strict.
- Stable archive transfer completed; the90second batch limit interrupted the larger canary transfer. The incomplete `.upload` was not an accepted input. A fresh bounded transfer completed and full SHA256 was verified before atomic rename into the read-only input path. The repaired pinned job independently checked the bytes again.
- The repaired item collected actual platform-prerequisite failures: stable sandbox EACCES, canary registered-buffer ENOMEM. No successful-build or timing result was inferred. Source-change/restoration controls were not reached. Further attempts at those prerequisites are outside this bounded pilot.
- The per-release stop calls succeeded; redundant root-side cleanup later produced the retained workspace-pin permission error. No current study job remains.

The ordinary development toolchain, global Cargo configuration, namespace/AppArmor policy and locked-memory limits were left unchanged. The functional baseline and both Blaze attempts ran as uid65534 with private directories and a clean environment. Full binary archives, temporary toolchains and third-party research/document downloads are excluded from the text evidence snapshot; originals remain local or on the host.
