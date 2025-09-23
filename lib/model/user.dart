class UserModel {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? image;
  final int? age;
  final String? gender;

  UserModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
    this.age,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      image: json['image'],
      age: json['age'],
      gender: json['gender'],
    );
  }
}
