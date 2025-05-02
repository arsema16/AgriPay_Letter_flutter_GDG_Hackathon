class Farmer {
  final String id;
  final String name;
  final String idNumber;
  final String phone;
  final String email;
  final String role;
  final double? landSize;
  final String? cropType;
  final String? soilSelfieUrl;

  Farmer({
    required this.id,
    required this.name,
    required this.idNumber,
    required this.phone,
    required this.email,
    required this.role,
    this.landSize,
    this.cropType,
    this.soilSelfieUrl,
  });
}
