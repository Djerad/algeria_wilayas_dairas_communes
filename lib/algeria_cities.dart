/// All 69 Algerian wilayas and their 1,541 communes, offline.
library;

import 'src/data.dart';
import 'src/models.dart';

export 'src/models.dart';

/// Access to Algerian wilayas and communes.
class AlgeriaCities {
  AlgeriaCities._();

  /// All 69 wilayas, ordered by code.
  static List<Wilaya> get wilayas => kWilayas;

  /// All 1,541 communes.
  static List<Commune> get communes => kCommunes;

  /// All dairas (districts), deduplicated from communes, ordered by wilaya
  /// code then name. There is no standalone daira id in the source data, so
  /// a daira is identified by (wilayaCode, name); its [Daira.latitude]/
  /// [Daira.longitude] are the centroid of its communes' coordinates.
  static List<Daira> get dairas => _dairas;

  static final List<Daira> _dairas = () {
    final byKey = <String, List<Commune>>{};
    for (final c in kCommunes) {
      byKey.putIfAbsent('${c.wilayaCode}|${c.daira}', () => []).add(c);
    }
    final list = byKey.values.map((members) {
      final first = members.first;
      final lat = members.map((c) => c.latitude).reduce((a, b) => a + b) /
          members.length;
      final lng = members.map((c) => c.longitude).reduce((a, b) => a + b) /
          members.length;
      return Daira(
        wilayaCode: first.wilayaCode,
        name: first.daira,
        nameAr: first.dairaAr,
        latitude: lat,
        longitude: lng,
      );
    }).toList()
      ..sort((a, b) => a.wilayaCode != b.wilayaCode
          ? a.wilayaCode.compareTo(b.wilayaCode)
          : a.name.compareTo(b.name));
    return list;
  }();

  /// All dairas of the wilaya with [wilayaCode], sorted by name.
  static List<Daira> dairasOf(int wilayaCode) =>
      _dairas.where((d) => d.wilayaCode == wilayaCode).toList();

  /// All communes belonging to [daira] (within its wilaya), sorted by name.
  static List<Commune> communesOfDaira(Daira daira) => kCommunes
      .where((c) => c.wilayaCode == daira.wilayaCode && c.daira == daira.name)
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));

  /// The wilaya with [code], or null.
  static Wilaya? wilaya(int code) {
    for (final w in kWilayas) {
      if (w.code == code) return w;
    }
    return null;
  }

  /// All communes of the wilaya with [wilayaCode], sorted by name.
  static List<Commune> communesOf(int wilayaCode) =>
      kCommunes.where((c) => c.wilayaCode == wilayaCode).toList();

  /// Searches communes by French or Arabic name (case-insensitive), or, if
  /// [query] is purely numeric (e.g. `'28'`), returns all communes of the
  /// wilaya with that code (e.g. `28` -> M'Sila's communes).
  static List<Commune> search(String query, {int? wilayaCode}) {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final code = int.tryParse(q);
    if (code != null) {
      return communesOf(code)
          .where((c) => wilayaCode == null || c.wilayaCode == wilayaCode)
          .toList();
    }
    final lower = q.toLowerCase();
    return kCommunes
        .where((c) =>
            (wilayaCode == null || c.wilayaCode == wilayaCode) &&
            (c.name.toLowerCase().contains(lower) || c.nameAr.contains(lower)))
        .toList();
  }

  /// Searches wilayas by code (exact match, e.g. `'28'` -> M'Sila) or by
  /// French/Arabic name (case-insensitive, substring match).
  static List<Wilaya> searchWilayas(String query) {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final code = int.tryParse(q);
    if (code != null) {
      final w = wilaya(code);
      return w == null ? const [] : [w];
    }
    final lower = _normalize(q);
    return kWilayas
        .where(
            (w) => _normalize(w.name).contains(lower) || w.nameAr.contains(q))
        .toList();
  }

  /// Lowercases and strips apostrophes, so `"msila"` matches `"M'Sila"`.
  static String _normalize(String s) => s.toLowerCase().replaceAll("'", '');
}
