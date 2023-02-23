class AppUser {
  late String uid;
  late String firstName;
  late String lastName;
  late String email;
  late DateTime createdOn;

  AppUser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    firstName = json['firstName'] ?? '';
    lastName = json['lastName'] ?? '';
    email = json['email'];
    createdOn = DateTime.parse(json['createdOn']);
  }
}
