class IslemSonucDto {
  late bool basariDurumu;

  IslemSonucDto({required this.basariDurumu});

  IslemSonucDto.fromDatabaseJson(Map<String,dynamic>data){
    this.basariDurumu = data['basariDurumu'];
  }

  Map<String,dynamic> toDatabaseJson()=>{
    "basariDurumu":this.basariDurumu,
  };
}