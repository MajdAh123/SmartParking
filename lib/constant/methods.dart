import 'package:intl/intl.dart';

import '../View/Dashboard/Vehicles/Models/VehicleModel.dart';

class AppMethods {
  static String monthNumberToText(int monthNumber, int yearNumber) {
    // Ensure monthNumber is within valid range (1-12)

    // Create a DateTime object with the given month number (and arbitrary day and year)
    DateTime date = DateTime(yearNumber, monthNumber);

    // Format the DateTime object to get the month name
    String date_ = DateFormat('MMMM yyyy').format(date);

    return date_;
  }

  static String extractNumbers(String input) {
    // Use a regular expression to remove all non-digit characters
    String onlyNumbers = input.replaceAll(RegExp(r'\D'), '');
    return onlyNumbers;
  }

  static String MessageFormat(String emirate, Vehicle vehicle, String zoneCode,
      String zoneNumber, String duration) {
    switch (emirate) {
      case 'Abu Dhabi':
        return messageForm(vehicle, zoneCode, zoneNumber, duration);
      case "Dubai":
        return messageForm(vehicle, zoneCode, zoneNumber, duration);
      case "Sharjah":
        return messageFormSharjah(vehicle, zoneCode);
      case "Ajman":
        return messageFormAjman(vehicle);
      case "Umm Al Quwain":
        return messageForm(vehicle, zoneCode, zoneNumber, duration);
      case "Ras Al Khaimah":
        return messageForm(vehicle, zoneCode, zoneNumber, duration);
      case "Fujairah":
        return messageForm(vehicle, zoneCode, zoneNumber, duration);
      default:
        return messageForm(vehicle, zoneCode, zoneNumber, duration);
    }
  }

  // static  Map<String,String> MessageFormat = {
  //   'Abu Dhabi':'',
  //   'Dubai':messageForm(vehicle, zoneCode, zoneNumber, duration),
  //   'Sharjah': '',
  //   'Ajman': ['Private', 'Commercial', 'Taxi', 'Government', 'Export'],
  //   'Umm Al Quwain': ['Private', 'Commercial', 'Taxi', 'Government', 'Export'],
  //   'Ras Al Khaimah': ['Private', 'Commercial', 'Taxi', 'Government', 'Export'],
  //   'Fujairah': ['Private', 'Commercial', 'Taxi', 'Government', 'Export']
  // };

  static String messageForm(
      Vehicle vehicle, String zoneCode, String zoneNumber, String duration) {
    return "${vehicle.plateType} ${vehicle.plateCode} ${vehicle.plateNumber} $zoneNumber$zoneCode ${extractNumbers(duration)}";
  }

  static String messageFormSharjah(Vehicle vehicle, String duration) {
    return "${vehicle.plateType} ${vehicle.plateCode} ${vehicle.plateNumber} ${extractNumbers(duration)}";
  }

  static String messageFormAjman(
    Vehicle vehicle,
  ) {
    return "${vehicle.plateType} ${vehicle.plateCode} ${vehicle.plateNumber}";
  }

  static String removeAssetsPrefix(String path) {
    const prefix = 'sounds/';
    if (path.startsWith(prefix)) {
      return path.substring(prefix.length);
    }
    return path;
  }
}
