class BolgeResultDto {
  late int id;
  late String name;
  late List<dynamic>? moves;

  BolgeResultDto({required this.id,required this.name,this.moves});


  BolgeResultDto.fromDatabaseJson(Map<String, dynamic> json) :
        id = json['id'],
        name = json['name'],
        moves = json['moves'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'moves': moves,
  };
}