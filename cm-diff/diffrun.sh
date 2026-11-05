#!/bin/bash
# cargo-mutants' extra-mutation survivors, before and after tests/differential.rs (run cm-diff): the places
# listed in missed.tsv (cm-extra's MISSED, file line column genre), run on servil (base) and on
# candidate/sam-differential (diff), each its own shards. (extra.sh's head:)
# cargo-mutants' extra mutations on BLAKE3-Servil (run cm-extra): the fork's --extra-mutations
# (samshackleton-tech/cargo-mutants sam/blind-spots, the manifest's commit), built here; the mutants it
# adds over the default set, for the files the arch's list covers (--list --json --diff, with and
# without the flag); each applied in its own shard's worktree and the suite run as check.py runs it
# (cargo nextest, profile mutants, cargo profile mutants, features serde,zeroize, --lib --tests),
# fail-fast, the process group killed at 300 s. Outcome a mutant: CAUGHT, MISSED, UNVIABLE (the
# build fails), TIMEOUT.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
SHARDS=${SHARDS:-8}
{ uname -m; nproc; grep -m1 -E 'model name' /proc/cpuinfo || lscpu | grep -m1 'Model name'; rustc --version; echo "servil $(git -C fork rev-parse HEAD)"; echo "diff $(git -C diff rev-parse HEAD)"; echo "cm $(git -C cm rev-parse HEAD)"; echo "shards $SHARDS"; } > "$O/machine.txt" 2>&1
(cd cm && cargo build --release -q) > "$O/cm-build.log" 2>&1 || { echo "cm build failed" >> "$O/status.txt"; exit 2; }
CM="$R/cm/target/release/cargo-mutants"; "$CM" --version >> "$O/machine.txt"
cd fork
L=tools/mutants/known-$(uname -m).txt
FILES=$(grep "^files:" $L | cut -d' ' -f2-)
A=""; for f in $FILES; do A="$A -f $f"; done
"$CM" mutants --list --json --diff $A > "$O/default.json" 2> "$O/list.err"
"$CM" mutants --list --json --diff --extra-mutations $A > "$O/extra.json" 2>> "$O/list.err"
echo "listed" >> "$O/status.txt"
cd "$R"
cat > missed.tsv <<'TSV_END'
src/lib.rs	623	35	StructFieldValue
src/lib.rs	624	24	StructFieldValue
src/lib.rs	625	22	StructFieldValue
src/lib.rs	626	20	StructFieldValue
src/lib.rs	770	8	Condition
src/lib.rs	770	8	Condition
src/lib.rs	781	12	Condition
src/lib.rs	781	12	Condition
src/lib.rs	796	8	Condition
src/lib.rs	796	8	Condition
src/lib.rs	805	16	ReturnValue
src/lib.rs	805	16	ReturnValue
src/lib.rs	913	5	ReturnValue
src/lib.rs	939	18	StructFieldValue
src/lib.rs	1127	8	Condition
src/lib.rs	1127	8	Condition
src/lib.rs	1160	8	Condition
src/lib.rs	1160	8	Condition
src/lib.rs	1161	12	Condition
src/lib.rs	1161	12	Condition
src/lib.rs	1181	5	ReturnValue
src/lib.rs	1181	5	ReturnValue
src/lib.rs	1232	5	ReturnValue
src/lib.rs	1207	8	Condition
src/lib.rs	1207	8	Condition
src/lib.rs	1208	16	ReturnValue
src/lib.rs	1212	8	Condition
src/lib.rs	1212	8	Condition
src/lib.rs	1214	16	ReturnValue
src/lib.rs	1217	8	Condition
src/lib.rs	1217	8	Condition
src/lib.rs	1218	16	ReturnValue
src/lib.rs	1220	8	Condition
src/lib.rs	1220	8	Condition
src/lib.rs	1222	16	ReturnValue
src/lib.rs	1253	5	ReturnValue
src/lib.rs	1240	8	Condition
src/lib.rs	1240	8	Condition
src/lib.rs	1243	12	Condition
src/lib.rs	1243	12	Condition
src/lib.rs	1253	8	Condition
src/lib.rs	1253	8	Condition
src/lib.rs	1255	51	Condition
src/lib.rs	1255	51	Condition
src/lib.rs	1264	8	Condition
src/lib.rs	1264	8	Condition
src/lib.rs	1268	11	Condition
src/lib.rs	1272	12	Condition
src/lib.rs	1272	12	Condition
src/lib.rs	1274	16	Condition
src/lib.rs	1274	16	Condition
src/lib.rs	1318	8	Condition
src/lib.rs	1318	8	Condition
src/lib.rs	1397	12	Condition
src/lib.rs	1397	12	Condition
src/lib.rs	1402	12	Condition
src/lib.rs	1402	12	Condition
src/lib.rs	1408	12	Condition
src/lib.rs	1408	12	Condition
src/lib.rs	1422	12	Condition
src/lib.rs	1422	12	Condition
src/block.rs	40	20	ReturnValue
src/block.rs	40	20	ReturnValue
src/block.rs	40	20	ReturnValue
src/block.rs	188	9	ReturnValue
src/block.rs	188	9	ReturnValue
src/each.rs	46	12	Condition
src/each.rs	46	12	Condition
src/each.rs	119	20	Condition
src/each.rs	119	20	Condition
src/each.rs	167	8	Condition
src/each.rs	167	8	Condition
src/each.rs	193	12	Condition
src/each.rs	193	12	Condition
src/platform.rs	73	12	Condition
src/platform.rs	73	12	Condition
src/platform.rs	84	16	Condition
src/platform.rs	84	16	Condition
src/platform.rs	89	20	ReturnValue
src/platform.rs	89	41	StructFieldValue
src/platform.rs	89	44	Condition
src/platform.rs	89	44	Condition
src/platform.rs	95	19	StructFieldValue
src/platform.rs	109	12	Condition
src/platform.rs	109	12	Condition
src/platform.rs	192	16	Condition
src/platform.rs	192	16	Condition
src/platform.rs	193	24	ReturnValue
src/platform.rs	200	20	ReturnValue
src/platform.rs	231	20	Condition
src/platform.rs	231	20	Condition
src/platform.rs	359	12	Condition
src/platform.rs	359	12	Condition
src/platform.rs	375	35	Condition
src/platform.rs	375	35	Condition
src/platform.rs	390	24	Condition
src/platform.rs	390	24	Condition
src/platform.rs	450	12	Condition
src/platform.rs	450	12	Condition
src/platform.rs	478	8	Condition
src/platform.rs	478	8	Condition
src/platform.rs	501	8	Condition
src/platform.rs	501	8	Condition
src/platform.rs	505	8	Condition
src/platform.rs	505	8	Condition
src/platform.rs	512	12	Condition
src/platform.rs	512	12	Condition
src/platform.rs	516	12	Condition
src/platform.rs	516	12	Condition
src/platform.rs	522	16	Condition
src/platform.rs	522	16	Condition
src/platform.rs	572	5	ReturnValue
src/platform.rs	572	5	ReturnValue
src/platform.rs	568	8	Condition
src/platform.rs	568	8	Condition
src/platform.rs	569	16	ReturnValue
src/platform.rs	587	5	ReturnValue
src/platform.rs	587	5	ReturnValue
src/platform.rs	583	8	Condition
src/platform.rs	583	8	Condition
src/platform.rs	584	16	ReturnValue
src/platform.rs	602	5	ReturnValue
src/platform.rs	602	5	ReturnValue
src/platform.rs	598	8	Condition
src/platform.rs	598	8	Condition
src/platform.rs	599	16	ReturnValue
src/platform.rs	620	5	ReturnValue
src/platform.rs	620	5	ReturnValue
src/platform.rs	614	16	ReturnValue
src/platform.rs	614	16	ReturnValue
src/platform.rs	639	5	ReturnValue
src/platform.rs	639	5	ReturnValue
src/platform.rs	631	8	Condition
src/platform.rs	631	8	Condition
src/platform.rs	632	16	ReturnValue
src/platform.rs	632	16	ReturnValue
src/platform.rs	655	11	Condition
src/platform.rs	734	5	ReturnValue
src/platform.rs	734	5	ReturnValue
src/platform.rs	727	21	ReturnValue
src/platform.rs	728	21	ReturnValue
src/platform.rs	733	20	Condition
src/platform.rs	733	20	Condition
src/platform.rs	746	5	ReturnValue
src/platform.rs	746	5	ReturnValue
src/platform.rs	739	8	Condition
src/platform.rs	739	8	Condition
src/platform.rs	740	16	ReturnValue
src/platform.rs	755	5	ReturnValue
src/platform.rs	755	5	ReturnValue
src/platform.rs	765	5	ReturnValue
src/platform.rs	765	5	ReturnValue
src/ffi_partial.rs	75	43	Condition
src/ffi_partial.rs	75	43	Condition
src/finish.rs	90	16	Condition
src/finish.rs	90	16	Condition
src/finish.rs	93	16	Condition
src/finish.rs	93	16	Condition
src/lanes.rs	282	60	ReturnValue
src/lanes.rs	282	60	ReturnValue
src/lanes.rs	309	16	ReturnValue
src/lanes.rs	323	16	ReturnValue
src/lanes.rs	468	8	Condition
src/lanes.rs	468	8	Condition
src/lanes.rs	469	16	ReturnValue
src/lanes.rs	530	5	ReturnValue
src/lanes.rs	526	8	Condition
src/lanes.rs	526	8	Condition
src/lanes.rs	527	16	ReturnValue
src/lanes.rs	527	16	ReturnValue
src/lanes.rs	603	5	ReturnValue
src/lanes.rs	603	5	ReturnValue
src/lanes.rs	653	32	StructFieldValue
src/lanes.rs	653	74	StructFieldValue
src/lanes.rs	666	8	Condition
src/lanes.rs	666	8	Condition
src/lanes.rs	804	9	ReturnValue
src/lanes.rs	778	12	Condition
src/lanes.rs	778	12	Condition
src/lanes.rs	831	16	Condition
src/lanes.rs	831	16	Condition
src/lanes.rs	856	16	Condition
src/lanes.rs	856	16	Condition
src/lanes.rs	857	24	ReturnValue
src/lanes.rs	972	13	ReturnValue
src/lanes.rs	969	16	Condition
src/lanes.rs	969	16	Condition
src/lanes.rs	972	16	Condition
src/lanes.rs	972	16	Condition
src/lanes.rs	1006	28	Condition
src/lanes.rs	1006	28	Condition
src/lanes.rs	1038	16	Condition
src/lanes.rs	1038	16	Condition
src/lanes.rs	1133	16	Condition
src/lanes.rs	1133	16	Condition
src/lanes.rs	1158	9	ReturnValue
src/lanes.rs	1158	9	ReturnValue
src/lanes.rs	1155	24	Condition
src/lanes.rs	1155	24	Condition
src/lanes.rs	1301	20	StructFieldValue
src/lanes.rs	1302	18	StructFieldValue
src/lanes.rs	1303	20	StructFieldValue
src/lanes.rs	1304	18	StructFieldValue
src/lanes.rs	1305	19	StructFieldValue
src/lanes.rs	1306	22	StructFieldValue
src/lanes.rs	1404	38	Condition
src/lanes.rs	1404	38	Condition
src/lanes.rs	1426	5	ReturnValue
src/lanes.rs	1433	16	Condition
src/lanes.rs	1433	16	Condition
src/lanes.rs	1449	12	Condition
src/lanes.rs	1449	12	Condition
src/lanes.rs	1453	15	Condition
src/lanes.rs	1464	8	Condition
src/lanes.rs	1464	8	Condition
src/lanes.rs	1495	5	ReturnValue
src/many.rs	71	8	Condition
src/many.rs	71	8	Condition
src/many.rs	76	8	Condition
src/many.rs	76	8	Condition
src/many.rs	77	16	ReturnValue
src/many.rs	80	8	Condition
src/many.rs	80	8	Condition
src/many.rs	81	16	ReturnValue
src/many.rs	175	5	ReturnValue
src/many.rs	168	18	Condition
src/many.rs	168	18	Condition
src/many.rs	169	20	Condition
src/many.rs	169	20	Condition
src/many.rs	206	5	ReturnValue
src/many.rs	416	8	Condition
src/many.rs	416	8	Condition
src/many.rs	416	63	Condition
src/many.rs	416	63	Condition
src/many.rs	417	16	ReturnValue
src/many.rs	446	8	Condition
src/many.rs	446	8	Condition
src/many.rs	447	16	ReturnValue
src/many.rs	449	8	Condition
src/many.rs	449	8	Condition
src/many.rs	511	5	ReturnValue
src/many.rs	543	37	Condition
src/many.rs	543	37	Condition
src/many.rs	545	22	Condition
src/many.rs	545	22	Condition
src/many.rs	547	15	Condition
src/many.rs	547	15	Condition
src/many.rs	552	20	Condition
src/many.rs	552	20	Condition
src/many.rs	556	8	Condition
src/many.rs	556	8	Condition
src/many.rs	558	12	Condition
src/many.rs	558	12	Condition
src/many.rs	560	19	Condition
src/many.rs	560	19	Condition
src/many.rs	569	8	Condition
src/many.rs	569	8	Condition
src/many.rs	572	38	Condition
src/many.rs	572	38	Condition
src/many.rs	642	5	ReturnValue
src/many.rs	642	5	ReturnValue
src/many.rs	641	12	ReturnValue
src/many.rs	641	12	ReturnValue
src/many.rs	686	8	Condition
src/many.rs	686	8	Condition
src/many.rs	686	8	UnaryOperator
src/many.rs	693	67	BinaryOperator
src/many.rs	693	67	BinaryOperator
src/many.rs	694	70	BinaryOperator
src/many.rs	694	70	BinaryOperator
src/many.rs	694	31	BinaryOperator
src/many.rs	694	31	BinaryOperator
src/many.rs	694	36	Condition
src/many.rs	694	36	Condition
src/many.rs	694	38	BinaryOperator
src/many.rs	694	75	Condition
src/many.rs	694	75	Condition
src/many.rs	694	81	BinaryOperator
src/many.rs	694	77	BinaryOperator
src/many.rs	694	77	BinaryOperator
src/many.rs	695	85	BinaryOperator
src/many.rs	695	85	BinaryOperator
src/many.rs	695	90	Condition
src/many.rs	695	90	Condition
src/many.rs	697	19	BinaryOperator
src/many.rs	697	19	BinaryOperator
src/pair.rs	93	8	Condition
src/pair.rs	93	8	Condition
src/pair.rs	93	8	UnaryOperator
src/pair.rs	100	67	BinaryOperator
src/pair.rs	100	67	BinaryOperator
src/pair.rs	101	70	BinaryOperator
src/pair.rs	101	70	BinaryOperator
src/pair.rs	101	31	BinaryOperator
src/pair.rs	101	31	BinaryOperator
src/pair.rs	101	36	Condition
src/pair.rs	101	36	Condition
src/pair.rs	101	38	BinaryOperator
src/pair.rs	101	75	Condition
src/pair.rs	101	75	Condition
src/pair.rs	101	81	BinaryOperator
src/pair.rs	101	77	BinaryOperator
src/pair.rs	101	77	BinaryOperator
src/pair.rs	102	85	BinaryOperator
src/pair.rs	102	85	BinaryOperator
src/pair.rs	102	90	Condition
src/pair.rs	102	90	Condition
src/pair.rs	104	19	BinaryOperator
src/pair.rs	104	19	BinaryOperator
src/park.rs	98	20	Condition
src/park.rs	98	20	Condition
src/park.rs	118	12	Condition
src/park.rs	118	12	Condition
src/park.rs	150	9	ReturnValue
src/park.rs	133	12	Condition
src/park.rs	133	12	Condition
src/park.rs	141	16	Condition
src/park.rs	141	16	Condition
src/park.rs	143	24	ReturnValue
src/park.rs	145	20	ReturnValue
src/park.rs	147	15	Condition
src/self_test.rs	84	21	StructFieldValue
src/self_test.rs	84	29	StructFieldValue
src/self_test.rs	85	21	StructFieldValue
src/self_test.rs	85	29	StructFieldValue
src/self_test.rs	86	21	StructFieldValue
src/self_test.rs	86	29	StructFieldValue
src/self_test.rs	87	21	StructFieldValue
src/self_test.rs	87	29	StructFieldValue
src/self_test.rs	88	21	StructFieldValue
src/self_test.rs	88	29	StructFieldValue
src/self_test.rs	89	21	StructFieldValue
src/self_test.rs	89	29	StructFieldValue
src/self_test.rs	90	20	StructFieldValue
src/self_test.rs	91	21	StructFieldValue
src/self_test.rs	91	29	StructFieldValue
src/self_test.rs	92	21	StructFieldValue
src/self_test.rs	92	29	StructFieldValue
src/self_test.rs	93	21	StructFieldValue
src/self_test.rs	93	29	StructFieldValue
src/self_test.rs	94	21	StructFieldValue
src/self_test.rs	94	29	StructFieldValue
src/self_test.rs	95	21	StructFieldValue
src/self_test.rs	95	29	StructFieldValue
src/self_test.rs	96	21	StructFieldValue
src/self_test.rs	96	29	StructFieldValue
src/self_test.rs	97	21	StructFieldValue
src/self_test.rs	97	29	StructFieldValue
src/self_test.rs	98	21	StructFieldValue
src/self_test.rs	98	29	StructFieldValue
src/self_test.rs	99	21	StructFieldValue
src/self_test.rs	99	29	StructFieldValue
src/self_test.rs	100	21	StructFieldValue
src/self_test.rs	100	29	StructFieldValue
src/self_test.rs	101	21	StructFieldValue
src/self_test.rs	101	29	StructFieldValue
src/self_test.rs	102	21	StructFieldValue
src/self_test.rs	102	29	StructFieldValue
src/self_test.rs	103	21	StructFieldValue
src/self_test.rs	103	29	StructFieldValue
src/self_test.rs	104	21	StructFieldValue
src/self_test.rs	104	29	StructFieldValue
src/self_test.rs	105	21	StructFieldValue
src/self_test.rs	105	29	StructFieldValue
src/self_test.rs	105	41	StructFieldValue
src/self_test.rs	106	21	StructFieldValue
src/self_test.rs	106	29	StructFieldValue
src/self_test.rs	107	21	StructFieldValue
src/self_test.rs	107	29	StructFieldValue
src/self_test.rs	108	21	StructFieldValue
src/self_test.rs	108	29	StructFieldValue
src/self_test.rs	109	28	StructFieldValue
src/self_test.rs	110	28	StructFieldValue
src/self_test.rs	111	21	StructFieldValue
src/self_test.rs	111	29	StructFieldValue
src/self_test.rs	111	40	StructFieldValue
src/self_test.rs	112	21	StructFieldValue
src/self_test.rs	112	29	StructFieldValue
src/self_test.rs	112	40	StructFieldValue
src/self_test.rs	113	21	StructFieldValue
src/self_test.rs	113	29	StructFieldValue
src/self_test.rs	113	40	StructFieldValue
src/self_test.rs	114	21	StructFieldValue
src/self_test.rs	114	29	StructFieldValue
src/self_test.rs	114	39	StructFieldValue
src/self_test.rs	115	21	StructFieldValue
src/self_test.rs	115	29	StructFieldValue
src/self_test.rs	115	41	StructFieldValue
src/self_test.rs	116	21	StructFieldValue
src/self_test.rs	116	29	StructFieldValue
src/self_test.rs	116	41	StructFieldValue
src/self_test.rs	117	21	StructFieldValue
src/self_test.rs	117	29	StructFieldValue
src/self_test.rs	117	41	StructFieldValue
src/self_test.rs	118	21	StructFieldValue
src/self_test.rs	118	29	StructFieldValue
src/self_test.rs	118	41	StructFieldValue
src/self_test.rs	119	21	StructFieldValue
src/self_test.rs	119	29	StructFieldValue
src/self_test.rs	119	42	StructFieldValue
src/self_test.rs	120	21	StructFieldValue
src/self_test.rs	120	29	StructFieldValue
src/self_test.rs	120	42	StructFieldValue
src/self_test.rs	121	19	StructFieldValue
src/self_test.rs	122	25	StructFieldValue
src/self_test.rs	122	45	StructFieldValue
src/self_test.rs	123	25	StructFieldValue
src/self_test.rs	123	41	StructFieldValue
src/self_test.rs	124	17	StructFieldValue
src/self_test.rs	124	28	StructFieldValue
src/self_test.rs	124	37	StructFieldValue
src/self_test.rs	125	17	StructFieldValue
src/self_test.rs	125	29	StructFieldValue
src/self_test.rs	125	38	StructFieldValue
src/self_test.rs	392	5	ReturnValue
src/self_test.rs	392	5	ReturnValue
src/self_test.rs	360	8	Condition
src/self_test.rs	360	8	Condition
src/self_test.rs	362	12	Condition
src/self_test.rs	362	12	Condition
src/self_test.rs	377	20	ReturnValue
src/self_test.rs	377	20	ReturnValue
src/self_test.rs	383	8	Condition
src/self_test.rs	383	8	Condition
src/self_test.rs	385	12	Condition
src/self_test.rs	385	12	Condition
src/self_test.rs	388	20	ReturnValue
src/self_test.rs	388	20	ReturnValue
src/self_test.rs	411	16	Condition
src/self_test.rs	411	16	Condition
src/self_test.rs	422	8	Condition
src/self_test.rs	422	8	Condition
src/self_test.rs	450	12	Condition
src/self_test.rs	450	12	Condition
src/self_test.rs	453	12	Condition
src/self_test.rs	453	12	Condition
src/self_test.rs	528	8	Condition
src/self_test.rs	528	8	Condition
src/stream.rs	198	25	StructFieldValue
src/stream.rs	199	19	StructFieldValue
src/stream.rs	200	24	StructFieldValue
src/stream.rs	201	19	StructFieldValue
src/stream.rs	202	19	StructFieldValue
src/stream.rs	203	19	StructFieldValue
src/stream.rs	204	20	StructFieldValue
src/stream.rs	205	21	StructFieldValue
src/stream.rs	206	18	StructFieldValue
src/stream.rs	431	32	Condition
src/stream.rs	431	32	Condition
src/stream.rs	589	12	Condition
src/stream.rs	589	12	Condition
src/stream.rs	589	54	Condition
src/stream.rs	589	54	Condition
src/stream.rs	748	9	ReturnValue
src/stream.rs	748	9	ReturnValue
src/tree.rs	56	16	ReturnValue
src/tree.rs	56	16	ReturnValue
src/tree.rs	94	16	ReturnValue
src/tree.rs	154	12	Condition
src/tree.rs	154	12	Condition
src/tree.rs	157	20	ReturnValue
src/tree.rs	157	20	ReturnValue
src/tree.rs	157	20	ReturnValue
src/tree.rs	168	12	Condition
src/tree.rs	168	12	Condition
src/tree.rs	171	20	ReturnValue
src/tree.rs	171	20	ReturnValue
src/tree.rs	180	16	ReturnValue
src/hasher.rs	158	16	ReturnValue
src/hasher.rs	158	16	ReturnValue
src/hasher.rs	158	16	ReturnValue
src/hasher.rs	176	23	Condition
src/hasher.rs	176	23	Condition
src/hasher.rs	431	43	StructFieldValue
src/hasher.rs	431	60	StructFieldValue
src/hasher.rs	431	86	StructFieldValue
src/hasher.rs	431	96	StructFieldValue
src/incremental.rs	85	12	Condition
src/incremental.rs	85	12	Condition
src/incremental.rs	87	20	ReturnValue
src/incremental.rs	87	20	ReturnValue
src/incremental.rs	98	23	Condition
src/incremental.rs	98	23	Condition
src/incremental.rs	105	19	Condition
src/incremental.rs	105	19	Condition
src/incremental.rs	134	30	StructFieldValue
src/incremental.rs	134	40	StructFieldValue
src/incremental.rs	195	9	ReturnValue
src/incremental.rs	195	9	ReturnValue
src/incremental.rs	195	9	ReturnValue
src/incremental.rs	173	24	ReturnValue
src/incremental.rs	173	24	ReturnValue
src/incremental.rs	173	24	ReturnValue
src/incremental.rs	184	24	ReturnValue
src/incremental.rs	184	24	ReturnValue
src/incremental.rs	184	24	ReturnValue
src/incremental.rs	224	12	Condition
src/incremental.rs	224	12	Condition
src/incremental.rs	263	12	Condition
src/incremental.rs	263	12	Condition
src/incremental.rs	370	21	StructFieldValue
src/incremental.rs	370	40	StructFieldValue
src/incremental.rs	370	105	StructFieldValue
src/incremental.rs	370	118	StructFieldValue
src/incremental.rs	476	9	ReturnValue
src/incremental.rs	476	12	Condition
src/incremental.rs	476	12	Condition
src/incremental.rs	492	12	Condition
src/incremental.rs	492	12	Condition
TSV_END
cat > run_extra.py <<'PY_RUN_END'
"""The listed places' mutants (extra.json, by file line column genre), sharded over worktrees of CHECKOUT."""
import json, os, signal, subprocess, sys, threading
R, O, shards, checkout, tag = sys.argv[1], sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
want = {tuple(l.rstrip("\n").split("\t")) for l in open(f"{R}/missed.tsv") if l.strip()}
added = [m for m in json.load(open(f"{O}/extra.json")) if (m["file"], str(m["span"]["start"]["line"]), str(m["span"]["start"]["column"]), m["genre"]) in want]
print(len(added), "mutants", flush=True)
lock = threading.Lock(); out = open(f"{O}/outcomes-{tag}.tsv", "w")
def run(cmd, cwd, env, timeout):
    p = subprocess.Popen(cmd, cwd=cwd, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, start_new_session=True)
    try:
        o, _ = p.communicate(timeout=timeout); return p.returncode, o, False
    except subprocess.TimeoutExpired:
        os.killpg(p.pid, signal.SIGKILL); o, _ = p.communicate(); return None, o, True
