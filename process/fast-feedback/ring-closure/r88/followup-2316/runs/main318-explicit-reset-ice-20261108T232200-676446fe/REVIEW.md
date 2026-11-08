# main318-explicit-reset-ice-20261108T232200-676446fe

Host: `root@185.8.106.126`; study: `main318-security-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 91642415 |
| lock_wait | 260912 |
| preparation | 3182832023 |
| job | 172494025175 |
| verification | 2439674 |
| total | 175771338325 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 69 Faster, 183 Level, 68 Slower

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "6513.3408", "old_per_item": "6028.2280", "ratio_permille": "1080", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "6475.0534", "old_per_item": "6027.1906", "ratio_permille": "1074", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "cycles", "new_per_item": "12906.3174", "old_per_item": "12014.6910", "ratio_permille": "1074", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "21852.7154", "old_per_item": "18515.4343", "ratio_permille": "1180", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "package_nj", "new_per_item": "693023.2048", "old_per_item": "643807.1911", "ratio_permille": "1076", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "12797.7109", "old_per_item": "11924.3455", "ratio_permille": "1073", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "12797.8904", "old_per_item": "11923.0389", "ratio_permille": "1073", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "cycles", "new_per_item": "25512.3076", "old_per_item": "23768.6425", "ratio_permille": "1073", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "43205.9676", "old_per_item": "36554.9424", "ratio_permille": "1182", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "package_nj", "new_per_item": "1364680.6989", "old_per_item": "1271547.5900", "ratio_permille": "1073", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "5454.2384", "old_per_item": "5009.3470", "ratio_permille": "1089", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "5448.7831", "old_per_item": "5009.2285", "ratio_permille": "1088", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "10874.4712", "old_per_item": "9997.9111", "ratio_permille": "1088", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "21976.5696", "old_per_item": "18978.3330", "ratio_permille": "1158", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "578042.1571", "old_per_item": "529961.9572", "ratio_permille": "1091", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "10830.7937", "old_per_item": "9975.4484", "ratio_permille": "1086", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "10825.7893", "old_per_item": "9975.4146", "ratio_permille": "1085", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "21599.0302", "old_per_item": "19902.7520", "ratio_permille": "1085", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "43429.3546", "old_per_item": "37529.0548", "ratio_permille": "1157", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "1144404.2469", "old_per_item": "1061183.6873", "ratio_permille": "1078", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "5456.0041", "old_per_item": "5067.9282", "ratio_permille": "1077", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "5451.4253", "old_per_item": "5066.2191", "ratio_permille": "1076", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "10878.0910", "old_per_item": "10111.3492", "ratio_permille": "1076", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "21995.5606", "old_per_item": "19192.2634", "ratio_permille": "1146", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "580362.5568", "old_per_item": "537088.6174", "ratio_permille": "1081", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "10867.9171", "old_per_item": "10070.6382", "ratio_permille": "1079", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "10858.3158", "old_per_item": "10070.7633", "ratio_permille": "1078", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "21665.8947", "old_per_item": "20095.3805", "ratio_permille": "1078", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "43481.8817", "old_per_item": "37914.2806", "ratio_permille": "1147", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "1152803.7679", "old_per_item": "1062260.7483", "ratio_permille": "1085", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "5468.1147", "old_per_item": "5033.1663", "ratio_permille": "1086", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "5466.1573", "old_per_item": "5033.2334", "ratio_permille": "1086", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "10907.0498", "old_per_item": "10041.6291", "ratio_permille": "1086", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "21939.7496", "old_per_item": "18931.9876", "ratio_permille": "1159", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "576775.5779", "old_per_item": "531875.2733", "ratio_permille": "1084", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "11023.4993", "old_per_item": "10162.9029", "ratio_permille": "1085", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "11015.0318", "old_per_item": "10161.8163", "ratio_permille": "1084", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "21966.9349", "old_per_item": "20265.3589", "ratio_permille": "1084", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "43373.6340", "old_per_item": "37373.5033", "ratio_permille": "1161", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "1173128.1615", "old_per_item": "1083545.6082", "ratio_permille": "1083", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "wall_ns", "new_per_item": "5327.5544", "old_per_item": "5155.0530", "ratio_permille": "1033", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "cpu_ns", "new_per_item": "5325.9262", "old_per_item": "5153.4476", "ratio_permille": "1033", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "cycles", "new_per_item": "10629.8235", "old_per_item": "10283.3749", "ratio_permille": "1034", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "instructions", "new_per_item": "22488.0298", "old_per_item": "21132.4529", "ratio_permille": "1064", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "package_nj", "new_per_item": "562943.1257", "old_per_item": "544926.9889", "ratio_permille": "1033", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "cpu_ns", "new_per_item": "10618.3220", "old_per_item": "10245.6263", "ratio_permille": "1036", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "cycles", "new_per_item": "21192.3916", "old_per_item": "20444.5646", "ratio_permille": "1037", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "instructions", "new_per_item": "44409.0544", "old_per_item": "41627.5583", "ratio_permille": "1067", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "wall_ns", "new_per_item": "6626.2337", "old_per_item": "6175.5877", "ratio_permille": "1073", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "cpu_ns", "new_per_item": "6625.3777", "old_per_item": "6173.7263", "ratio_permille": "1073", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "cycles", "new_per_item": "13203.3630", "old_per_item": "12305.1476", "ratio_permille": "1073", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "instructions", "new_per_item": "21817.5268", "old_per_item": "18429.5026", "ratio_permille": "1184", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "package_nj", "new_per_item": "709543.6255", "old_per_item": "659152.8654", "ratio_permille": "1076", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "wall_ns", "new_per_item": "13284.7590", "old_per_item": "12329.6468", "ratio_permille": "1077", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "cpu_ns", "new_per_item": "13284.4447", "old_per_item": "12328.3991", "ratio_permille": "1078", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "cycles", "new_per_item": "26476.6152", "old_per_item": "24571.9166", "ratio_permille": "1078", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "instructions", "new_per_item": "43136.9394", "old_per_item": "36362.8101", "ratio_permille": "1186", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "package_nj", "new_per_item": "1420040.4286", "old_per_item": "1318749.7854", "ratio_permille": "1077", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "5430.6680", "old_per_item": "5060.2309", "ratio_permille": "1073", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "5427.0704", "old_per_item": "5059.9281", "ratio_permille": "1073", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "10831.1853", "old_per_item": "10099.0088", "ratio_permille": "1073", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "22072.4390", "old_per_item": "19471.1896", "ratio_permille": "1134", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "package_nj", "new_per_item": "575538.0868", "old_per_item": "533705.4913", "ratio_permille": "1078", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "10858.2702", "old_per_item": "10073.7258", "ratio_permille": "1078", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "10849.3509", "old_per_item": "10073.8522", "ratio_permille": "1077", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "21653.8060", "old_per_item": "20103.5313", "ratio_permille": "1077", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "43626.2463", "old_per_item": "38539.3520", "ratio_permille": "1132", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "package_nj", "new_per_item": "1145281.3469", "old_per_item": "1064682.7744", "ratio_permille": "1076", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```
[out/judgments-finish.tsv](out/judgments-finish.tsv): 256 Level
[out/judgments-update.tsv](out/judgments-update.tsv): 62 Faster, 188 Level, 70 Slower

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "6262.7886", "old_per_item": "5824.0878", "ratio_permille": "1075", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "6260.7778", "old_per_item": "5821.4018", "ratio_permille": "1075", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "cycles", "new_per_item": "12480.5666", "old_per_item": "11604.5795", "ratio_permille": "1075", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "20979.9666", "old_per_item": "17642.4466", "ratio_permille": "1189", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "package_nj", "new_per_item": "671752.5996", "old_per_item": "620998.6550", "ratio_permille": "1082", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "12591.8537", "old_per_item": "11799.6214", "ratio_permille": "1067", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "12590.8889", "old_per_item": "11727.5674", "ratio_permille": "1074", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "cycles", "new_per_item": "25098.7259", "old_per_item": "23376.6847", "ratio_permille": "1074", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "42334.8580", "old_per_item": "35683.5921", "ratio_permille": "1186", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "package_nj", "new_per_item": "1346380.3700", "old_per_item": "1261452.2662", "ratio_permille": "1067", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "5279.3968", "old_per_item": "4842.8148", "ratio_permille": "1090", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "5278.8749", "old_per_item": "4842.0758", "ratio_permille": "1090", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "10534.8862", "old_per_item": "9663.2167", "ratio_permille": "1090", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "21097.7519", "old_per_item": "18105.3905", "ratio_permille": "1165", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "558539.7993", "old_per_item": "512363.1835", "ratio_permille": "1090", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "10642.6354", "old_per_item": "9798.5795", "ratio_permille": "1086", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "10642.1629", "old_per_item": "9798.7009", "ratio_permille": "1086", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "21238.9255", "old_per_item": "19552.7333", "ratio_permille": "1086", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "42555.4788", "old_per_item": "36655.1791", "ratio_permille": "1161", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "1124500.0160", "old_per_item": "1039348.5427", "ratio_permille": "1082", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "5279.9370", "old_per_item": "4894.7085", "ratio_permille": "1079", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "5280.0006", "old_per_item": "4894.3310", "ratio_permille": "1079", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "10538.2450", "old_per_item": "9768.1385", "ratio_permille": "1079", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "21122.0968", "old_per_item": "18318.5533", "ratio_permille": "1153", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "554759.6916", "old_per_item": "517070.5765", "ratio_permille": "1073", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "10674.3572", "old_per_item": "9892.4767", "ratio_permille": "1079", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "10673.9813", "old_per_item": "9890.9676", "ratio_permille": "1079", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "21299.7089", "old_per_item": "19736.4263", "ratio_permille": "1079", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "42608.4364", "old_per_item": "37040.7165", "ratio_permille": "1150", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "1126845.1235", "old_per_item": "1045164.2205", "ratio_permille": "1078", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "5288.8160", "old_per_item": "4857.2841", "ratio_permille": "1089", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "5288.8873", "old_per_item": "4856.8947", "ratio_permille": "1089", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "10552.9697", "old_per_item": "9691.2641", "ratio_permille": "1089", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "21067.0794", "old_per_item": "18059.0410", "ratio_permille": "1167", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "560912.1233", "old_per_item": "512769.9800", "ratio_permille": "1094", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "10815.3804", "old_per_item": "9959.9131", "ratio_permille": "1086", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "10813.9920", "old_per_item": "9959.4019", "ratio_permille": "1086", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "21568.3202", "old_per_item": "19864.4321", "ratio_permille": "1086", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "42500.9751", "old_per_item": "36500.8656", "ratio_permille": "1164", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "1142346.9609", "old_per_item": "1054812.2346", "ratio_permille": "1083", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "wall_ns", "new_per_item": "5117.6710", "old_per_item": "4950.8399", "ratio_permille": "1034", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "cpu_ns", "new_per_item": "5116.2338", "old_per_item": "4950.0306", "ratio_permille": "1034", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "cycles", "new_per_item": "10211.5978", "old_per_item": "9877.8441", "ratio_permille": "1034", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "instructions", "new_per_item": "21594.5264", "old_per_item": "20242.1371", "ratio_permille": "1067", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "package_nj", "new_per_item": "541246.2893", "old_per_item": "521817.9995", "ratio_permille": "1037", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "wall_ns", "new_per_item": "10419.2614", "old_per_item": "10054.3885", "ratio_permille": "1036", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "cpu_ns", "new_per_item": "10415.0870", "old_per_item": "10049.7486", "ratio_permille": "1036", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "cycles", "new_per_item": "20782.1213", "old_per_item": "20054.1095", "ratio_permille": "1036", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "instructions", "new_per_item": "43515.5544", "old_per_item": "40753.6734", "ratio_permille": "1068", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "package_nj", "new_per_item": "1109061.6416", "old_per_item": "1069398.3249", "ratio_permille": "1037", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "wall_ns", "new_per_item": "6562.2777", "old_per_item": "6037.9374", "ratio_permille": "1087", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "cpu_ns", "new_per_item": "6559.4887", "old_per_item": "6020.1341", "ratio_permille": "1090", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "cycles", "new_per_item": "13072.0567", "old_per_item": "11997.8080", "ratio_permille": "1090", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "instructions", "new_per_item": "21019.5510", "old_per_item": "17558.3717", "ratio_permille": "1197", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "package_nj", "new_per_item": "702607.6317", "old_per_item": "646635.1449", "ratio_permille": "1086", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "wall_ns", "new_per_item": "13189.6052", "old_per_item": "12110.9166", "ratio_permille": "1089", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "cpu_ns", "new_per_item": "13187.8698", "old_per_item": "12110.2131", "ratio_permille": "1089", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "cycles", "new_per_item": "26285.4695", "old_per_item": "24135.4388", "ratio_permille": "1089", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "instructions", "new_per_item": "42266.0944", "old_per_item": "35491.9377", "ratio_permille": "1191", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "package_nj", "new_per_item": "1408465.2066", "old_per_item": "1293043.7922", "ratio_permille": "1089", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "5259.0983", "old_per_item": "4891.5181", "ratio_permille": "1075", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "5259.1615", "old_per_item": "4890.9932", "ratio_permille": "1075", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "10495.1401", "old_per_item": "9760.1828", "ratio_permille": "1075", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "21195.7156", "old_per_item": "18605.4925", "ratio_permille": "1139", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "package_nj", "new_per_item": "556919.3266", "old_per_item": "518062.0167", "ratio_permille": "1075", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "10683.1326", "old_per_item": "9900.1472", "ratio_permille": "1079", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "10681.7486", "old_per_item": "9900.0618", "ratio_permille": "1079", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "21319.1949", "old_per_item": "19759.5062", "ratio_permille": "1079", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "42751.8548", "old_per_item": "37663.5208", "ratio_permille": "1135", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "package_nj", "new_per_item": "1127009.6053", "old_per_item": "1043767.6458", "ratio_permille": "1080", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `6e0dffd37e04b01b80dc56eb833b00fc337b6873`
- `new`: https://github.com/servil-software-factory/BLAKE3 at `71154c1dc4661e7bfa30e89d8b434a9394f2feaa`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `3dd9c3f23b68585293ed7ceffdd8fa661f2cb3d26d3b92887817fe6b51f3aadf`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
