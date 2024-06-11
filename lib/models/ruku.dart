
class Sura {
  final int ayas;
  final int index;
  final bool isMakki;
  final String name;
  final int rukus;

  Sura({
    required this.ayas,
    required this.index,
    required this.isMakki,
    required this.name,
    required this.rukus,
  });

  factory Sura.fromJson(Map<String, dynamic> json) {
    return Sura(
      ayas: json['ayas'],
      index: json['index'],
      isMakki: json['is_makki'],
      name: json['name'],
      rukus: json['rukus'],
    );
  }
}

class Ruku {

  static const int lastRukuIndex = 556;

  final List<String> ayat;
  final int firstAya;
  final int sajdaAya;
  final int index;
  final int lastAya;
  final Sura sura;

  Ruku({
    required this.ayat,
    required this.firstAya,
    required this.sajdaAya,
    required this.index,
    required this.lastAya,
    required this.sura,
  });

  bool get isLast => index == lastRukuIndex;

  factory Ruku.fromJson(Map<String, dynamic> json) {
    return Ruku(
      ayat: List<String>.from(json['ayat']),
      firstAya: json['first_aya'],
      sajdaAya: json['sajda_aya'],
      index: json['index'],
      lastAya: json['last_aya'],
      sura: Sura.fromJson(json['sura']),
    );
  }


  @override
  String toString() {
      return "Ruku($index,${sura.name},$firstAya,$lastAya)";
  }
}
