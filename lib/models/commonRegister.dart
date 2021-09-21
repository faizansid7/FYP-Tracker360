class CommonRegister {
  String email;
  String password;
  String fullName;
  String dob;
  String gender;
  int cnic;
  int number;
  String address;

  CommonRegister(
      {this.address,
      this.cnic,
      this.password,
      this.email,
      this.number,
      this.fullName,
      this.dob,
      this.gender});
  factory CommonRegister.fromJson(Map<String, dynamic> j) => CommonRegister(
      email: j["email"],
      password: j["password"],
      address: j["address"],
      cnic: j["cnic"],
      number: j["contact.No"],
      fullName: j["fullname"],
      dob: j["dateOfBirth"],
      gender: j["gender"]);
}
