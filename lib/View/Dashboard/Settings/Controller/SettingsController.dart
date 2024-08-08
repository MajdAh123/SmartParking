import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:smart_parking/constant/keys.dart';

class SettingsController extends GetxController {
  var alertOnTicketEnd = true.obs;
  var alertBeforeTicketEnd = true.obs;
  var alertMinutes = 5.obs;
  // var alertTone = 'DEFAULT'.obs;

  var vibrateWithAlert = true.obs;
  var appLanguage = 'en'.obs;
  var alertName = "".obs;
  var alertPath = "".obs;
  // Indicate if application has permission to the library.
  RxBool isloading = true.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();
  RxBool isPlayingAudio = false.obs;
  @override
  void onInit() {
    super.onInit();
    // getSongs();
    // Check and request for permission.

    loadSettings();
  }

  getSongs() async {
    isloading = true.obs;

    isloading = false.obs;
  }

  Future<void> playAudio() async {
    isPlayingAudio.value = true;
    await _audioPlayer.play(AssetSource(alertPath.value));
    _audioPlayer.onPlayerComplete.listen((event) {
      isPlayingAudio.value = false;
      // print("object");
    });

    // if (alertName.value == "DEFAULT") {
    //   // _audioPlayer.setSourceAsset(AppsKeys.defualtSound);
    //   // setAudioSource(AudioSource.uri(Uri.parse('asset:/your_file.mp3')),
    //   // initialPosition: Duration.zero, preload: true);
    //   await _audioPlayer.play(AssetSource(AppsKeys.defualtSound));
    // } else {
    //   await _audioPlayer.play(DeviceFileSource(alertPath.value));
    // }
  }

  Future<void> puseAudio() async {
    isPlayingAudio.value = false;
    await _audioPlayer.pause();
  }

  // Future<void> pickAudioFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.audio,
  //     // allowedExtensions: [
  //     //   'mp3',
  //     //   'wav',
  //     //   'm4a',
  //     //   'aac'
  //     // ], // Specify allowed audio formats
  //   );

  //   if (result != null) {
  //     PlatformFile file = result.files.first;
  //     print('Picked file: ${file.name}');
  //     alertName.value = file.name;
  //     alertPath.value = file.path!;
  //     // You can now use the file.path to access the file
  //   } else {
  //     // User canceled the picker
  //     print('No file selected');
  //   }
  // }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      PermissionStatus status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  void loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    alertOnTicketEnd.value = prefs.getBool('alertOnTicketEnd') ?? true;
    alertBeforeTicketEnd.value = prefs.getBool('alertBeforeTicketEnd') ?? true;
    alertMinutes.value = prefs.getInt('alertMinutes') ?? 5;
    alertPath.value = prefs.getString('alertTone') ?? AppsKeys.defualtSound;
    alertName.value = prefs.getString('alertName') ?? "DEFAULT";
    vibrateWithAlert.value = prefs.getBool('vibrateWithAlert') ?? true;
    appLanguage.value = prefs.getString('appLanguage') ?? 'en';
  }

  void saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alertOnTicketEnd', alertOnTicketEnd.value);
    await prefs.setBool('alertBeforeTicketEnd', alertBeforeTicketEnd.value);
    await prefs.setInt('alertMinutes', alertMinutes.value);
    await prefs.setString('alertTone', alertPath.value);
    await prefs.setString('alertName', alertName.value);
    await prefs.setBool('vibrateWithAlert', vibrateWithAlert.value);
    await prefs.setString('appLanguage', appLanguage.value);
  }
}
