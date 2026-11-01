## 1.0.1

- Add pub.dev `topics` (`algeria`, `geography`, `localization`, `offline`,
  `dataset`) to improve search discoverability and topic-based browsing.

## 1.0.0

Initial release under the name `algeria_wilayas_dairas_communes` — a rename
of what was previously published as `algeria_cities` (up to 1.2.2). All
features carry over:

- 69 wilayas and 1,541 communes, offline, in French and Arabic.
- `Daira` model derived from commune data, including a centroid GPS point.
- `AlgeriaCities.search` (by name, FR/AR, or by wilaya number) and
  `AlgeriaCities.searchWilayas` (by code or name, apostrophe-insensitive).
- `localizedName`/`localizedDaira` on every model to read a name in a chosen
  `AlgeriaLanguage` (`fr`/`ar`) without branching on `.name` vs `.nameAr`.
