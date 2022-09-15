class EgzersizlerimResultDto {
  late int id;
  late int moveId;
  late String move;
  late bool state;
  late int numberOfRepetitons;
  late int numberOfSets;
  late String bodyPart;

  EgzersizlerimResultDto({required this.id, required this.bodyPart,required this.move,required this.numberOfRepetitons,required this.numberOfSets,required this.state});


  EgzersizlerimResultDto.fromDatabaseJson(Map<String, dynamic> json) :
        id = json['id'],
        moveId = json['moveId'],
        move = json['move'],
        state = json['state'],
        numberOfRepetitons = json['numberOfRepetitons'],
        numberOfSets = json['numberOfSets'],
        bodyPart = json['bodyPart'];

  // Map<String,dynamic>toDatabaseJson()=>{
  //   "id":this.id,
  //   "move":this.move,
  //   "state":this.state,
  //   "numberOfRepetitons":this.numberOfRepetitons,
  //   "numberOfSets":this.numberOfSets,
  //   "bodyPart":this.bodyPart,
  // };

  Map<String, dynamic> toJson() => {
    'Id': id,
    'MoveId': moveId,
    'Move': move,
    'State': state,
    'NumberOfRepetitions': numberOfRepetitons,
    'NumberOfSets': numberOfSets,
    'BodyPart': bodyPart,
  };
}