class PatientsMoveResultDto{
  late int patientId;
  late int moveId;
  late int numberOfRepetitons;
  late int numberOfSets;


  PatientsMoveResultDto({required this.numberOfSets,required this.moveId,required this.numberOfRepetitons,required this.patientId});

  factory PatientsMoveResultDto.fromDatabaseJson(Map<String,dynamic>data)=>PatientsMoveResultDto(
      patientId: data['patientId'],
      moveId: data['moveId'],
      numberOfRepetitons: data['numberOfRepetitons'],
      numberOfSets: data['numberOfSets'],
  );

  Map<String,dynamic>toDatabaseJson()=>{
    "patientId":this.patientId,
    "moveId":this.moveId,
    "numberOfRepetitons":this.numberOfRepetitons,
    "numberOfSets":this.numberOfSets,
  };
}