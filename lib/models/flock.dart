class Flock {
  final String id;
  final String enterpriseId;
  final String name;
  final String birdType;
  final int birdCount;
  final DateTime startDate;

  Flock({
    required this.id,
    required: this.enterpriseId,
    required this.name,
    required this.birdType,
    required this.birdCount,
    required this.startDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enterpriseId': enterpriseId,
      'name': name,
      'birdType': birdType,
      'birdCount': birdCount,
      'startDate': startDate.toIso8601String(),
    };
  }

  factory Flock.fromJson(Map<String, dynamic> json) {
    return Flock(
      id: json['id'],
      enterpriseId: json['enterpriseId'],
      name: json['name'],
      birdType: json['birdType'],
      birdCount: json['birdCount'],
      startDate: DateTime.parse(json['startDate']),
    );
  }
}
