import 'package:tracker360/models/commonRegister.dart';

class TrackerRegister {
  CommonRegister common;
  String organization;
  String designation;
  String employeeId;
  String privilege = "tracker";

  TrackerRegister(
      this.common, this.designation, this.employeeId, this.organization);

  Map<String, dynamic> toMap() {
    return {
      'name': common.fullName,
      'dateOfBirth': common.dob,
      'gender': common.gender,
      'contact.No': common.number,
      'email': common.email,
      'cnic': common.cnic,
      'address': common.address,
      'organization': organization,
      'designation': designation,
      'employeeId': employeeId,
      'privilege': privilege
    };
  }
}