def shard(k):
    tree = f"{R}/{tag}-shard{k}"
    subprocess.run(["git", "-C", checkout, "worktree", "add", "-q", "--detach", tree, "HEAD"], check=True)
    env = dict(os.environ, CARGO_TARGET_DIR=f"{R}/{tag}-target{k}", BLAKE3_EMULATED="1")
    base = ["cargo", "nextest", "run", "--profile", "mutants", "--cargo-profile", "mutants", "--features", "serde,zeroize", "--lib", "--tests"]
    rc, o, _ = run(base, tree, env, 3600)
    with lock: out.write(f"BASELINE\t{tag}-shard{k}\t{rc}\n"); out.flush()
    for i in range(k, len(added), shards):
        m = added[i]; path = os.path.join(tree, m["file"]); orig = open(path).read()
        try:
            r = subprocess.run(["patch", "-s", "-p0", "--no-backup-if-mismatch", "-r", os.devnull, path], input=m["diff"], text=True, cwd=tree, capture_output=True)
            if r.returncode != 0: verdict, by = "NOPATCH", ""
            else:
                rc, o, timed = run(base, tree, env, 300)
                fails = sorted({l.split("]")[-1].strip().split()[-1] for l in o.splitlines() if l.strip().startswith("FAIL [")})
                by = ",".join(fails[:4])
                verdict = "TIMEOUT" if timed else "UNVIABLE" if ("error[" in o or "could not compile" in o) else "MISSED" if rc == 0 else "CAUGHT"
        finally:
            open(path, "w").write(orig)
        with lock:
            out.write(f"{verdict}\t{m['genre']}\t{m['file']}:{m['span']['start']['line']}:{m['span']['start']['column']}\t{m['name']}\t{by}\n"); out.flush()
ts = [threading.Thread(target=shard, args=(k,)) for k in range(shards)]
[t.start() for t in ts]; [t.join() for t in ts]
print("done", flush=True)
PY_RUN_END
python3 run_extra.py "$R" "$O" $SHARDS "$R/fork" base > "$O/run-base.log" 2>&1; echo "run base exit $?" >> "$O/status.txt"
python3 run_extra.py "$R" "$O" $SHARDS "$R/diff" diff > "$O/run-diff.log" 2>&1; echo "run diff exit $?" >> "$O/status.txt"
echo "diffrun done" >> "$O/status.txt"
