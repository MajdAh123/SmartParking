class Ticket {
  int id;
  int carId;
  String emirate;
  DateTime startTime;
  DateTime endTime;
  String duration;
  double cost;
  String zoneCode;
  String zoneNumber;

  Ticket({
    required this.id,
    required this.carId,
    required this.emirate,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.cost,
    required this.zoneCode,
    required this.zoneNumber,
  });

  // Method to convert a JSON map to a Ticket instance
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      carId: json['carId'],
      emirate: json['emirate'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      duration: json['duration'],
      cost: json['cost'],
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
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration,
      'cost': cost,
      'zoneCode': zoneCode,
      'zoneNumber': zoneNumber,
    };
  }
}
