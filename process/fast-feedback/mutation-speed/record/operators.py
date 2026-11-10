#!/usr/bin/env python3
"""A mutant's operator, from its name: what cargo-mutants did, without where."""
import re
def operator(change):
    change = re.sub(r" in .*$", "", change.strip())
    m = re.match(r"replace (.+?) -> (.+?) with (.+)$", change)
    if m:
        value = m.group(3)
        kind = ("true" if value == "true" else "false" if value == "false" else "()" if value == "()" else
                "0" if value in ("0", "0.0") else "1" if value in ("1", "1.0") else "-1" if value in ("-1", "-1.0") else
                "None" if value == "None" else "Default/empty" if re.search(r"Default|new\(\)|vec!\[\]|String::new|\[\]|leak\(", value) else "other value")
        return f"replace a function's body with {kind}"
    m = re.match(r"replace (.+?) with \(\)$", change)
    if m and not re.match(r"replace \S{1,3} with", change):
        return "replace a function's body with ()"
    m = re.match(r"replace (\S+) with (\S+)$", change)
    if m:
        return f"replace {m.group(1)} with {m.group(2)}"
    if change.startswith("delete match arm"):
        return "delete match arm"
    m = re.match(r"delete (\S+)$", change)
    if m:
        return f"delete {m.group(1)}"
    if change.startswith("replace match guard"):
        return "replace match guard " + change.rsplit(" with ", 1)[-1]
    if change.startswith("delete field"):
        return "delete field"
    return "other: " + change[:40]
