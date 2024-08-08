class Reminder {
  int id;
  int carId;
  String emirate;
  DateTime reminderMeOn;
  String reminderMeBefore;

  String zoneCode;
  String zoneNumber;

  Reminder({
    required this.id,
    required this.carId,
    required this.emirate,
    required this.reminderMeOn,
    required this.reminderMeBefore,
    required this.zoneCode,
    required this.zoneNumber,
  });

  // Method to convert a JSON map to a Reminder instance
  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      carId: json['carId'],
      emirate: json['emirate'],
      reminderMeOn: DateTime.parse(json['reminderMeOn']),
      reminderMeBefore: json['reminderMeBefore'],
      zoneCode: json['zoneCode'],
      zoneNumber: json['zoneNumber'],
    );
  }

  // Method to convert a Ticket instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carId': carId,
      'emirate': emirate,
      'reminderMeOn': reminderMeOn.toIso8601String(),
      'reminderMeBefore': reminderMeBefore,
      'zoneCode': zoneCode,
      'zoneNumber': zoneNumber,
    };
  }
}
