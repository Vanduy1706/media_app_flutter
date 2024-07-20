class RegisterModel {
  String? userName;
  String? accountName;
  String? accountPassword;
  String? confirmPassword;

  RegisterModel({
    required this.userName,
    required this.accountName,
    required this.accountPassword,
    required this.confirmPassword
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    userName: json["userName"],
    accountName: json["accountName"],
    accountPassword: json["accountPassword"],
    confirmPassword: json["confirmPassword"]
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["userName"] = userName;
    data["accountName"] = accountName;
    data["accountPassword"] = accountPassword;
    data["confirmPassword"] = confirmPassword;

    return data;
  }
}