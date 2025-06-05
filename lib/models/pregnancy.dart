class Pregnancy {
  final int? id;
  final DateTime lastPeriod;
  final String? notes;

  Pregnancy({this.id, required this.lastPeriod, this.notes});

  int get months =>
      ((DateTime.now().difference(lastPeriod).inDays) / 30.44).floor() + 1;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lastPeriod': lastPeriod.toIso8601String(),
      'notes': notes,
    };
  }

  factory Pregnancy.fromMap(Map<String, dynamic> map) {
    return Pregnancy(
      id: map['id'],
      lastPeriod: DateTime.parse(map['lastPeriod']),
      notes: map['notes'],
    );
  }
}
