import 'package:algeria_cities/algeria_cities.dart';
import 'package:test/test.dart';

void main() {
  test('69 wilayas, 1541 communes', () {
    expect(AlgeriaCities.wilayas.length, 69);
    expect(AlgeriaCities.communes.length, 1541);
  });

  test('every wilaya has communes', () {
    for (final w in AlgeriaCities.wilayas) {
      expect(AlgeriaCities.communesOf(w.code), isNotEmpty, reason: w.name);
    }
  });

  test('Oran communes', () {
    final names = AlgeriaCities.communesOf(31).map((c) => c.name);
    expect(names, containsAll(['Oran', 'Bir El Djir', 'Es Senia', 'Arzew']));
    expect(AlgeriaCities.wilaya(31)?.name, 'Oran');
  });

  test('search', () {
    expect(AlgeriaCities.search('bir el djir').first.wilayaCode, 31);
  });

  test('search by wilaya code', () {
    final communes = AlgeriaCities.search('28');
    expect(communes, isNotEmpty);
    expect(communes.every((c) => c.wilayaCode == 28), isTrue);
    expect(AlgeriaCities.wilaya(28)?.name, "M'Sila");
  });

  test('searchWilayas', () {
    expect(AlgeriaCities.searchWilayas('28'), [AlgeriaCities.wilaya(28)]);
    expect(AlgeriaCities.searchWilayas('msila').single.code, 28);
    expect(AlgeriaCities.searchWilayas('999'), isEmpty);
  });

  test('dairas', () {
    expect(AlgeriaCities.dairas, isNotEmpty);
    for (final w in AlgeriaCities.wilayas) {
      expect(AlgeriaCities.dairasOf(w.code), isNotEmpty, reason: w.name);
    }
    final oranDairas = AlgeriaCities.dairasOf(31);
    expect(oranDairas.map((d) => d.name), contains('Oran'));

    final oranDaira = oranDairas.firstWhere((d) => d.name == 'Oran');
    final communes = AlgeriaCities.communesOfDaira(oranDaira);
    expect(communes, isNotEmpty);
    expect(
        communes.every((c) => c.daira == 'Oran' && c.wilayaCode == 31), isTrue);
  });

  test('locations', () {
    final commune = AlgeriaCities.communesOf(31).first;
    expect(commune.latitude, isNot(0));
    expect(commune.longitude, isNot(0));

    final daira = AlgeriaCities.dairasOf(31).first;
    expect(daira.latitude, isNot(0));
    expect(daira.longitude, isNot(0));
  });

  test('localized names', () {
    final oran = AlgeriaCities.wilaya(31)!;
    expect(oran.localizedName(), 'Oran');
    expect(oran.localizedName(AlgeriaLanguage.fr), 'Oran');
    expect(oran.localizedName(AlgeriaLanguage.ar), oran.nameAr);

    final commune = AlgeriaCities.communesOf(31).first;
    expect(commune.localizedName(AlgeriaLanguage.ar), commune.nameAr);
    expect(commune.localizedDaira(AlgeriaLanguage.ar), commune.dairaAr);

    final daira = AlgeriaCities.dairasOf(31).first;
    expect(daira.localizedName(AlgeriaLanguage.ar), daira.nameAr);
  });
}
