# algeria_wilayas_dairas_communes

[![pub package](https://img.shields.io/pub/v/algeria_wilayas_dairas_communes.svg)](https://pub.dev/packages/algeria_wilayas_dairas_communes)
[![pub points](https://img.shields.io/pub/points/algeria_wilayas_dairas_communes)](https://pub.dev/packages/algeria_wilayas_dairas_communes/score)
[![likes](https://img.shields.io/pub/likes/algeria_wilayas_dairas_communes)](https://pub.dev/packages/algeria_wilayas_dairas_communes/score)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

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

```bash
dart pub add algeria_wilayas_dairas_communes     # or: flutter pub add algeria_wilayas_dairas_communes
```

Or add it manually to `pubspec.yaml`:

```yaml
dependencies:
  algeria_wilayas_dairas_communes: ^1.0.1
```

Then:

```bash
dart pub get     # or: flutter pub get
```

### Local/path dependency

Working against an unreleased local copy of this repo instead:

```yaml
dependencies:
  algeria_wilayas_dairas_communes:
    path: ../algeria_cities   # adjust to wherever this folder lives
```

## Usage

```dart
import 'package:algeria_wilayas_dairas_communes/algeria_wilayas_dairas_communes.dart';
```

### Get all wilayas

```dart
AlgeriaCities.wilayas; // List<Wilaya>, all 69, ordered by code
```

### Get a wilaya by code

```dart
AlgeriaCities.wilaya(31); // Wilaya? — Oran, or null if 31 doesn't exist
```

### Get all communes

```dart
AlgeriaCities.communes; // List<Commune>, all 1,541
```

### Get the communes of a wilaya

```dart
AlgeriaCities.communesOf(31); // List<Commune> — Oran's communes, sorted by name
```

### Get all dairas

```dart
AlgeriaCities.dairas; // List<Daira>, all dairas, deduplicated, sorted by wilaya then name
```

### Get the dairas of a wilaya

```dart
AlgeriaCities.dairasOf(31); // List<Daira> — Oran's dairas, sorted by name
```

### Get the communes of a daira

```dart
final daira = AlgeriaCities.dairasOf(31).first;
AlgeriaCities.communesOfDaira(daira); // List<Commune> — sorted by name
```

### Search communes by name

```dart
AlgeriaCities.search('bir el'); // matches by name, French or Arabic, case-insensitive
```

### Search communes by wilaya number

```dart
AlgeriaCities.search('28'); // a purely numeric query -> all communes of wilaya 28 (M'Sila)
```

### Search wilayas

```dart
AlgeriaCities.searchWilayas('28');    // -> [M'Sila], exact code match
AlgeriaCities.searchWilayas('msila'); // -> [M'Sila], by name, apostrophe-insensitive
AlgeriaCities.searchWilayas('مسيلة'); // -> [M'Sila], by Arabic name
```

### Get a commune's GPS location

```dart
final c = AlgeriaCities.communesOf(31).first;
c.latitude;  // the commune's own latitude
c.longitude; // the commune's own longitude
```

### Get a daira's GPS location

```dart
final d = AlgeriaCities.dairasOf(31).first;
d.latitude;  // centroid latitude, averaged from that daira's communes
d.longitude; // centroid longitude — there is no standalone daira-level point in the source data
```

### Choose the language

Every model (`Wilaya`, `Daira`, `Commune`) has a `localizedName([AlgeriaLanguage])` method, defaulting to French, so you never have to branch on `.name` vs `.nameAr` by hand:

```dart
final oran = AlgeriaCities.wilaya(31)!;
oran.localizedName();                   // 'Oran' (default: French)
oran.localizedName(AlgeriaLanguage.fr); // 'Oran'
oran.localizedName(AlgeriaLanguage.ar); // 'وهران'

final daira = AlgeriaCities.dairasOf(31).first;
daira.localizedName(AlgeriaLanguage.ar);

final commune = AlgeriaCities.communesOf(31).first;
commune.localizedName(AlgeriaLanguage.ar);  // the commune's own name in Arabic
commune.localizedDaira(AlgeriaLanguage.ar); // its parent daira's name in Arabic
```

Pick the language once and reuse it anywhere a list of names is needed, e.g. building dropdown labels:

```dart
final lang = AlgeriaLanguage.ar; // or .fr — e.g. from the user's locale/app setting
final labels = AlgeriaCities.wilayas.map((w) => w.localizedName(lang)).toList();
```

### In Flutter

See [`example/flutter_dropdowns.dart`](example/flutter_dropdowns.dart) for a ready-made wilaya → commune picker:

```dart
import 'package:algeria_wilayas_dairas_communes/algeria_wilayas_dairas_communes.dart';
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
