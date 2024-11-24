class Vehicle {
  int id;
  int plateSourceId;
  // String plateType;
  int plateCodeId;
  String plateNumber;
  bool isPrimary;

  Vehicle({
    required this.id,
    required this.plateSourceId,
    // required this.plateType,
    required this.plateCodeId,
    required this.plateNumber,
    required this.isPrimary,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plateSource': plateSourceId,
      // 'plateType': plateType,
      'plateCode': plateCodeId,
      'plateNumber': plateNumber,
      'isPrimary': isPrimary,
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      plateSourceId: json['plateSource'] as int,
      // plateType: json['plateType'] as String,
      plateCodeId: json['plateCode'] as int,
      plateNumber: json['plateNumber'] as String,
      isPrimary: json['isPrimary'] as bool,
    );
  }
}
