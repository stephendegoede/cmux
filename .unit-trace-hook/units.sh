#!/usr/bin/env bash
cd "$(git rev-parse --show-toplevel)"
H=.unit-trace-hook/run_traced.sh
$H tier-routing <<'C'
python3 tests/test_cmux_next_route.py
python3 tests/test_cmux_next_base_tier.py
python3 tests/test_ci_target_graph.py
python3 tests/test_ci_swiftpm_build_metrics.py
python3 tests/test_cmux_next_route_replay.py
python3 tests/test_ci_cmux_next_compile_revert.py
python3 tests/test_ci_cmux_next_compile_status.py
C
$H checks-structure <<'C'
python3 tests/test_cmux_next_checks_workflow.py
python3 tests/test_cmux_next_generated_fold.py
python3 tests/test_cmux_next_pr_autofix_push_gate.py
python3 tests/test_run_checks_concurrently.py
python3 tests/test_cmux_next_release_build_retention.py
python3 tests/test_cmux_next_dev_release_host_root.py
python3 tests/test_cmux_next_hybrid_ref_capture.py
python3 tests/test_cmux_next_dev_release_import_out.py
python3 tests/test_xcode_build_timeline.py
python3 tests/test_cmux_next_dev_landing_workflow.py
python3 tests/test_dev_landing_place.py
python3 tests/test_cmux_next_dev_cas_seed.py
python3 tests/test_cmux_next_dev_daily_tree_wait.py
C
root=$(pwd)
python3 - "$root" <<'PY'
import os, sys, re, glob, collections, json
root = os.path.realpath(sys.argv[1]) + "/"
for unit in sorted(os.listdir(".unit-trace")):
    d = f".unit-trace/{unit}"
    seen = collections.Counter(); execs = []
    for f in glob.glob(f"{d}/*"):
        if f.endswith("meta"): continue
        for line in open(f, errors="replace"):
            if f.split("/")[-1].startswith("strace"):
                m = re.search(r'(openat|open|execve)\((?:AT_FDCWD, )?"([^"]+)"', line)
                if not m or "ENOENT" in line: continue
                kind, p = ("exec" if m.group(1) == "execve" else "open"), m.group(2)
            else:
                kind, _, p = line.rstrip("\n").partition("\t")
                if kind == "exec": execs.append(p[:200]); continue
            p = os.path.realpath(p) if p.startswith("/") else os.path.realpath(os.path.join(root, p))
            if p.startswith(root) and "/.unit-trace" not in p and "/.git/" not in p:
                seen[(kind, p[len(root):])] += 1
    paths = sorted({p for _, p in seen})
    tops = collections.Counter("/".join(p.split("/")[:2]) for p in paths)
    print(f"#### {unit}: {len(paths)} paths"); print(open(f"{d}/meta").read())
    for t, n in sorted(tops.items()): print(f"  {n:5} {t}")
    out = [p for p in paths if not p.startswith((".github/", "scripts/", "tests/"))]
    print("  outside .github/ scripts/ tests/:"); [print("   ", k, p) for (k, p) in sorted(seen) if p in out][:0]
    for p in out[:400]: print("    ", p)
    print("  git/bash execs:", len(execs)); [print("    ", e) for e in sorted(set(execs))[:40]]
PY
