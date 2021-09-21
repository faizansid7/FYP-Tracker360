import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker360/models/driverRegister.dart';
import 'package:tracker360/models/trackerRegister.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection refrence
  final CollectionReference driverCollection =
      Firestore.instance.collection('driverData');
  final CollectionReference tracker =
      Firestore.instance.collection('trackerData');

  Future<void> addDriver(DriverRegister driverData) async {
    await driverCollection.document(uid).setData(driverData.toMap());
    return;
  }

  Future<void> addTracker(TrackerRegister trackerData) async {
    await tracker.document(uid).setData(trackerData.toMap());
    return;
  }

  //gets data of loggedin user
  Future<Map<String, dynamic>> userData() async {
    var dresult = await driverCollection.document(uid).get();
    var tresult = await tracker.document(uid).get();
    if (dresult.data != null) {
      return dresult.data;
    } else if (tresult.data != null) {
      return tresult.data;
    }
  }

  Future<dynamic> userDataByProperty(String property) async {
    var data = await this.userData();
    return data[property];
  }

  Future<DriverRegister> getDriverByDriverId(String driverId) async {
    //driverCollection.document("xxx").get();
    try {
      return await driverCollection.document(driverId).get().then((doc) {
        if (doc.data != null) {
          print(doc.data);

          return DriverRegister.fromJson(doc.data);
        } else
          return null;
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> uploadCurrentLocation(String driverId,
      {double lat, double long}) async {
    //driverCollection.document("xxx").get();
    try {
      return await driverCollection.document(driverId).updateData({
        "lat": lat,
        "long": long,
      }).then((_) {
        print("Location uploaded ");
        print({
          "lat": lat,
          "long": long,
        });
        return true;
      });
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
Stream<QuerySnapshot> getDriverLocation(String email) {
    try {
      Stream<QuerySnapshot> querySnapshots =
          driverCollection.where("email",isEqualTo:email ).snapshots();

      return querySnapshots;
    } catch (e) {
      print("Error agaya ha getdriver location me: " + e.toString());
      return null;
    }
  }
}
