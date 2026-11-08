# fix312b-costs-ice-20261108T182704-b8fe44b4

Host: `root@185.8.106.126`; study: `r88-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 87971505 |
| lock_wait | 104886376361 |
| preparation | 3324095849 |
| job | 172192316665 |
| verification | 2427998 |
| total | 280493334232 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 59 Faster, 193 Level, 68 Slower

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "6415.7673", "old_per_item": "5956.0087", "ratio_permille": "1077", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "6412.2604", "old_per_item": "5955.8441", "ratio_permille": "1077", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "cycles", "new_per_item": "12780.5342", "old_per_item": "11873.5918", "ratio_permille": "1076", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "21620.2440", "old_per_item": "18287.5972", "ratio_permille": "1182", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "package_nj", "new_per_item": "686326.3937", "old_per_item": "636973.5513", "ratio_permille": "1077", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "12795.5607", "old_per_item": "11874.6290", "ratio_permille": "1078", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "12786.6468", "old_per_item": "11871.8828", "ratio_permille": "1077", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "cycles", "new_per_item": "25481.3253", "old_per_item": "23661.9016", "ratio_permille": "1077", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "42978.6194", "old_per_item": "36323.8790", "ratio_permille": "1183", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "128", "metric": "package_nj", "new_per_item": "1369369.0300", "old_per_item": "1265455.9953", "ratio_permille": "1082", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "5410.3766", "old_per_item": "4954.8302", "ratio_permille": "1092", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "5409.6170", "old_per_item": "4953.6966", "ratio_permille": "1092", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "10793.2358", "old_per_item": "9884.7332", "ratio_permille": "1092", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "21738.4962", "old_per_item": "18750.0182", "ratio_permille": "1159", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "571314.7685", "old_per_item": "524669.8504", "ratio_permille": "1089", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "10791.4244", "old_per_item": "9889.9473", "ratio_permille": "1091", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "10789.3126", "old_per_item": "9884.1451", "ratio_permille": "1092", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "21530.2395", "old_per_item": "19715.2361", "ratio_permille": "1092", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "43212.0559", "old_per_item": "37298.5383", "ratio_permille": "1159", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "1144970.7424", "old_per_item": "1051436.3646", "ratio_permille": "1089", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "5422.9744", "old_per_item": "4996.3389", "ratio_permille": "1085", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "5422.5197", "old_per_item": "4992.1169", "ratio_permille": "1086", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "10821.3266", "old_per_item": "9962.3806", "ratio_permille": "1086", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "21778.9625", "old_per_item": "18963.7528", "ratio_permille": "1148", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "573364.0272", "old_per_item": "527432.2552", "ratio_permille": "1087", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "10809.6573", "old_per_item": "9962.3578", "ratio_permille": "1085", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "10808.9050", "old_per_item": "9959.6532", "ratio_permille": "1085", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "21558.4812", "old_per_item": "19875.8706", "ratio_permille": "1085", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "43265.3255", "old_per_item": "37651.3352", "ratio_permille": "1149", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "1144707.8276", "old_per_item": "1053351.4265", "ratio_permille": "1087", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "5430.5270", "old_per_item": "4958.5653", "ratio_permille": "1095", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "5429.5936", "old_per_item": "4955.7116", "ratio_permille": "1096", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "10832.1933", "old_per_item": "9885.2979", "ratio_permille": "1096", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "21709.3382", "old_per_item": "18702.1960", "ratio_permille": "1161", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "574249.7943", "old_per_item": "524503.2446", "ratio_permille": "1095", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "10956.1604", "old_per_item": "10070.1206", "ratio_permille": "1088", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "10955.2048", "old_per_item": "10065.8150", "ratio_permille": "1088", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "21850.2424", "old_per_item": "20076.3389", "ratio_permille": "1088", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "43141.0165", "old_per_item": "37145.2371", "ratio_permille": "1161", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "1159395.4904", "old_per_item": "1065690.1768", "ratio_permille": "1088", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "wall_ns", "new_per_item": "5312.7983", "old_per_item": "5155.0079", "ratio_permille": "1031", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "cpu_ns", "new_per_item": "5311.7359", "old_per_item": "5152.4576", "ratio_permille": "1031", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "cycles", "new_per_item": "10597.9277", "old_per_item": "10282.9075", "ratio_permille": "1031", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "instructions", "new_per_item": "22262.5276", "old_per_item": "20910.9604", "ratio_permille": "1065", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "package_nj", "new_per_item": "562620.0233", "old_per_item": "544032.4245", "ratio_permille": "1034", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "cpu_ns", "new_per_item": "10688.0051", "old_per_item": "10375.9612", "ratio_permille": "1030", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "cycles", "new_per_item": "21328.5460", "old_per_item": "20698.4476", "ratio_permille": "1030", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "2", "metric": "instructions", "new_per_item": "44187.5555", "old_per_item": "41467.0797", "ratio_permille": "1066", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "wall_ns", "new_per_item": "6606.0224", "old_per_item": "6105.1604", "ratio_permille": "1082", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "cpu_ns", "new_per_item": "6605.0003", "old_per_item": "6104.4509", "ratio_permille": "1082", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "cycles", "new_per_item": "13163.2051", "old_per_item": "12165.4595", "ratio_permille": "1082", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "instructions", "new_per_item": "21649.9107", "old_per_item": "18197.4539", "ratio_permille": "1190", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "package_nj", "new_per_item": "704114.6358", "old_per_item": "656619.6680", "ratio_permille": "1072", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "wall_ns", "new_per_item": "13257.1240", "old_per_item": "12260.8979", "ratio_permille": "1081", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "cpu_ns", "new_per_item": "13251.8301", "old_per_item": "12250.9910", "ratio_permille": "1082", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "cycles", "new_per_item": "26405.6396", "old_per_item": "24415.9342", "ratio_permille": "1081", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "instructions", "new_per_item": "42910.4860", "old_per_item": "36136.7040", "ratio_permille": "1187", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "512", "metric": "package_nj", "new_per_item": "1424728.3339", "old_per_item": "1316502.6903", "ratio_permille": "1082", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "5409.2881", "old_per_item": "5014.3459", "ratio_permille": "1079", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "5408.7290", "old_per_item": "5011.7551", "ratio_permille": "1079", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "10794.6582", "old_per_item": "10003.1024", "ratio_permille": "1079", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "21835.8523", "old_per_item": "19247.8179", "ratio_permille": "1134", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "package_nj", "new_per_item": "572028.2734", "old_per_item": "530457.1858", "ratio_permille": "1078", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "10797.1915", "old_per_item": "10010.6875", "ratio_permille": "1079", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "10793.6805", "old_per_item": "10002.7665", "ratio_permille": "1079", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "21539.1267", "old_per_item": "19962.2799", "ratio_permille": "1079", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "43392.1578", "old_per_item": "38253.2438", "ratio_permille": "1134", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "8", "metric": "package_nj", "new_per_item": "1143936.2561", "old_per_item": "1058877.7279", "ratio_permille": "1080", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```
[out/judgments-finish.tsv](out/judgments-finish.tsv): 256 Level
[out/judgments-update.tsv](out/judgments-update.tsv): 59 Faster, 195 Level, 66 Slower

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "6277.0353", "old_per_item": "5836.3589", "ratio_permille": "1076", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "6276.5414", "old_per_item": "5833.4386", "ratio_permille": "1076", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "cycles", "new_per_item": "12510.5362", "old_per_item": "11627.0846", "ratio_permille": "1076", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "20983.9814", "old_per_item": "17652.1511", "ratio_permille": "1189", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "package_nj", "new_per_item": "668977.7741", "old_per_item": "626046.3170", "ratio_permille": "1069", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "12652.7828", "old_per_item": "11750.1158", "ratio_permille": "1077", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "12651.7585", "old_per_item": "11748.6845", "ratio_permille": "1077", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "cycles", "new_per_item": "25219.3553", "old_per_item": "23413.2876", "ratio_permille": "1077", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "instructions", "new_per_item": "42342.8691", "old_per_item": "35688.1288", "ratio_permille": "1186", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "128", "metric": "package_nj", "new_per_item": "1351320.7435", "old_per_item": "1258691.7196", "ratio_permille": "1074", "shape": "shared_key_open128_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "5286.0846", "old_per_item": "4829.1458", "ratio_permille": "1095", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "5285.7023", "old_per_item": "4828.6367", "ratio_permille": "1095", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "10546.6615", "old_per_item": "9637.1386", "ratio_permille": "1094", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "21100.1102", "old_per_item": "18110.8230", "ratio_permille": "1165", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "561620.8169", "old_per_item": "510565.9911", "ratio_permille": "1100", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "10667.7570", "old_per_item": "9756.2824", "ratio_permille": "1093", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "10663.3993", "old_per_item": "9755.1025", "ratio_permille": "1093", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "21276.9692", "old_per_item": "19462.5003", "ratio_permille": "1093", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "42573.6322", "old_per_item": "36660.1551", "ratio_permille": "1161", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "1127530.7607", "old_per_item": "1035209.3886", "ratio_permille": "1089", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "5299.2017", "old_per_item": "4866.6560", "ratio_permille": "1089", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "5299.0599", "old_per_item": "4866.4999", "ratio_permille": "1089", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "10573.8390", "old_per_item": "9712.7577", "ratio_permille": "1089", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "21137.6107", "old_per_item": "18322.4524", "ratio_permille": "1154", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "560691.0667", "old_per_item": "515460.2162", "ratio_permille": "1088", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "10682.0768", "old_per_item": "9834.5950", "ratio_permille": "1086", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "10681.2125", "old_per_item": "9833.6158", "ratio_permille": "1086", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "21309.0004", "old_per_item": "19622.0643", "ratio_permille": "1086", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "42623.8902", "old_per_item": "37009.9672", "ratio_permille": "1152", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "1127829.0944", "old_per_item": "1039196.9731", "ratio_permille": "1085", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "5304.1116", "old_per_item": "4832.0526", "ratio_permille": "1098", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "5303.9563", "old_per_item": "4831.6615", "ratio_permille": "1098", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "10583.0691", "old_per_item": "9639.0560", "ratio_permille": "1098", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "21071.5875", "old_per_item": "18064.4162", "ratio_permille": "1166", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "562827.1948", "old_per_item": "511922.1421", "ratio_permille": "1099", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "10835.9624", "old_per_item": "9936.3718", "ratio_permille": "1091", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "10834.5416", "old_per_item": "9935.1227", "ratio_permille": "1091", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "21605.3825", "old_per_item": "19813.0091", "ratio_permille": "1090", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "42503.3131", "old_per_item": "36507.4872", "ratio_permille": "1164", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "24", "metric": "package_nj", "new_per_item": "1150731.1438", "old_per_item": "1053165.2541", "ratio_permille": "1093", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "wall_ns", "new_per_item": "5172.8552", "old_per_item": "5017.6770", "ratio_permille": "1031", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "cpu_ns", "new_per_item": "5172.8415", "old_per_item": "5015.4533", "ratio_permille": "1031", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "cycles", "new_per_item": "10318.2996", "old_per_item": "10010.5679", "ratio_permille": "1031", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "instructions", "new_per_item": "21598.5269", "old_per_item": "20242.2891", "ratio_permille": "1067", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "package_nj", "new_per_item": "554068.3386", "old_per_item": "530855.4206", "ratio_permille": "1044", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "instructions", "new_per_item": "43523.5548", "old_per_item": "40849.6072", "ratio_permille": "1065", "shape": "shared_key_open2_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "wall_ns", "new_per_item": "6566.9873", "old_per_item": "6028.4407", "ratio_permille": "1090", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "cpu_ns", "new_per_item": "6564.9248", "old_per_item": "6026.1827", "ratio_permille": "1090", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "cycles", "new_per_item": "13083.6973", "old_per_item": "12005.3650", "ratio_permille": "1090", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "instructions", "new_per_item": "21009.1570", "old_per_item": "17562.0051", "ratio_permille": "1197", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "package_nj", "new_per_item": "701828.1863", "old_per_item": "648194.5515", "ratio_permille": "1083", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "wall_ns", "new_per_item": "13223.5572", "old_per_item": "12110.1432", "ratio_permille": "1092", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "cpu_ns", "new_per_item": "13222.0561", "old_per_item": "12109.5915", "ratio_permille": "1092", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "cycles", "new_per_item": "26345.2461", "old_per_item": "24138.6533", "ratio_permille": "1091", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "instructions", "new_per_item": "42275.0223", "old_per_item": "35501.2250", "ratio_permille": "1191", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "512", "metric": "package_nj", "new_per_item": "1418687.4032", "old_per_item": "1297777.8911", "ratio_permille": "1093", "shape": "shared_key_open512_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "5281.0300", "old_per_item": "4884.5256", "ratio_permille": "1081", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "5280.8587", "old_per_item": "4884.2470", "ratio_permille": "1081", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "10538.2075", "old_per_item": "9747.7619", "ratio_permille": "1081", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "21198.1040", "old_per_item": "18602.3029", "ratio_permille": "1140", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "package_nj", "new_per_item": "560692.9671", "old_per_item": "514443.2187", "ratio_permille": "1090", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "10672.0610", "old_per_item": "9885.3437", "ratio_permille": "1080", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "10671.0086", "old_per_item": "9884.0694", "ratio_permille": "1080", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "21290.1743", "old_per_item": "19724.0575", "ratio_permille": "1079", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "42752.3479", "old_per_item": "37697.0715", "ratio_permille": "1134", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "8", "metric": "package_nj", "new_per_item": "1128710.4830", "old_per_item": "1044948.1105", "ratio_permille": "1080", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-update"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `fd048373c8e5cb814ef9fc302709a75a96650a05`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `3f3abd29cced846dead9d821cfa50ad822c62fc7`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
