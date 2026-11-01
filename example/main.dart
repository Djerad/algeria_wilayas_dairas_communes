// Run with: dart run example/main.dart
import 'package:algeria_wilayas_dairas_communes/algeria_wilayas_dairas_communes.dart';

void main() {
  print('${AlgeriaCities.wilayas.length} wilayas, '
      '${AlgeriaCities.communes.length} communes, '
      '${AlgeriaCities.dairas.length} dairas loaded.\n');

  // Look up a wilaya by its official code.
  final oran = AlgeriaCities.wilaya(31)!;
  print('Wilaya 31: ${oran.name} / ${oran.nameAr}');

  // List its dairas.
  print('\nDairas of ${oran.name}:');
  for (final d in AlgeriaCities.dairasOf(oran.code)) {
    print(
        '- ${d.name} / ${d.nameAr} (centroid ${d.latitude.toStringAsFixed(3)}, '
        '${d.longitude.toStringAsFixed(3)})');
  }

  // List the communes of one daira.
  final oranDaira = AlgeriaCities.dairasOf(oran.code).first;
  print('\nCommunes of daira ${oranDaira.name}:');
  for (final c in AlgeriaCities.communesOfDaira(oranDaira)) {
    print('- ${c.name} / ${c.nameAr} (${c.latitude}, ${c.longitude})');
  }

  // Search communes by name, in French or Arabic.
  print('\nSearch "bir el":');
  for (final c in AlgeriaCities.search('bir el')) {
    print('- ${c.name} (wilaya ${c.wilayaCode})');
  }

  // A purely numeric query is treated as a wilaya code.
  print('\nSearch "28" (numeric -> wilaya code):');
  for (final c in AlgeriaCities.search('28')) {
    print('- ${c.name}');
  }

  // Search wilayas directly, by code or by name (apostrophe-insensitive).
  print('\nsearchWilayas("msila"): ${AlgeriaCities.searchWilayas('msila')}');
  print('searchWilayas("28"): ${AlgeriaCities.searchWilayas('28')}');

  // Read any name in a chosen language instead of picking `.name`/`.nameAr`
  // by hand.
  print('\nLocalized names (${oran.name}):');
  print('  FR: ${oran.localizedName(AlgeriaLanguage.fr)}');
  print('  AR: ${oran.localizedName(AlgeriaLanguage.ar)}');

  final commune = AlgeriaCities.communesOf(oran.code).first;
  print('${commune.localizedName(AlgeriaLanguage.fr)} is in daira '
      '${commune.localizedDaira(AlgeriaLanguage.ar)}');
}
