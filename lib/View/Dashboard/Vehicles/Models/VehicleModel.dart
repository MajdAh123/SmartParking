class Vehicle {
  int id;
  String plateSource;
  String plateType;
  String plateCode;
  String plateNumber;
  bool isPrimary;

  Vehicle({
    required this.id,
    required this.plateSource,
    required this.plateType,
    required this.plateCode,
    required this.plateNumber,
    required this.isPrimary,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plateSource': plateSource,
      'plateType': plateType,
      'plateCode': plateCode,
      'plateNumber': plateNumber,
      'isPrimary': isPrimary,
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      plateSource: json['plateSource'] as String,
      plateType: json['plateType'] as String,
      plateCode: json['plateCode'] as String,
      plateNumber: json['plateNumber'] as String,
      isPrimary: json['isPrimary'] as bool,
    );
  }
}
