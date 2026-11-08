# whole-stack-large-ice-20261108T074003-95a1402f

Host: `root@185.8.106.126`; study: `whole-stack-large-ice-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 88306180 |
| lock_wait | 245837 |
| preparation | 3324304183 |
| job | 171583473718 |
| verification | 2438933 |
| total | 174998905583 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 155 Faster, 165 Level
[out/judgments-finish.tsv](out/judgments-finish.tsv): 12 Faster, 149 Level, 95 Slower

```json
{"items": "16", "metric": "cycles", "new_per_item": "304.4438", "old_per_item": "294.6982", "ratio_permille": "1033", "shape": "distinct_keys_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "713.8643", "old_per_item": "692.5574", "ratio_permille": "1031", "shape": "distinct_keys_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "139.5942", "old_per_item": "135.5259", "ratio_permille": "1030", "shape": "distinct_keys_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "306.9785", "old_per_item": "296.9941", "ratio_permille": "1034", "shape": "distinct_keys_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "713.8633", "old_per_item": "692.5562", "ratio_permille": "1031", "shape": "distinct_keys_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "137.6507", "old_per_item": "133.3104", "ratio_permille": "1032", "shape": "distinct_keys_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "299.7482", "old_per_item": "290.9368", "ratio_permille": "1030", "shape": "distinct_keys_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "716.5083", "old_per_item": "690.8543", "ratio_permille": "1037", "shape": "distinct_keys_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "303.7555", "old_per_item": "292.9375", "ratio_permille": "1037", "shape": "distinct_keys_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "716.4715", "old_per_item": "690.8297", "ratio_permille": "1037", "shape": "distinct_keys_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "137.9998", "old_per_item": "132.7660", "ratio_permille": "1039", "shape": "distinct_keys_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "294.3755", "old_per_item": "283.5994", "ratio_permille": "1038", "shape": "distinct_keys_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "705.9518", "old_per_item": "683.0379", "ratio_permille": "1034", "shape": "distinct_keys_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "142.2713", "old_per_item": "135.4482", "ratio_permille": "1050", "shape": "distinct_keys_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "195.9253", "old_per_item": "188.7196", "ratio_permille": "1038", "shape": "distinct_keys_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "304.8566", "old_per_item": "288.9800", "ratio_permille": "1055", "shape": "distinct_keys_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "705.8573", "old_per_item": "682.8698", "ratio_permille": "1034", "shape": "distinct_keys_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "747.7832", "old_per_item": "721.0898", "ratio_permille": "1037", "shape": "distinct_keys_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "141.7817", "old_per_item": "136.5024", "ratio_permille": "1039", "shape": "distinct_keys_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "283.0850", "old_per_item": "274.1748", "ratio_permille": "1032", "shape": "distinct_keys_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "336.4399", "old_per_item": "323.7891", "ratio_permille": "1039", "shape": "distinct_keys_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "747.8076", "old_per_item": "721.0845", "ratio_permille": "1037", "shape": "distinct_keys_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "142.0615", "old_per_item": "137.1025", "ratio_permille": "1036", "shape": "mixed_modes_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "cpu_ns", "new_per_item": "283.0977", "old_per_item": "274.7856", "ratio_permille": "1030", "shape": "mixed_modes_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "337.8472", "old_per_item": "324.9150", "ratio_permille": "1040", "shape": "mixed_modes_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "747.7700", "old_per_item": "721.0669", "ratio_permille": "1037", "shape": "mixed_modes_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "713.8638", "old_per_item": "692.5586", "ratio_permille": "1031", "shape": "mixed_modes_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "713.8706", "old_per_item": "692.5581", "ratio_permille": "1031", "shape": "mixed_modes_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "306.4009", "old_per_item": "295.8586", "ratio_permille": "1036", "shape": "mixed_modes_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "713.8625", "old_per_item": "692.5559", "ratio_permille": "1031", "shape": "mixed_modes_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "716.5011", "old_per_item": "690.8504", "ratio_permille": "1037", "shape": "mixed_modes_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "303.7355", "old_per_item": "294.2560", "ratio_permille": "1032", "shape": "mixed_modes_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "716.4977", "old_per_item": "690.8438", "ratio_permille": "1037", "shape": "mixed_modes_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "137.6626", "old_per_item": "132.6517", "ratio_permille": "1038", "shape": "mixed_modes_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "293.6263", "old_per_item": "283.1395", "ratio_permille": "1037", "shape": "mixed_modes_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "705.9564", "old_per_item": "683.0339", "ratio_permille": "1034", "shape": "mixed_modes_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "142.9395", "old_per_item": "134.0334", "ratio_permille": "1066", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "196.9647", "old_per_item": "187.1178", "ratio_permille": "1053", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "305.5618", "old_per_item": "287.5921", "ratio_permille": "1062", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "705.8534", "old_per_item": "682.9102", "ratio_permille": "1034", "shape": "mixed_modes_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "747.8154", "old_per_item": "721.0869", "ratio_permille": "1037", "shape": "mixed_modes_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "335.5835", "old_per_item": "324.8438", "ratio_permille": "1033", "shape": "mixed_modes_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "747.8374", "old_per_item": "721.0259", "ratio_permille": "1037", "shape": "mixed_modes_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "337.9004", "old_per_item": "321.8506", "ratio_permille": "1050", "shape": "plain_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "747.7725", "old_per_item": "721.0869", "ratio_permille": "1037", "shape": "plain_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "15", "metric": "cpu_ns", "new_per_item": "217.1927", "old_per_item": "208.4576", "ratio_permille": "1042", "shape": "plain_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "15", "metric": "cycles", "new_per_item": "308.3247", "old_per_item": "296.6742", "ratio_permille": "1039", "shape": "plain_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "139.5762", "old_per_item": "134.8257", "ratio_permille": "1035", "shape": "plain_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "713.8442", "old_per_item": "692.5574", "ratio_permille": "1031", "shape": "plain_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "304.2612", "old_per_item": "293.8035", "ratio_permille": "1036", "shape": "plain_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "713.8689", "old_per_item": "692.5588", "ratio_permille": "1031", "shape": "plain_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "713.8594", "old_per_item": "692.5547", "ratio_permille": "1031", "shape": "plain_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "301.4531", "old_per_item": "292.3892", "ratio_permille": "1031", "shape": "plain_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "716.4924", "old_per_item": "690.8295", "ratio_permille": "1037", "shape": "plain_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "139.2107", "old_per_item": "134.5591", "ratio_permille": "1035", "shape": "plain_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "302.7098", "old_per_item": "292.9136", "ratio_permille": "1033", "shape": "plain_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "716.4844", "old_per_item": "690.8523", "ratio_permille": "1037", "shape": "plain_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "705.9562", "old_per_item": "683.0407", "ratio_permille": "1034", "shape": "plain_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "142.9012", "old_per_item": "134.4313", "ratio_permille": "1063", "shape": "plain_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "196.3696", "old_per_item": "187.2358", "ratio_permille": "1049", "shape": "plain_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "304.7715", "old_per_item": "289.0078", "ratio_permille": "1055", "shape": "plain_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "705.8493", "old_per_item": "682.9025", "ratio_permille": "1034", "shape": "plain_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "140.4316", "old_per_item": "134.6475", "ratio_permille": "1043", "shape": "plain_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "334.6367", "old_per_item": "319.7710", "ratio_permille": "1046", "shape": "plain_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "747.8037", "old_per_item": "721.0718", "ratio_permille": "1037", "shape": "plain_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "141.4863", "old_per_item": "136.4746", "ratio_permille": "1037", "shape": "plain_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "335.7485", "old_per_item": "323.9062", "ratio_permille": "1037", "shape": "plain_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "747.7969", "old_per_item": "721.0464", "ratio_permille": "1037", "shape": "plain_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "128", "metric": "wall_ns", "new_per_item": "141.9541", "old_per_item": "137.6600", "ratio_permille": "1031", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "128", "metric": "cpu_ns", "new_per_item": "153.4205", "old_per_item": "148.7792", "ratio_permille": "1031", "shape": "shared_key_open128_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "139.3765", "old_per_item": "134.2871", "ratio_permille": "1038", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "304.5662", "old_per_item": "293.6460", "ratio_permille": "1037", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "713.8564", "old_per_item": "692.5493", "ratio_permille": "1031", "shape": "shared_key_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "16", "metric": "instructions", "new_per_item": "713.8606", "old_per_item": "692.5481", "ratio_permille": "1031", "shape": "shared_key_open16_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "300.8835", "old_per_item": "290.7838", "ratio_permille": "1035", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "716.4885", "old_per_item": "690.8617", "ratio_permille": "1037", "shape": "shared_key_open17_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "139.3302", "old_per_item": "134.3061", "ratio_permille": "1037", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "303.0570", "old_per_item": "293.3155", "ratio_permille": "1033", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "17", "metric": "instructions", "new_per_item": "716.4832", "old_per_item": "690.8612", "ratio_permille": "1037", "shape": "shared_key_open17_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "138.4907", "old_per_item": "132.6558", "ratio_permille": "1044", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "186.3384", "old_per_item": "179.9149", "ratio_permille": "1036", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "293.9427", "old_per_item": "283.2401", "ratio_permille": "1038", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "705.9552", "old_per_item": "683.0389", "ratio_permille": "1034", "shape": "shared_key_open24_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "wall_ns", "new_per_item": "143.9256", "old_per_item": "134.5384", "ratio_permille": "1070", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "cpu_ns", "new_per_item": "197.6387", "old_per_item": "188.0260", "ratio_permille": "1051", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "cycles", "new_per_item": "305.6637", "old_per_item": "289.5623", "ratio_permille": "1056", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "24", "metric": "instructions", "new_per_item": "705.8455", "old_per_item": "682.8984", "ratio_permille": "1034", "shape": "shared_key_open24_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "512", "metric": "wall_ns", "new_per_item": "164.0733", "old_per_item": "157.2607", "ratio_permille": "1043", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "512", "metric": "cpu_ns", "new_per_item": "167.3609", "old_per_item": "160.4720", "ratio_permille": "1043", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "512", "metric": "cycles", "new_per_item": "328.6263", "old_per_item": "314.4881", "ratio_permille": "1045", "shape": "shared_key_open512_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "334.2671", "old_per_item": "320.6250", "ratio_permille": "1043", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "747.8101", "old_per_item": "721.0796", "ratio_permille": "1037", "shape": "shared_key_open8_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "wall_ns", "new_per_item": "142.8203", "old_per_item": "136.2900", "ratio_permille": "1048", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "cycles", "new_per_item": "336.6416", "old_per_item": "323.3931", "ratio_permille": "1041", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```

```json
{"items": "8", "metric": "instructions", "new_per_item": "747.8262", "old_per_item": "721.0664", "ratio_permille": "1037", "shape": "shared_key_open8_len32768_piece4096", "verdict": "Slower", "versus": "old-finish"}
```
[out/judgments-update.tsv](out/judgments-update.tsv): 148 Faster, 172 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `4f1dd19c83122dfee2c62c1304eb593b812ee992`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
