import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:physio/models/bolgeComboResultDto.dart';
import 'package:physio/models/hareketlerComboResultDto.dart';
import 'package:physio/models/hastalarListeResultDto.dart';
import 'package:physio/models/islemSonucDto.dart';
import 'package:physio/models/patientsMoveResultDto.dart';
import 'package:physio/services/bolge_combo_service.dart';
import 'package:physio/services/egzersiz_post_service.dart';
import 'package:physio/services/hareket_combo_service.dart';
import 'package:physio/src/config/app_settings.dart';
import '../models/setDto.dart';
import '../models/tekrarDto.dart';
import 'cameraScreen.dart';
import 'doktor_main.dart';
import 'egzersiz_gecmisi.dart';
import 'login.dart';

class EgzersizAtamaMain extends StatefulWidget{

  final HastalarListeResultDto? text;

  EgzersizAtamaMain({this.text});

  @override
  State<StatefulWidget> createState() {
    return EgzersizAtamaMainState(this.text);
  }
}

class EgzersizAtamaMainState extends State{

  final HastalarListeResultDto? text;

  EgzersizAtamaMainState(this.text);

  late List<BolgeResultDto> bolgeler = [];
  int? _bolge;
  int? _hareket;
  int? _set;
  int? _repeat;

  late List<HareketlerResultDto> hareketler = [];

  late BolgeComboService bolgeComboService;
  late HareketlerimListeService hareketlerimListeService;

  late PatientMovePostService patientMovePostService;

  List<SetDto> setSayisi = [SetDto(id: 1, name: "1"),SetDto(id: 2, name: "2"),SetDto(id: 3, name: "3")];
  List<TekrarDto> tekrarSayisi = [TekrarDto(id: 8, name: "8"),TekrarDto(id: 12, name: "12"),TekrarDto(id: 15, name: "15")];

  @override
  void initState(){
    patientMovePostService = PatientMovePostService();
    bolgeComboService = BolgeComboService();
    hareketlerimListeService = HareketlerimListeService();
    getBolgeComboDoldur();
    super.initState();
  }

  getBolgeComboDoldur()async{
    await bolgeComboService.getBolgeler().then((value) {
      setState(() {
       bolgeler = value;
       print(bolgeler);
      });
    });
  }


