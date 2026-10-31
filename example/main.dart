import 'package:algeria_cities/algeria_cities.dart';

void main() {
  final oran = AlgeriaCities.wilaya(31)!;
  print('${oran.name} (${oran.nameAr})');
  for (final c in AlgeriaCities.communesOf(oran.code)) {
    print('- ${c.name} / ${c.nameAr}');
  }
}
