import 'package:flutter_blue/flutter_blue.dart';

class ShipmentFromSender {
  String locStarting;
  String locEnding;
  int driverPhone;
  int recieverPhone;
  String description;
  String driverEmail;
  String recieverName;
  List /* <BluetoothDevice> */ devicesList;
  var currentUsername;

  ShipmentFromSender(
      {this.currentUsername,
      this.locEnding,
      this.locStarting,
      this.description,
      this.devicesList,
      this.driverEmail,
      this.driverPhone,
      this.recieverName,
      this.recieverPhone});

  Map<String, dynamic> toMap() {
    return {
      'SenderUserName': currentUsername,
      'ShipmentPickupLoc': locStarting,
      'ShipmentDropOff': locEnding,
      'Description_Shipment': description,
      'DriverEmail': driverEmail,
      'DriverPhoneNo.': driverPhone,
      'RecieverName': recieverName,
      'RecieverPhoneNO.': recieverPhone,
      'TagsList': devicesList,
    };
  }
}
