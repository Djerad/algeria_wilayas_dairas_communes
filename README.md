# algeria_cities

All **69 wilayas**, their **dairas** (districts), and **1,541 communes** of Algeria, offline — in French and Arabic, with GPS coordinates. Pure Dart with zero dependencies, so it works the same in a Flutter app, a CLI tool, or a server.

## Features

- **69 wilayas** — code, French name, Arabic name.
- **1,541 communes** — French/Arabic name, parent daira, latitude/longitude.
- **Dairas** derived on the fly from the commune data — no separate dataset to keep in sync — including a centroid GPS point per daira.
- **Search** by French or Arabic name, or by wilaya number (`'28'` resolves to M'Sila).
- **Language-aware names** — `localizedName(AlgeriaLanguage.fr | .ar)` on every model, so you can render an entire list in either language without branching on `.name` vs `.nameAr` everywhere.
- **Fully offline**: no network calls, no asset loading, just Dart constants — works before `main()` even starts and in tests with no setup.
- No dependencies, no Flutter requirement in the library itself.

## Install

This package isn't published to pub.dev yet. Use a path (or git) dependency:

```yaml
dependencies:
  algeria_cities:
    path: ../algeria_cities   # adjust to wherever this folder lives
```

Then:

```bash
dart pub get     # or: flutter pub get
```

## Usage

```dart
import 'package:algeria_cities/algeria_cities.dart';

// Wilayas
AlgeriaCities.wilayas;              // List<Wilaya>, all 69, ordered by code
AlgeriaCities.wilaya(31);            // Wilaya? — Oran, or null if the code doesn't exist

// Communes
AlgeriaCities.communes;              // List<Commune>, all 1,541
AlgeriaCities.communesOf(31);        // List<Commune> — Oran's communes, sorted by name

// Dairas
AlgeriaCities.dairas;                // List<Daira>, all dairas, deduplicated
AlgeriaCities.dairasOf(31);          // List<Daira> — Oran's dairas, sorted by name
AlgeriaCities.communesOfDaira(d);    // List<Commune> — communes within one daira

// Search
AlgeriaCities.search('bir el');      // communes matching by name (FR or AR)
AlgeriaCities.search('28');          // numeric query -> all communes of wilaya 28 (M'Sila)
AlgeriaCities.searchWilayas('28');   // -> [M'Sila], by code
AlgeriaCities.searchWilayas('msila'); // -> [M'Sila], by name, apostrophe-insensitive

// Locations
final c = AlgeriaCities.communesOf(31).first;
c.latitude; c.longitude;             // the commune's own GPS point

final d = AlgeriaCities.dairasOf(31).first;
d.latitude; d.longitude;             // centroid of that daira's communes

// Choosing a language
final oran = AlgeriaCities.wilaya(31)!;
oran.localizedName();                   // 'Oran' (defaults to French)
oran.localizedName(AlgeriaLanguage.ar); // 'وهران'

final commune = AlgeriaCities.communesOf(31).first;
commune.localizedName(AlgeriaLanguage.ar);  // commune name in Arabic
commune.localizedDaira(AlgeriaLanguage.ar); // its daira's name in Arabic

// Build a language-aware label list, e.g. for a dropdown:
final lang = AlgeriaLanguage.ar;
final labels = AlgeriaCities.wilayas.map((w) => w.localizedName(lang)).toList();
```

### In Flutter

See [`example/flutter_dropdowns.dart`](example/flutter_dropdowns.dart) for a ready-made wilaya → commune picker:

```dart
import 'package:algeria_cities/algeria_cities.dart';
import 'package:flutter/material.dart';

const WilayaCommunePicker()
```

### Plain Dart

See [`example/main.dart`](example/main.dart):

```bash
dart run example/main.dart
```

## API reference

| Model    | Fields | Localized accessors |
|----------|--------|---|
| `Wilaya` | `code`, `name`, `nameAr` | `localizedName([language])` |
| `Daira`  | `wilayaCode`, `name`, `nameAr`, `latitude`, `longitude` (centroid) | `localizedName([language])` |
| `Commune`| `id`, `wilayaCode`, `name`, `nameAr`, `daira`, `dairaAr`, `latitude`, `longitude` | `localizedName([language])`, `localizedDaira([language])` |

`language` is an `AlgeriaLanguage` (`fr` or `ar`), defaulting to `fr`.

| Method | Returns | Notes |
|---|---|---|
| `AlgeriaCities.wilayas` | `List<Wilaya>` | all 69, ordered by code |
| `AlgeriaCities.wilaya(code)` | `Wilaya?` | null if `code` doesn't exist |
| `AlgeriaCities.communes` | `List<Commune>` | all 1,541 |
| `AlgeriaCities.communesOf(wilayaCode)` | `List<Commune>` | sorted by name |
| `AlgeriaCities.dairas` | `List<Daira>` | deduplicated, sorted by wilaya then name |
| `AlgeriaCities.dairasOf(wilayaCode)` | `List<Daira>` | sorted by name |
| `AlgeriaCities.communesOfDaira(daira)` | `List<Commune>` | sorted by name |
| `AlgeriaCities.search(query, {wilayaCode})` | `List<Commune>` | name match (FR/AR), or numeric `query` → that wilaya's communes |
| `AlgeriaCities.searchWilayas(query)` | `List<Wilaya>` | exact code match, or name match (FR/AR, apostrophe-insensitive) |

## Data

Vendored from [ihahachi/algeria-cities](https://github.com/ihahachi/algeria-cities) (MIT) as a static snapshot — nothing is fetched at runtime. Dairas and their centroid coordinates are derived from the commune data at build time, not shipped as a separate dataset.

To refresh from a newer source snapshot:

```bash
# replace tool/algeria_cities.json with the updated data, then:
python3 tool/generate.py
```

This regenerates `lib/src/data.dart`. Do not edit that file by hand — it's marked as generated.

## Development

```bash
dart pub get
dart analyze
dart test
dart format --output=none --set-exit-if-changed .   # CI-style formatting check
```

## License

MIT — see [LICENSE](LICENSE). Data is MIT-licensed by its original source, credited above.
