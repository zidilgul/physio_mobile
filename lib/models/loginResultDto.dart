class LoginResultDto{
  late int id;
  late String userName;
  late String fullName;
  late String? password;
  late bool isDoctor;
  late bool? basariDurumu;

  LoginResultDto({required this.id, required this.userName, required this.fullName, this.password, required this.isDoctor,this.basariDurumu });

  LoginResultDto.fromDatabaseJson(Map<String, dynamic> json) :
        id = json['id'],
        userName = json['userName'],
        fullName = json['fullName'],
        password = json['password'],
        isDoctor = json['isDoctor'],
        basariDurumu = json['basariDurumu'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'fullName': fullName,
    'password': password,
    'isDoctor': isDoctor,
    'basariDurumu': basariDurumu,
  };

}