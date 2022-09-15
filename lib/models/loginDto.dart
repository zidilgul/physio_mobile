class LoginDto{

  late String UserName;
  late String Password;

  LoginDto({required this.UserName, required this.Password});

  LoginDto.fromJson(Map<String, dynamic> json) :
  UserName = json['UserName'],
  Password = json['Password'];

  Map<String, dynamic> toDatabaseJson() => {
    'UserName': UserName,
    'Password': Password,
  };

}