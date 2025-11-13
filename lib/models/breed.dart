class EachBreed {
  final String name;
  final int acc;

  EachBreed({required this.name, required this.acc});

  factory EachBreed.fromMap(MapEntry<String, double> entry) {
    return EachBreed(name: entry.key, acc: (entry.value * 100).toInt());
  }

  Map<String, dynamic> toJson() => {'name': name, 'acc': acc};
}
