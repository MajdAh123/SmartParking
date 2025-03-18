import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking/Models/ParkingZoneandHours.dart';
import 'package:smart_parking/View/Dashboard/Vehicles/Controllers/vehicle_Controller.dart';
import 'package:smart_parking/logale/locale_Cont.dart';

import '../Models/PlateCode.dart';
import '../Models/PlateSource.dart';
import '../View/Dashboard/Vehicles/Models/VehicleModel.dart';

class AppMethods {
  static String monthNumberToText(int monthNumber, int yearNumber) {
    // Ensure monthNumber is within valid range (1-12)
    if (monthNumber < 1 || monthNumber > 12) {
      throw ArgumentError('Invalid month number: $monthNumber');
    }

    // Create a DateTime object with the given month number (and arbitrary day and year)
    DateTime date = DateTime(yearNumber, monthNumber);

    // Get the current language from the MyLocaleController
    String language = Get.find<MyLocaleController>().lan.value;

    // Format the DateTime object to get the month name based on the language
    String date_ = language == "en"
        ? DateFormat('MMMM yyyy').format(date)
        : convertMonthToArabic(monthNumber, yearNumber);

    return date_;
  }

// Helper function to convert month and year to Arabic month names
  static String convertMonthToArabic(int monthNumber, int yearNumber) {
    // Arabic month names
    List<String> arabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];

    // Return the Arabic month name with the year
    return '${arabicMonths[monthNumber - 1]} $yearNumber';
  }

  Future<String> getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('appLanguage') ?? 'en';
  }

  static String extractNumbers(String input) {
    // Use a regular expression to remove all non-digit characters

    String onlyNumbers = input.replaceAll(RegExp(r'\D'), '');
    return onlyNumbers;
  }

  static String MessageFormat(String emirate, Vehicle vehicle, String zoneCode,
      String zoneNumber, String duration) {
    PlateSource plateSource = Get.find<VehicleController>()
        .allPlateSource
        .lastWhere((element) => element.id == vehicle.plateSourceId);
    PlateCode platCode = Get.find<VehicleController>()
        .allPlateCode
        .lastWhere((element) => element.id == vehicle.plateCodeId);
    switch (emirate) {
      case 'Abu Dhabi':
        return messageFormAbuDhabi(
            plateSource, platCode, vehicle, zoneCode, duration);
      case "Dubai":
        return messageFormDubai(
            platCode, vehicle, zoneNumber, zoneCode, duration);
      case "Sharjah":
        return messageFormSharjah(plateSource, vehicle, duration);
      case "Ajman":
        return messageFormAjman(plateSource, platCode, vehicle);
      case "Umm Al Quwain":
        return messageForm(vehicle, zoneCode, zoneNumber, duration);
      case "Ras Al Khaimah":
        return messageForm(vehicle, zoneCode, zoneNumber, duration);
      case "Fujairah":
        return messageForm(vehicle, zoneCode, zoneNumber, duration);
      case "Khor Fakkan":
        return messageFormKhorFakkan(plateSource, vehicle, duration);
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
    return " ${vehicle.plateCodeId} ${vehicle.plateNumber} $zoneNumber$zoneCode ${formatDuration(duration)}";
  }

  static String messageFormDubai(PlateCode plateCode, Vehicle vehicle,
      String zoneNumber, String zoneCode, String duration) {
    return "${plateCode.codeEn}${vehicle.plateNumber} $zoneNumber$zoneCode ${formatDuration(duration)}";
  }

  static String messageFormAbuDhabi(PlateSource plateSource,
      PlateCode plateCode, Vehicle vehicle, String zoneCode, String duration) {
    return "${plateSource.code}${plateCode.codeEn} ${vehicle.plateNumber} ${zoneCode[0]} ${formatDuration(duration)}";
  }

  static String messageFormSharjah(
      PlateSource plateSource, Vehicle vehicle, String duration) {
    return "${plateSource.code} ${vehicle.plateNumber} ${formatDuration(duration)}";
  }

  static String messageFormKhorFakkan(
      PlateSource plateSource, Vehicle vehicle, String duration) {
    return "${plateSource.code} ${vehicle.plateNumber} KH ${formatDuration(duration)}";
  }

  static String messageFormAjman(
      PlateSource plateSource, PlateCode plateCode, Vehicle vehicle) {
    return "${plateSource.code} ${plateCode.codeEn} ${vehicle.plateNumber}";
  }

  static String removeAssetsPrefix(String path) {
    const prefix = 'sounds/';
    if (path.startsWith(prefix)) {
      return path.substring(prefix.length);
    }
    return path;
  }

  static String formatDuration(String duration) {
    if (duration == "05" || duration == "0" || duration == "0.5") {
      return "0.5";
    } else {
      return double.parse(duration).toInt().toString();
    }
  }

  static DateTime? getEndDateForTicket(String message) {
    // Regular expression to capture date-time in formats like "26/10/24 03:23 PM"
    RegExp regExp =
        RegExp(r'(\d{2}[-/]\d{2}[-/]\d{2,4})\s+(\d{2}:\d{2})\s*([APM]{2})');

    // Attempt to find a match
    Match? match = regExp.firstMatch(message);

    if (match != null) {
      // Extract date, time, and period components from the match
      String datePart = match.group(1)!; // e.g., "26/10/24"
      String timePart = match.group(2)!; // e.g., "03:23"
      String period = match.group(3)!; // e.g., "PM"

      print(
          'Extracted Date: $datePart, Time: $timePart, Period: $period'); // Debug output

      // Convert the extracted components to a DateTime object
      return _parseDateTime(datePart, timePart, period);
    } else {
      return null;
    }
  }

// Helper method to convert date-time string to DateTime object
  static DateTime _parseDateTime(
      String datePart, String timePart, String period) {
    // Normalize date separators to '-'
    List<String> dateParts =
        datePart.replaceAll('/', '-').split('-'); // [dd, MM, yy]
    int hour = int.parse(timePart.split(':')[0]);
    int minute = int.parse(timePart.split(':')[1]);

    // Adjust hour based on AM/PM
    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    // Ensure the year is in four-digit format
    String year = _ensureFourDigitYear(dateParts[2]);

    // Create the DateTime object
    return DateTime(
      int.parse(year),
      int.parse(dateParts[1]),
      int.parse(dateParts[0]),
      hour,
      minute,
    );
  }

// Helper method to ensure the year is four digits (e.g., 24 -> 2024)
  static String _ensureFourDigitYear(String year) {
    return year.length == 2 ? '20$year' : year;
  }
}
