class ProfileModel {
  String? userName;
  String? description;
  String? address;
  String? job;
  String? personalImage;
  String? backgroundImage;

  ProfileModel({
    required this.userName,
    required this.description,
    required this.address,
    required this.job,
    required this.personalImage,
    required this.backgroundImage,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    userName: json["userName"].toString(),
    description: json["description"].toString(),
    address: json["address"].toString(),
    job: json["job"].toString(),
    personalImage: json["personalImage"].toString(),
    backgroundImage: json["backgroundImage"].toString(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["userName"] = userName;
    data["description"] = description;
    data["address"] = address;
    data["job"] = job;
    data["personalImage"] = personalImage;
    data["backgroundImage"] = backgroundImage;

    return data;
  }
}