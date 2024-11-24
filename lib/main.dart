import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_parking/View/Dashboard/Bindings/InitBinding.dart';
import 'package:smart_parking/View/SplashContoller.dart';
import 'package:smart_parking/View/splash_page.dart';
import 'package:smart_parking/constant/appcolors.dart';
import 'package:get/get.dart';

import 'logale/locale_Cont.dart';
import 'logale/logale.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  await Alarm.init();
  Get.put(MyLocaleController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Emirates Smart Parking',
      debugShowCheckedModeBanner: false,
      translations: MyLocale(),
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primeryColor,
        appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primeryColor,
            titleTextStyle: TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.w500)),
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primeryColor),
        useMaterial3: true,
      ),
      initialBinding: InitBinding(),
      home: const SplashPage(),
    );
  }
}
