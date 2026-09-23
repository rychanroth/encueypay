/// A user address as offered at checkout. Slim, purpose-shaped duplicate —
/// features never import each other (ARCH-04); the server copies the chosen
/// address into the order as a historical snapshot (spec §17).
class AddressOption {
  const AddressOption({
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
