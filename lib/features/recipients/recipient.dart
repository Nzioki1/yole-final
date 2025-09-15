/// Recipient model for money transfer
class Recipient {
  final String id;
  final String name;
  final String phone;

  const Recipient({required this.id, required this.name, required this.phone});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recipient &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          phone == other.phone;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ phone.hashCode;

  @override
  String toString() => 'Recipient(id: $id, name: $name, phone: $phone)';
}
