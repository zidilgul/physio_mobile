import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:physio/models/egzersizlerimResultDto.dart';
import 'package:physio/models/hastalarListeResultDto.dart';
import 'package:physio/pages/doktor_main.dart';
import 'package:physio/pages/egzersiz_atama.dart';
import 'package:physio/services/egzersizlerim_service.dart';
import 'package:physio/services/hastalar_liste_service.dart';
import 'package:physio/src/config/app_settings.dart';

import 'login.dart';

class EgzersizGecmisiMain extends StatefulWidget{

  final HastalarListeResultDto? text;


   EgzersizGecmisiMain({required this.text});

   @override
   State<StatefulWidget> createState() {
     return EgzersizGecmisiMainState(this.text);
   }
}

class EgzersizGecmisiMainState extends State{

  final HastalarListeResultDto? text;

  EgzersizGecmisiMainState(this.text);

  List<HastalarListeResultDto> hastalar = [];
  List<EgzersizlerimResultDto> egzersiz = [];

  HastalarListeService? hastalarListeService;

  @override
  void initState(){
    getEgzersizler();
    super.initState();
  }


  getEgzersizler() async{
    EgzersizlerimService egzersizlerimService = EgzersizlerimService();
    await egzersizlerimService.getEgzersizListe(this.text!.id).then((value) {
      setState(() {
        egzersiz = value;
        print(egzersiz);
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
              Container(
                width: MediaQuery.of(context).size.width,
                  child: Text("Hasta Adı Soyadı : " + this.text!.fullName,style: TextStyle(fontSize: 20),)),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: egzersiz.isNotEmpty ? Container(
                  height: MediaQuery.of(context).size.height/1.5,
                  child: ListView.builder(
                    itemCount: egzersiz.length,
                      itemBuilder: (BuildContext , int index){
                      EgzersizlerimResultDto item = egzersiz[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          children: [
                            Container(
                              width:MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black,width: 1.5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(item.move, style: TextStyle(fontSize: MediaQuery.of(context).size.height/45,color: Colors.black,fontWeight: FontWeight.bold),),
                                    Text(item.numberOfSets.toString() + " x " + item.numberOfRepetitons.toString(), style: TextStyle(fontSize: MediaQuery.of(context).size.height/45),),
                                    item.state ? Text("Tamamlandı" , style: TextStyle(fontSize: MediaQuery.of(context).size.height/45,color: Colors.green),):
                                    Text("Tamamlanmadı",style: TextStyle(fontSize: MediaQuery.of(context).size.height/45,color: Colors.red)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                      }),
                ): Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2),
                  child: Container(
                    child: Center(child: Text("Atanmış egzersiz bulunmamaktadır.",style:TextStyle(fontSize: MediaQuery.of(context).size.height/45)),),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(child: InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EgzersizAtamaMain(text: this.text)));
                    },
                    child: Container(child: Text("Egzersiz Atama Sayfasına Dön",style: TextStyle(decoration: TextDecoration.underline,color: Colors.blueAccent,fontSize: MediaQuery.of(context).size.height/50),))),),
              )
            ],
          ),
        ),
      ),
    );
  }


}
