class HareketlerResultDto {
  late int id;
  late String name;
  late int bodyPartId;

  HareketlerResultDto({required this.id,required this.name,required this.bodyPartId});


  HareketlerResultDto.fromDatabaseJson(Map<String, dynamic> json) :
        id = json['id'],
        name = json['name'],
        bodyPartId = json['bodyPartId'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'moves': bodyPartId,
  };
}