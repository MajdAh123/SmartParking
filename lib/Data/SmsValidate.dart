import 'package:smart_parking/constant/data.dart';

int validateSMS(String city, String message) {
  if (city.toLowerCase() == AppData.Ajman.toLowerCase()) {
    if (message.toLowerCase().contains("Confirmation".toLowerCase())) {
      return 0;
    } else if (message.toLowerCase().contains("free".toLowerCase())) {
      return 1;
    } else if (message.toLowerCase().contains("balance".toLowerCase())) {
      return 2;
    } else {
      return 3;
    }
  } else if (city.toLowerCase() == AppData.Sharjah.toLowerCase()) {
    if (message.toLowerCase().contains("Confirmation".toLowerCase())) {
      return 0;
    } else if (message.toLowerCase().contains("free".toLowerCase())) {
      return 1;
    } else if (message.toLowerCase().contains("balance".toLowerCase())) {
      return 2;
    } else {
      return 3;
    }
  } else if (city.toLowerCase() == AppData.Khor_Fakkan.toLowerCase()) {
    if (message.toLowerCase().contains("Confirmation".toLowerCase())) {
      return 0;
    } else if (message.toLowerCase().contains("free".toLowerCase())) {
      return 1;
    } else if (message.toLowerCase().contains("balance".toLowerCase())) {
      return 2;
    } else {
      return 3;
    }
  } else if (city.toLowerCase() == AppData.Dubai.toLowerCase()) {
    if (message.toLowerCase().contains("valid in".toLowerCase())) {
      return 0;
    } else if (message.toLowerCase().contains("free".toLowerCase())) {
      return 1;
    } else if (message.toLowerCase().contains("balance".toLowerCase())) {
      return 2;
    } else {
      return 3;
    }
  } else if (city.toLowerCase() == AppData.Abu_Dhabi.toLowerCase()) {
    if (message.toLowerCase().contains("Confirmation".toLowerCase())) {
      return 0;
    } else if (message.toLowerCase().contains("free".toLowerCase())) {
      return 1;
    } else if (message.toLowerCase().contains("balance".toLowerCase())) {
      return 2;
    } else {
      return 3;
    }
  }

  return 0;

  // 0 --> success
  // 1 --> free parking
  // 2 --> no balance
  // 3 --> something wrong
}
