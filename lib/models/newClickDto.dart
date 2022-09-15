class NewClickDto{
  late int patientsMoveId;

  NewClickDto({required this.patientsMoveId});

  factory NewClickDto.fromDatabaseJson(Map<String,dynamic>data)=>NewClickDto(
    patientsMoveId: data['patientsMoveId']
  );

  Map<String,dynamic>toDatabaseJson()=>{
    "patientsMoveId": this.patientsMoveId
  };
}