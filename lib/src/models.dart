/// A language to read a place's name in. Every model here only has French
/// and Arabic names, matching the source data.
enum AlgeriaLanguage { fr, ar }

/// An Algerian wilaya (province).
class Wilaya {
  /// Official code, 1 to 69.
  final int code;

  /// French/Latin name.
  final String name;

  /// Arabic name.
  final String nameAr;

  const Wilaya({required this.code, required this.name, required this.nameAr});

  /// This wilaya's name in [language] (defaults to French).
  String localizedName([AlgeriaLanguage language = AlgeriaLanguage.fr]) =>
      language == AlgeriaLanguage.ar ? nameAr : name;

  @override
  String toString() => '$code - $name';
}

/// An Algerian daira (district), the administrative layer between wilaya
/// and commune. Derived from [Commune.daira]/[Commune.dairaAr] — there is no
/// separate daira id in the source data.
class Daira {
  /// Code of the parent wilaya.
  final int wilayaCode;

  /// French/Latin name.
  final String name;

  /// Arabic name.
  final String nameAr;

  /// Centroid latitude, averaged from the daira's communes (there is no
  /// standalone daira-level coordinate in the source data).
  final double latitude;

  /// Centroid longitude, averaged from the daira's communes.
  final double longitude;

  const Daira({
    required this.wilayaCode,
    required this.name,
    required this.nameAr,
    required this.latitude,
    required this.longitude,
  });

  /// This daira's name in [language] (defaults to French).
  String localizedName([AlgeriaLanguage language = AlgeriaLanguage.fr]) =>
      language == AlgeriaLanguage.ar ? nameAr : name;

  @override
  bool operator ==(Object other) =>
      other is Daira && other.wilayaCode == wilayaCode && other.name == name;

  @override
  int get hashCode => Object.hash(wilayaCode, name);

  @override
  String toString() => name;
}

/// An Algerian commune (municipality).
class Commune {
  final int id;

  /// Code of the parent wilaya.
  final int wilayaCode;

  /// French/Latin name.
  final String name;

  /// Arabic name.
  final String nameAr;

  /// Daira (district) name, French/Latin.
  final String daira;

  /// Daira name, Arabic.
  final String dairaAr;

  final double latitude;
  final double longitude;

  const Commune({
    required this.id,
    required this.wilayaCode,
    required this.name,
    required this.nameAr,
    required this.daira,
    required this.dairaAr,
    required this.latitude,
    required this.longitude,
  });

  /// This commune's name in [language] (defaults to French).
  String localizedName([AlgeriaLanguage language = AlgeriaLanguage.fr]) =>
      language == AlgeriaLanguage.ar ? nameAr : name;

  /// This commune's daira name in [language] (defaults to French).
  String localizedDaira([AlgeriaLanguage language = AlgeriaLanguage.fr]) =>
      language == AlgeriaLanguage.ar ? dairaAr : daira;

  @override
  String toString() => name;
}
