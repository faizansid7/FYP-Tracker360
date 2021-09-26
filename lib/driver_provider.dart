import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tracker360/Firebase/auth.dart';
import 'package:tracker360/Firebase/database.dart';
import 'package:tracker360/models/driverRegister.dart';
import 'package:tracker360/models/trackerRegister.dart';

class UserProvider extends ChangeNotifier {
  DriverRegister driverRegister;
  TrackerRegister trackerRegister;
  DatabaseService _db = DatabaseService();
  Timer timer;

  setCurrentDriver(DriverRegister currentDriver) async {
    driverRegister = currentDriver;
    print(driverRegister.common.email);
    print("jkakbckaijcioajcoajcopjiohdv iosjo m vkjsdbnion qoias");
    notifyListeners();
  }

  Future setCurrentDriverFromDB() async {
    print("Executingggggg");
    if (driverRegister == null) {
      await AuthService().getUser().then((user) async {
        if (user != null) {
          print("Firebase user : " + user.uid);
          await _db.getDriverByDriverId(user.uid).then((driver) {
            if (driver != null) {
              setCurrentDriver(driver);
              _startTimerForUploadingLocation(user.uid);
            } else
              driverRegister = null;
            notifyListeners();
          });
        }
      });
    }
  }

  _startTimerForUploadingLocation(String uid) async {
    if (driverRegister != null) {
      Timer.periodic(Duration(seconds: 5), (timer) async {
        print("Upload Timer completed");
        await _determinePosition().then((pos) async {
          if (pos != null) {
            await DatabaseService().uploadCurrentLocation(uid,
                lat: pos.latitude, long: pos.longitude);
          }
        });
      });
    } else {
      print("Driver data not available in provider");
    }
  }

  cancelTimer() {
    if (timer != null) timer.cancel();
    notifyListeners();
  }

  resetprovider() {
    driverRegister = null;
    trackerRegister = null;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
