## 1.2.0

- Add `AlgeriaLanguage` (`fr`/`ar`) and `localizedName([language])` on
  `Wilaya`, `Daira` and `Commune` (plus `localizedDaira([language])` on
  `Commune`), to read a place's name in a chosen language without branching
  on `.name` vs `.nameAr` manually.

## 1.1.0

- Add `Daira` model and `AlgeriaCities.dairas`, `dairasOf(wilayaCode)`,
  `communesOfDaira(daira)` to query dairas independently of communes.
- `Daira` now carries `latitude`/`longitude`, the centroid of its communes'
  coordinates (no standalone daira-level GPS point exists in the source data).
  `Commune.latitude`/`longitude` were already available.
- `AlgeriaCities.search` now accepts a numeric query (e.g. `'28'`) and
  returns that wilaya's communes (e.g. `28` -> M'Sila). Added
  `AlgeriaCities.searchWilayas(query)` to search wilayas by code or by
  French/Arabic name, apostrophe-insensitive.

## 1.0.0

- Initial release: 69 wilayas, 1,541 communes.
