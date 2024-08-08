class AppData {
  static const Map<String, String> parkingPhoneNumber = {
    'Abu Dhabi': '5566',
    'Dubai': '5566',
    'Sharjah': '5566',
    'Ajman': '5155',
    'Umm Al Quwain': '5566',
    'Ras Al Khaimah': '5566',
    'Fujairah': '5566'
  };

  // "5155";
  static const String SMS_DELIVERED = "SMS delivered";
  static const String Abu_Dhabi = "Abu Dhabi";
  static const String Dubai = "Dubai";
  static const String Sharjah = "Sharjah";
  static const String Ajman = "Ajman";
  static const String Umm_Al_Quwain = "Umm Al Quwain";
  static const String Ras_Al_Khaimah = "Ras Al Khaimah";
  static const String Fujairah = "Fujairah";

  static const List<String> emirates = [
    'Abu Dhabi',
    'Dubai',
    'Sharjah',
    'Ajman',
    'Umm Al Quwain',
    'Ras Al Khaimah',
    'Fujairah'
  ];

  static const Map<String, List<String>> plateTypesInEmirates = {
    'Abu Dhabi': [
      'Private',
      'Commercial',
      'Taxi',
      'Government',
      'Export',
      'Military'
    ],
    'Dubai': [
      'Private',
      'Commercial',
      'Taxi',
      'Government',
      'Export',
      'Special',
      'Expo 2020'
    ],
    'Sharjah': ['Private', 'Commercial', 'Taxi', 'Government', 'Export'],
    'Ajman': ['Private', 'Commercial', 'Taxi', 'Government', 'Export'],
    'Umm Al Quwain': ['Private', 'Commercial', 'Taxi', 'Government', 'Export'],
    'Ras Al Khaimah': ['Private', 'Commercial', 'Taxi', 'Government', 'Export'],
    'Fujairah': ['Private', 'Commercial', 'Taxi', 'Government', 'Export']
  };
  static const Map<String, List<String>> emiratePlateCodes = {
    'Dubai': [
      'White',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
      'AA',
      'CR'
    ],
    'Abu Dhabi': [
      'Red',
      'Green',
      'Blue',
      'Gray',
      'AD1',
      'AD2',
      'AD3',
      'AD4',
      'AD5',
      'AD6',
      'AD7',
      'AD8',
      'AD9',
      'AD10',
      'AD11',
      'AD12',
      'AD13',
      'AD14',
      'AD15',
      'AD16',
      'AD17',
      'AD18',
      'AD19',
      'AD20',
      'AD50'
    ],
    'Sharjah': ['White', 'Orange', 'Brown', 'SHJ 1', 'SHJ 2', 'SHJ 3', 'SHJ 4'],
    'Ajman': ['White', 'Orange', 'A', 'B', 'C', 'D', 'E', 'F', 'H', 'K'],
    'Umm Al Quwain': [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'White'
    ],
    'Ras Al Khaimah': [
      'White',
      'Qala',
      'A',
      'B',
      'C',
      'D',
      'F',
      'I',
      'K',
      'M',
      'N',
      'S',
      'V',
      'X',
      'Y',
      'Z',
      'Classic'
    ],
    'Fujairah': [
      'White',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    ]
  };
  static const Map<String, String> emirateTranslations = {
    'dubai': 'دبي',
    'abu dhabi': 'أبو ظبي',
    'sharjah': 'الشارقة',
    'ajman': 'عجمان',
    'umm al quwain': 'أم القيوين',
    'ras al khaimah': 'رأس الخيمة',
    'fujairah': 'الفجيرة',
  };
  static String translateToArabic(String emirateName) {
    final translatedName = emirateTranslations[emirateName.toLowerCase()];
    return translatedName ?? 'Translation not found';
  }

  static const Map<String, List<String>> emirateParkingZones = {
    'Dubai': ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'], // Actual zones for Dubai
    'Abu Dhabi': ['S', 'P'], // Standard and Premium parking zones
    'Sharjah': ['P', 'R'], // Paid and Residential parking

    // Placeholder values for other emirates
    'Ajman': ['P1', 'P2', 'R1'], // Placeholder zones for Ajman
    'Umm Al Quwain': ['P1', 'R1'], // Placeholder zones for Umm Al Quwain
    'Ras Al Khaimah': [
      'P1',
      'P2',
      'R1'
    ], // Placeholder zones for Ras Al Khaimah
    'Fujairah': ['P1', 'R1'] // Placeholder zones for Fujairah
  };
  static const List<String> durationsParking = [
    "1 Hr",
    "2 Hr",
    "3 Hr",
    "4 Hr",
    "5 Hr",
    "6 Hr",
    "7 Hr",
    "8 Hr",
    "9 Hr",
    "10 Hr",
  ];
  static const List<String> remaindMeBeforOption = [
    "1 Min",
    "2 Min",
    "3 Min",
    "4 Min",
    "5 Min",
    "6 Min",
    "7 Min",
    "8 Min",
    "9 Min",
    "10 Min",
  ];
}
