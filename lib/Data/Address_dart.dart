class Address {
  final String id;
  final String houseAddress;
  final String ward;
  final String district;
  final String province;
  final bool isDefault;

  Address({
    required this.id,
    required this.houseAddress,
    required this.ward,
    required this.district,
    required this.province,
    required this.isDefault,
  });

  // Convert Address to Map
  Map<String, dynamic> toMap() {
    return {
      'houseAddress': houseAddress,
      'ward': ward,
      'district': district,
      'province': province,
      'isDefault': isDefault,
    };
  }

  // Convert Map to Address
  factory Address.fromMap(Map<String, dynamic> map, String id) {
    return Address(
      id: id,
      houseAddress: map['houseAddress'] ?? '',
      ward: map['ward'] ?? '',
      district: map['district'] ?? '',
      province: map['province'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }
}
