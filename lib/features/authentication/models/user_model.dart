class UserModel {
  String? userId;
  String? userName;
  String? decription;
  String? dateOfBirth;
  String? phoneNumber;
  String? address;
  String? job;
  String? personalImage;
  String? backgroundImage;
  String? createdAt;

  UserModel({
    required this.userId,
    required this.userName,
    required this.decription,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.address,
    required this.job,
    required this.personalImage,
    required this.backgroundImage,
    required this.createdAt,
  });
  static UserModel userEmpty() {
    return UserModel(
        userId: '',
        userName: '',
        decription: '',
        dateOfBirth: '',
        phoneNumber: '',
        address: '',
        job: '',
        personalImage: '',
        backgroundImage: '',
        createdAt: '');
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["userId"],
        userName: json["userName"],
        decription: json["decription"],
        dateOfBirth: json["dateOfBirth"],
        phoneNumber: json["phoneNumber"] == null || json["phoneNumber"] == ''
            ? ""
            : json['phoneNumber'],
        address: json["address"],
        job: json["job"],
        personalImage: json["personalImage"],
        backgroundImage: json["backgroundImage"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['job'] = job;
    data['decription'] = decription;
    data['job'] = job;
    data['dateOfBirth'] = dateOfBirth;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['personalImage'] = personalImage;
    data['backgroundImage'] = backgroundImage;
    data["createdAt"] = createdAt;

    return data;
  }
}
