class AuthModel {
  String? id;
  String? userName;
  String? accountName;
  String? token;

  AuthModel({
    required this.id,
    required this.userName,
    required this.accountName,
    required this.token
  });

  static AuthModel authEmpty() {
    return AuthModel(
      id: '',
      userName: '',
      accountName: '',
      token: '',
    );
  }

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    id: json["id"].toString(),
    userName: json["userName"].toString(),
    accountName: json["accountName"].toString(),
    token: json["token"].toString(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["id"] = id;
    data["userName"] = userName;
    data["accountName"] = accountName;
    data["token"] = token;

    return data;
  }
}