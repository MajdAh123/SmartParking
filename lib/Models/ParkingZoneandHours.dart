class ParkingZone {
  final String city;
  final String zone;
  final double hours;
  final double parkingPrice;
  final double smsPrice;
  final double totalPrice;
  final String normalTimeFrom;
  final String normalTimeTo;
  final String ramadanTimeFrom;
  final String ramadanTimeTo;
  final String dayFrom;
  final String dayTo;
  final String weekend;
  final double? maxHours;

  ParkingZone(
      {required this.city,
      required this.zone,
      required this.hours,
      required this.parkingPrice,
      required this.smsPrice,
      required this.totalPrice,
      required this.normalTimeFrom,
      required this.normalTimeTo,
      required this.ramadanTimeFrom,
      required this.ramadanTimeTo,
      required this.dayFrom,
      required this.dayTo,
      required this.weekend,
      this.maxHours});
}
