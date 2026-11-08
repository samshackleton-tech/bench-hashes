# fix312-costs-ice-20261108T174729-dd7b8205

Host: `root@185.8.106.126`; study: `r88-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 79042175 |
| lock_wait | 94674817152 |
| preparation | 3355222938 |
| job | 172455584605 |
| verification | 2412005 |
| total | 270567217770 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 36 Faster, 203 Level, 81 Slower

```json
{"items": "128", "metric": "instructions", "new_per_item": "21866.4637", "old_per_item": "20796.8359", "ratio_permille": "1051", "shape": "mixed_modes_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "43542.0241", "old_per_item": "41348.7861", "ratio_permille": "1053", "shape": "mixed_modes_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "5413.7802", "old_per_item": "5227.4471", "ratio_permille": "1036", "shape": "mixed_modes_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "5413.8516", "old_per_item": "5227.2353", "ratio_permille": "1036", "shape": "mixed_modes_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "10801.9970", "old_per_item": "10431.4533", "ratio_permille": "1036", "shape": "mixed_modes_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "21280.9493", "old_per_item": "20386.2584", "ratio_permille": "1044", "shape": "mixed_modes_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "573626.9211", "old_per_item": "552484.9892", "ratio_permille": "1038", "shape": "mixed_modes_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "10991.5525", "old_per_item": "10658.9214", "ratio_permille": "1031", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "10990.7685", "old_per_item": "10659.0679", "ratio_permille": "1031", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "21914.2233", "old_per_item": "21259.1154", "ratio_permille": "1031", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "42299.6266", "old_per_item": "40511.2375", "ratio_permille": "1044", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "1165147.4133", "old_per_item": "1123366.7657", "ratio_permille": "1037", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "6788.2015", "old_per_item": "5942.3543", "ratio_permille": "1142", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "6786.5633", "old_per_item": "5942.0532", "ratio_permille": "1142", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "cycles", "new_per_item": "13523.0830", "old_per_item": "11843.7989", "ratio_permille": "1142", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "23643.7790", "old_per_item": "18282.6525", "ratio_permille": "1293", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "package_nj", "new_per_item": "728528.6983", "old_per_item": "639682.1567", "ratio_permille": "1139", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "13490.6174", "old_per_item": "11849.9535", "ratio_permille": "1138", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "13487.4906", "old_per_item": "11850.1322", "ratio_permille": "1138", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "cycles", "new_per_item": "26872.2990", "old_per_item": "23616.0380", "ratio_permille": "1138", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "47064.1969", "old_per_item": "36323.3042", "ratio_permille": "1296", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "package_nj", "new_per_item": "1448067.0293", "old_per_item": "1272075.5169", "ratio_permille": "1138", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "5544.8938", "old_per_item": "4965.6744", "ratio_permille": "1117", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "5544.4556", "old_per_item": "4965.7326", "ratio_permille": "1117", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "11064.6665", "old_per_item": "9910.2359", "ratio_permille": "1116", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "22251.9861", "old_per_item": "18772.4782", "ratio_permille": "1185", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "585084.4562", "old_per_item": "525507.0944", "ratio_permille": "1113", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "11060.8176", "old_per_item": "9894.4443", "ratio_permille": "1118", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "11059.5019", "old_per_item": "9889.0599", "ratio_permille": "1118", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "22067.6426", "old_per_item": "19727.3922", "ratio_permille": "1119", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "44252.8450", "old_per_item": "37303.6443", "ratio_permille": "1186", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "1168455.1573", "old_per_item": "1047981.1126", "ratio_permille": "1115", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "5568.9840", "old_per_item": "5003.3388", "ratio_permille": "1113", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "5568.9279", "old_per_item": "5000.1153", "ratio_permille": "1114", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "11113.3218", "old_per_item": "9976.8916", "ratio_permille": "1114", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "22365.8357", "old_per_item": "18970.4588", "ratio_permille": "1179", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "588378.7369", "old_per_item": "530519.0386", "ratio_permille": "1109", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "11144.9211", "old_per_item": "9984.5037", "ratio_permille": "1116", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "11142.3437", "old_per_item": "9980.9483", "ratio_permille": "1116", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "22228.0080", "old_per_item": "19915.8722", "ratio_permille": "1116", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "44456.6841", "old_per_item": "37703.6361", "ratio_permille": "1179", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "1173389.0241", "old_per_item": "1057020.1367", "ratio_permille": "1110", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "5697.5380", "old_per_item": "4953.9575", "ratio_permille": "1150", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "5697.2689", "old_per_item": "4951.6570", "ratio_permille": "1151", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "11367.7115", "old_per_item": "9880.6545", "ratio_permille": "1151", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "22722.4249", "old_per_item": "18695.4744", "ratio_permille": "1215", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "603702.3512", "old_per_item": "522937.6059", "ratio_permille": "1154", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "11576.3082", "old_per_item": "10092.9784", "ratio_permille": "1147", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "11574.4972", "old_per_item": "10087.3780", "ratio_permille": "1147", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "23076.7847", "old_per_item": "20113.4757", "ratio_permille": "1147", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "45168.8111", "old_per_item": "37131.6180", "ratio_permille": "1216", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "1232986.7986", "old_per_item": "1071148.8269", "ratio_permille": "1151", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "wall_ns", "new_per_item": "5349.4987", "old_per_item": "5158.0980", "ratio_permille": "1037", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "cpu_ns", "new_per_item": "5347.4978", "old_per_item": "5157.7012", "ratio_permille": "1037", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "cycles", "new_per_item": "10670.0296", "old_per_item": "10293.6739", "ratio_permille": "1037", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "instructions", "new_per_item": "22352.0279", "old_per_item": "20913.8660", "ratio_permille": "1069", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "package_nj", "new_per_item": "566388.0721", "old_per_item": "546202.3677", "ratio_permille": "1037", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "wall_ns", "new_per_item": "10789.3930", "old_per_item": "10318.6710", "ratio_permille": "1046", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "cpu_ns", "new_per_item": "10711.4925", "old_per_item": "10307.5327", "ratio_permille": "1039", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "cycles", "new_per_item": "21372.6192", "old_per_item": "20559.6331", "ratio_permille": "1040", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "instructions", "new_per_item": "44366.5554", "old_per_item": "41486.9398", "ratio_permille": "1069", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "wall_ns", "new_per_item": "7015.5740", "old_per_item": "6102.1009", "ratio_permille": "1150", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "cpu_ns", "new_per_item": "7014.5650", "old_per_item": "6101.3995", "ratio_permille": "1150", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "cycles", "new_per_item": "13973.1197", "old_per_item": "12157.9942", "ratio_permille": "1149", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "instructions", "new_per_item": "24228.9131", "old_per_item": "18197.4537", "ratio_permille": "1331", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "package_nj", "new_per_item": "752965.6092", "old_per_item": "658243.8946", "ratio_permille": "1144", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "wall_ns", "new_per_item": "14035.8769", "old_per_item": "12259.8086", "ratio_permille": "1145", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "cpu_ns", "new_per_item": "14036.0794", "old_per_item": "12252.6036", "ratio_permille": "1146", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "cycles", "new_per_item": "27970.0687", "old_per_item": "24415.4393", "ratio_permille": "1146", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "instructions", "new_per_item": "48191.1677", "old_per_item": "36137.8696", "ratio_permille": "1334", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "package_nj", "new_per_item": "1502230.7634", "old_per_item": "1317420.6018", "ratio_permille": "1140", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "5471.6779", "old_per_item": "5024.6761", "ratio_permille": "1089", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "5469.9090", "old_per_item": "5023.5913", "ratio_permille": "1089", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "10912.7989", "old_per_item": "10025.2295", "ratio_permille": "1089", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "22079.0983", "old_per_item": "19274.8797", "ratio_permille": "1145", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "package_nj", "new_per_item": "581766.7643", "old_per_item": "532246.7850", "ratio_permille": "1093", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "10912.6473", "old_per_item": "10001.9076", "ratio_permille": "1091", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "10910.2425", "old_per_item": "9995.1944", "ratio_permille": "1092", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "21772.7860", "old_per_item": "19944.6825", "ratio_permille": "1092", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "43884.7239", "old_per_item": "38338.4869", "ratio_permille": "1145", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "package_nj", "new_per_item": "1152218.0894", "old_per_item": "1057420.3491", "ratio_permille": "1090", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```
[out/judgments-finish.tsv](out/judgments-finish.tsv): 253 Level, 3 Slower

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "150.2718", "old_per_item": "138.7386", "ratio_permille": "1083", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "161.8466", "old_per_item": "150.2280", "ratio_permille": "1077", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "128", "metric": "cycles", "new_per_item": "304.1845", "old_per_item": "281.5564", "ratio_permille": "1080", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```
[out/judgments-update.tsv](out/judgments-update.tsv): 34 Faster, 204 Level, 82 Slower

```json
{"items": "128", "metric": "instructions", "new_per_item": "21232.5250", "old_per_item": "20158.3697", "ratio_permille": "1053", "shape": "mixed_modes_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "42898.2682", "old_per_item": "40707.3156", "ratio_permille": "1054", "shape": "mixed_modes_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "5325.1758", "old_per_item": "5103.1473", "ratio_permille": "1043", "shape": "mixed_modes_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "5290.9363", "old_per_item": "5102.4184", "ratio_permille": "1037", "shape": "mixed_modes_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "10556.0189", "old_per_item": "10180.8574", "ratio_permille": "1037", "shape": "mixed_modes_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "20643.9793", "old_per_item": "19748.7001", "ratio_permille": "1045", "shape": "mixed_modes_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "564479.4255", "old_per_item": "540797.3046", "ratio_permille": "1044", "shape": "mixed_modes_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "10863.4748", "old_per_item": "10529.5020", "ratio_permille": "1032", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "10861.2586", "old_per_item": "10527.3472", "ratio_permille": "1032", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "21650.4240", "old_per_item": "20992.9794", "ratio_permille": "1031", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "41659.8859", "old_per_item": "39874.3488", "ratio_permille": "1045", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "1152286.3244", "old_per_item": "1113771.6425", "ratio_permille": "1034", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "6650.5189", "old_per_item": "5817.6580", "ratio_permille": "1143", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "6650.6200", "old_per_item": "5817.6348", "ratio_permille": "1143", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "cycles", "new_per_item": "13255.0376", "old_per_item": "11597.1140", "ratio_permille": "1143", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "22999.5233", "old_per_item": "17647.6810", "ratio_permille": "1303", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "package_nj", "new_per_item": "711124.1420", "old_per_item": "623525.0405", "ratio_permille": "1141", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "13350.6305", "old_per_item": "11724.8322", "ratio_permille": "1139", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "13350.5044", "old_per_item": "11723.6706", "ratio_permille": "1139", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "cycles", "new_per_item": "26611.1346", "old_per_item": "23367.9067", "ratio_permille": "1139", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "46449.5765", "old_per_item": "35688.3550", "ratio_permille": "1302", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "package_nj", "new_per_item": "1422222.4553", "old_per_item": "1253998.2795", "ratio_permille": "1134", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "5427.8910", "old_per_item": "4844.7028", "ratio_permille": "1120", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "5423.7209", "old_per_item": "4842.1570", "ratio_permille": "1120", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "10819.0863", "old_per_item": "9662.2077", "ratio_permille": "1120", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "21616.9124", "old_per_item": "18135.2266", "ratio_permille": "1192", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "575831.4484", "old_per_item": "513909.0798", "ratio_permille": "1120", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "10918.6269", "old_per_item": "9759.3769", "ratio_permille": "1119", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "10917.4621", "old_per_item": "9757.9562", "ratio_permille": "1119", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "21785.7826", "old_per_item": "19470.5545", "ratio_permille": "1119", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "43597.0895", "old_per_item": "36665.3001", "ratio_permille": "1189", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "1156114.1902", "old_per_item": "1028894.8236", "ratio_permille": "1124", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "5452.1352", "old_per_item": "4874.4507", "ratio_permille": "1118", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "5449.0841", "old_per_item": "4874.0558", "ratio_permille": "1118", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "10869.3815", "old_per_item": "9726.9564", "ratio_permille": "1117", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "21726.0330", "old_per_item": "18329.0509", "ratio_permille": "1185", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "579050.2677", "old_per_item": "517708.3848", "ratio_permille": "1118", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "11028.4551", "old_per_item": "9854.2946", "ratio_permille": "1119", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "11022.0239", "old_per_item": "9852.4531", "ratio_permille": "1119", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "21986.2980", "old_per_item": "19658.5304", "ratio_permille": "1118", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "43820.1162", "old_per_item": "37062.4794", "ratio_permille": "1182", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "1167603.2040", "old_per_item": "1041644.2273", "ratio_permille": "1121", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "5574.9792", "old_per_item": "4830.1136", "ratio_permille": "1154", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "5574.4302", "old_per_item": "4830.1719", "ratio_permille": "1154", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "11122.1850", "old_per_item": "9635.1619", "ratio_permille": "1154", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "22084.8199", "old_per_item": "18057.7726", "ratio_permille": "1223", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "591255.8878", "old_per_item": "512220.3023", "ratio_permille": "1154", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "11445.5611", "old_per_item": "9952.4916", "ratio_permille": "1150", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "11445.7392", "old_per_item": "9950.5835", "ratio_permille": "1150", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "22823.3039", "old_per_item": "19842.6518", "ratio_permille": "1150", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "44539.9495", "old_per_item": "36493.8676", "ratio_permille": "1220", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "1209703.6487", "old_per_item": "1054093.1944", "ratio_permille": "1148", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "wall_ns", "new_per_item": "5211.0423", "old_per_item": "5023.4240", "ratio_permille": "1037", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "cpu_ns", "new_per_item": "5210.7529", "old_per_item": "5023.1110", "ratio_permille": "1037", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "cycles", "new_per_item": "10399.3682", "old_per_item": "10023.7569", "ratio_permille": "1037", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "instructions", "new_per_item": "21688.0271", "old_per_item": "20246.7487", "ratio_permille": "1071", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "package_nj", "new_per_item": "550275.1655", "old_per_item": "532542.1080", "ratio_permille": "1033", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "wall_ns", "new_per_item": "10576.3197", "old_per_item": "10170.9703", "ratio_permille": "1040", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "cpu_ns", "new_per_item": "10576.4495", "old_per_item": "10168.1354", "ratio_permille": "1040", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "cycles", "new_per_item": "21109.3354", "old_per_item": "20291.3424", "ratio_permille": "1040", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "instructions", "new_per_item": "43702.5549", "old_per_item": "40822.8421", "ratio_permille": "1071", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "package_nj", "new_per_item": "1116853.0325", "old_per_item": "1076177.7115", "ratio_permille": "1038", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "wall_ns", "new_per_item": "6877.7817", "old_per_item": "6025.8125", "ratio_permille": "1141", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "cpu_ns", "new_per_item": "6876.4246", "old_per_item": "6022.7911", "ratio_permille": "1142", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "cycles", "new_per_item": "13697.7488", "old_per_item": "12003.7909", "ratio_permille": "1141", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "instructions", "new_per_item": "23595.8202", "old_per_item": "17561.9716", "ratio_permille": "1344", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "package_nj", "new_per_item": "739588.3401", "old_per_item": "646563.6194", "ratio_permille": "1144", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "wall_ns", "new_per_item": "13900.7929", "old_per_item": "12114.4603", "ratio_permille": "1147", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "cpu_ns", "new_per_item": "13894.0624", "old_per_item": "12114.6469", "ratio_permille": "1147", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "cycles", "new_per_item": "27682.8644", "old_per_item": "24137.9281", "ratio_permille": "1147", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "instructions", "new_per_item": "47554.5347", "old_per_item": "35502.3798", "ratio_permille": "1339", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "package_nj", "new_per_item": "1491452.7535", "old_per_item": "1298391.8190", "ratio_permille": "1149", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "5346.1428", "old_per_item": "4900.1908", "ratio_permille": "1091", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "5345.2025", "old_per_item": "4899.8333", "ratio_permille": "1091", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "10662.1858", "old_per_item": "9777.2851", "ratio_permille": "1091", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "21441.3476", "old_per_item": "18646.1269", "ratio_permille": "1150", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "package_nj", "new_per_item": "572320.4587", "old_per_item": "518344.5018", "ratio_permille": "1104", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "10793.0610", "old_per_item": "9867.0496", "ratio_permille": "1094", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "10787.2575", "old_per_item": "9865.4486", "ratio_permille": "1093", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "21526.7612", "old_per_item": "19686.3713", "ratio_permille": "1093", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "43246.5286", "old_per_item": "37698.7179", "ratio_permille": "1147", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "package_nj", "new_per_item": "1141449.5008", "old_per_item": "1047317.6250", "ratio_permille": "1090", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `fd048373c8e5cb814ef9fc302709a75a96650a05`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `9d620e4444cd9c0a4f1f7ad4404cfa4935c8d836`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
