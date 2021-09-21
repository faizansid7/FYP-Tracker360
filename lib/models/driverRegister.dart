import 'package:tracker360/models/commonRegister.dart';

class DriverRegister {
  CommonRegister common;
  String vehicleMake;
  String model;
  String regNumber;
  String driverId;
  String privilege = "driver";
  double lat, lng;

  DriverRegister(
      {this.common,
      this.model,
      this.regNumber,
      this.vehicleMake,
      this.lat,
      this.lng,
      this.driverId});

  Map<String, dynamic> toMap() {
    return {
      'name': common.fullName,
      'dateOfBirth': common.dob,
      'gender': common.gender,
      'contact.No': common.number,
      'email': common.email,
      'cnic': common.cnic,
      'address': common.address,
      'vehicleMake': vehicleMake,
      'vehicleModel': model,
      'vehicleRegNumber': regNumber,
      "privilege": privilege,
      "driverId": driverId,
    };
  }

  factory DriverRegister.fromJson(Map<String, dynamic> j) => DriverRegister(
      driverId: j["driverId"],
      model: j["vehicleModel"],
      regNumber: j["vehicleRegNumber"],
      vehicleMake: j["vehicleMake"],
      lat: j["lat"] ?? 0.0,
      lng: j["long"] ?? 0.0,
      common: CommonRegister.fromJson(j));
}
