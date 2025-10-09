import 'dart:async';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class InternetConnectivityController extends GetxController {
  var isConnected = true.obs;
  late StreamSubscription<List<ConnectivityResult>> subscription;
  @override
  void onInit() {
    super.onInit();
    checkConnection();
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      checkConnection();
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.vpn) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      isConnected.value = true;
    } else {
      isConnected.value = false;
    }
  }
}