  hareketGetir(bodyPartId) async{
    await hareketlerimListeService.getHareketler(_bolge).then((value) {
      setState(() {
        hareketler = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DoktorMain()));
            },
            child: Text("Dr. " + PhysioAppSettings.user!.fullName)),
      ),
      endDrawer: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width/2,
        color: Colors.deepPurpleAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Container(
                  height: MediaQuery.of(context).size.height/17,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(4)
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Container(
                        child: Text("Çıkış Yap",
                          style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.height/45),),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height/35,
            left: MediaQuery.of(context).size.width/30,
            right: MediaQuery.of(context).size.width/30,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text("Hasta Adı Soyadı : " + this.text!.fullName ,style: TextStyle(fontSize: 20),)),
              ),
              Container(
                width: MediaQuery.of(context).size.width/1.1,
                height: MediaQuery.of(context).size.height/15,
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration.collapsed(hintText: ""),
                      value: _bolge,
                      isDense: true,
                      hint: Text("Bölge Seç"),
                      items: bolgeler.map((BolgeResultDto item) {
                        return DropdownMenuItem<int>(
                          value: item.id,
                            child: Text(item.name));
                      }).toList(),
                      onChanged: (secilenBolge){
                        setState(()  {
                          _bolge = secilenBolge as int?;
                          hareketGetir(_bolge);
                          _hareket = null;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  width: MediaQuery.of(context).size.width/1.1,
                  height: MediaQuery.of(context).size.height/17,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration.collapsed(hintText: ""),
                        value: _hareket,
                        isDense: true,
                        hint: Text("Hareket Seç"),
                        items: hareketler.map((HareketlerResultDto item) {
                          return DropdownMenuItem<int>(
                              value: item.id,
                              child: Text(item.name));
                        }).toList(),
                        onChanged: (secilenHareket){
                          setState(()  {
                            _hareket = secilenHareket as int?;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40,left: 7),
                    child: Container(
                      width: MediaQuery.of(context).size.width/2.5,
                      height: MediaQuery.of(context).size.height/17,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: DropdownButtonFormField(
                            decoration: InputDecoration.collapsed(hintText: ""),
                            value: _set,
                            isDense: true,
                            hint: Text("Set Sayısı",style: TextStyle(fontSize: MediaQuery.of(context).size.height/50),),
                            items: setSayisi.map((SetDto item) {
                              return DropdownMenuItem<int>(
                                  value: item.id,
                                  child: Text(item.name));
                            }).toList(),
                            onChanged: (secilenBolge){
                              setState(()  {
                                _set = secilenBolge as int?;
                                hareketGetir(_set);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40,right: 7),
                    child: Container(
                      width: MediaQuery.of(context).size.width/2.5,
                      height: MediaQuery.of(context).size.height/17,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: DropdownButtonFormField(
                            decoration: InputDecoration.collapsed(hintText: ""),
                            value: _repeat,
                            isDense: true,
                            hint: Text("Tekrar Sayısı",style: TextStyle(fontSize: MediaQuery.of(context).size.height/50)),
                            items: tekrarSayisi.map((TekrarDto item) {
                              return DropdownMenuItem<int>(
                                  value: item.id,
                                  child: Text(item.name));
                            }).toList(),
                            onChanged: (secilenBolge){
                              setState(()  {
                                _repeat = secilenBolge as int?;
                                hareketGetir(_repeat);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: GestureDetector(
                  onTap: (){
                    if(_set == null || _repeat == null || _hareket== null || _bolge == null ){
                      showDialog(context: context, builder: (BuildContext){
                        return Dialog(
                          child: Container(
                              height: MediaQuery.of(context).size.height/6,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(child: Text("Lütfen gerekli alanları doldurunuz.",style: TextStyle(fontSize: MediaQuery.of(context).size.height/40))),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.deepPurpleAccent
                                          ),
                                          height: MediaQuery.of(context).size.height/27,
                                          width: MediaQuery.of(context).size.width/2,
                                          child: Center(child: Text("Tamam",style: TextStyle(fontSize: MediaQuery.of(context).size.height/40, color: Colors.white))),
                                        ),
                                      ),),
                                  )
                                ],
                              )),
                        );
                      });
                    }
                    else {
                      final PatientsMoveResultDto moves = PatientsMoveResultDto(
                        numberOfSets: _set!,
                        numberOfRepetitons: _repeat!,
                        moveId: _hareket!,
                        patientId: this.text!.id,
                      );
                      Future<IslemSonucDto> sonuc = patientMovePostService
                          .postHareketlerim(moves);
                      sonuc.then((value) async {
                        if (value.basariDurumu == true) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height / 6,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Center(child: Text(
                                              "Kayıt işlemi başarılı",
                                              style: TextStyle(
                                                  fontSize: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height / 40))),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: GestureDetector(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (
                                                              BuildContext context) =>
                                                              DoktorMain()));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                      color: Colors
                                                          .deepPurpleAccent
                                                  ),
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height / 27,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 2,
                                                  child: Center(child: Text(
                                                      "Tamam", style: TextStyle(
                                                      fontSize: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .height / 40,
                                                      color: Colors.white))),
                                                ),
                                              ),
                                            ),
                                          )

                                        ],
                                      )),
                                );
                              });
                        }
                      }
                      );
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height/21,
                    width: MediaQuery.of(context).size.width/1.1,
                    child: Center(child: Text("Hareketi Ata",style: TextStyle(fontSize: MediaQuery.of(context).size.height/50))),
                    decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EgzersizGecmisiMain(text: this.text)));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height/21,
                    width: MediaQuery.of(context).size.width/1.1,
                    child: Center(child: Text("Geçmiş Egzersizleri Gör",style: TextStyle(decoration: TextDecoration.underline,color: Colors.blueAccent,fontSize: MediaQuery.of(context).size.height/50),)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}
