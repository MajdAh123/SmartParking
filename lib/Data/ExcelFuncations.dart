import 'dart:developer';

import 'package:excel/excel.dart';

import 'package:flutter/services.dart' show ByteData, rootBundle;

import '../Models/ParkingCity.dart';
import '../Models/ParkingZoneandHours.dart';
import '../Models/PlateCode.dart';
import '../Models/PlateSource.dart';
import '../Models/PublicHoliday.dart';
import '../Models/RamadanDates.dart';

// Function to read Parking City sheet
Future<List<ParkingCity>> readParkingCityData() async {
  ByteData data = await rootBundle.load('assets/excel/data.xlsx');
  var bytes = data.buffer.asUint8List();
  var excel = Excel.decodeBytes(bytes);

  List<ParkingCity> cities = [];

  var sheet = excel['Parking City '];
  for (var row in sheet.rows.skip(1)) {
    // Skip header
    cities.add(ParkingCity(
      id: int.parse(row[0]!.value.toString()),
      code: row[1]!.value.toString(),
      cityEn: row[2]!.value.toString(),
      cityAr: row[3]!.value.toString(),
      smsNumber: row[4]!.value.toString(),
    ));
  }
  return cities;
}

// Function to read Plate Source sheet
Future<List<PlateSource>> readPlateSourceData() async {
  log("start reading1");

  ByteData data = await rootBundle.load('assets/excel/data.xlsx');
  var bytes = data.buffer.asUint8List();
  log("start reading2");

  var excel = Excel.decodeBytes(bytes);
  log("start reading3");

  List<PlateSource> plateSources = [];
  log("start reading4");
  try {
    var sheet = excel['Plate Source'];
    for (var row in sheet.rows.skip(1)) {
      // log(row[0]!.value.toString());
      // log(row[2]!.value.toString());
      // log(row[3]!.value.toString());
      plateSources.add(PlateSource(
        id: int.parse(row[0]!.value.toString()),
        code: row[1]!.value.toString(),
        cityEn: row[2]!.value.toString(),
        cityAr: row[3]!.value.toString(),
        order: int.parse(row[4]!.value.toString()),
      ));
    }
  } catch (e) {
    log(e.toString());
  }

  return plateSources;
}

// Function to read Plate Code sheet
Future<List<PlateCode>> readPlateCodeData() async {
  ByteData data = await rootBundle.load('assets/excel/data.xlsx');
  var bytes = data.buffer.asUint8List();
  var excel = Excel.decodeBytes(bytes);

  List<PlateCode> plateCodes = [];

  var sheet = excel['Plate Code'];
  for (var row in sheet.rows.skip(1)) {
    plateCodes.add(PlateCode(
      id: int.parse(row[0]!.value.toString()),
      emirateId: int.parse(row[1]!.value.toString()),
      emirate: row[2]!.value.toString(),
      codeEn: row[3]!.value.toString(),
      codeAr: row[4]!.value.toString(),
      order: int.parse(row[5]!.value.toString()),
    ));
  }
  return plateCodes;
}

// Function to read SMS Format sheet
// Future<List<SMSFormat>> readSMSFormatData() async {
//   ByteData data = await rootBundle.load('assets/excel/data.xlsx');
//   var bytes = data.buffer.asUint8List();
//   var excel = Excel.decodeBytes(bytes);

//   List<SMSFormat> smsFormats = [];

//   var sheet = excel['SMS Format'];
//   for (var row in sheet!.rows.skip(1)) {
//     smsFormats.add(SMSFormat(
//       emirate: row[0],
//       format: row.sublist(1).map((e) => e?!.value.toString() ?? '').toList(), // Handle null values and convert to string
//     ));
//   }
//   return smsFormats;
// }

// Function to read Parking Zone and Hours sheet
Future<List<ParkingZone>> readParkingZoneData() async {
  ByteData data = await rootBundle.load('assets/excel/data.xlsx');
  var bytes = data.buffer.asUint8List();
  var excel = Excel.decodeBytes(bytes);

  List<ParkingZone> parkingZones = [];

  var sheet = excel['Parking Zone and hours'];
  try {
    for (var row in sheet.rows.skip(1)) {
      // log(row[5].toString());
      parkingZones.add(ParkingZone(
        city: row[0]!.value.toString(),
        zone: row[1] == null ? "" : row[1]!.value.toString(),
        hours: double.parse(
            row[2]!.value.toString()), // Updated parsing for fractional hours
        parkingPrice: double.parse(row[3]!.value.toString()),
        smsPrice: double.parse(row[4]!.value.toString()),
        totalPrice: double.parse(row[5]!.value.toString()),
        normalTimeFrom: row[6]!.value.toString(),
        normalTimeTo: row[7]!.value.toString(),
        ramadanTimeFrom: row[8]!.value.toString(),
        ramadanTimeTo: row[9]!.value.toString(),
        dayFrom: row[10]!.value.toString(),
        dayTo: row[11]!.value.toString(),
        weekend: row[12] == null ? "" : row[12]!.value.toString(),
        maxHours: row[13]!.value.toString() != "..."
            ? double.parse(row[13]!.value.toString())
            : 10,
      ));
    }
  } catch (e) {
    log(e.toString());
  }
  return parkingZones;
}

// Helper function to parse hours including fractional values (e.g., "1/2")

// Function to read Public Holiday sheet
Future<List<PublicHoliday>> readPublicHolidayData() async {
  ByteData data = await rootBundle.load('assets/excel/data.xlsx');
  var bytes = data.buffer.asUint8List();
  var excel = Excel.decodeBytes(bytes);

  List<PublicHoliday> publicHolidays = [];

  var sheet = excel['Public Holiday'];
  for (var row in sheet.rows.skip(1)) {
    publicHolidays.add(PublicHoliday(
      holidayName: row[0]!.value.toString(),
      date: DateTime.parse(row[1]!.value.toString()),
    ));
  }
  return publicHolidays;
}

// Function to read Ramadan Dates sheet
Future<List<RamadanDates>> readRamadanDatesData() async {
  ByteData data = await rootBundle.load('assets/excel/data.xlsx');
  var bytes = data.buffer.asUint8List();
  var excel = Excel.decodeBytes(bytes);

  List<RamadanDates> ramadanDates = [];

  var sheet = excel['Ramadan Dates'];
  for (var row in sheet.rows.skip(1)) {
    ramadanDates.add(RamadanDates(
      year: int.parse(row[0]!.value.toString()),
      startDate: DateTime.parse(row[1]!.value.toString()),
      endDate: DateTime.parse(row[2]!.value.toString()),
    ));
  }
  return ramadanDates;
}
