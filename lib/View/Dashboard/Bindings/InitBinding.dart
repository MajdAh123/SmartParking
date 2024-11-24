import 'package:get/get.dart';
import 'package:smart_parking/View/CarFunctions/BookParking/Controllers/book_parking_Controller.dart';
import 'package:smart_parking/View/SplashContoller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
    Get.put(BookParkingController(), permanent: true);
    // TODO: implement dependencies
  }
}
