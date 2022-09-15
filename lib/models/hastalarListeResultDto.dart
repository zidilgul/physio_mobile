class HastalarListeResultDto{
  late int id;
  late String fullName;

  HastalarListeResultDto({required this.id,required this.fullName});


  HastalarListeResultDto.fromDatabaseJson(Map<String, dynamic> json) :
        id = json['id'],
        fullName = json['fullName'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
  };

}