/// A user-owned shipping address (spec §17). Addresses are mutable before
/// checkout; the order later stores its own historical snapshot.
class Address {
  const Address({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.line1,
    this.line2,
    required this.city,
  });

  final String id;
  final String label;
  final String recipientName;
  final String phone;
  final String line1;
  final String? line2;
  final String city;
}

/// Input shape for creating/updating an address (no id, no timestamps).
class AddressDraft {
  const AddressDraft({
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.line1,
    this.line2,
    required this.city,
  });

  final String label;
  final String recipientName;
  final String phone;
  final String line1;
  final String? line2;
  final String city;

  Address toEntity(String id) => Address(
        id: id,
        label: label,
        recipientName: recipientName,
        phone: phone,
        line1: line1,
        line2: line2,
        city: city,
      );
}
