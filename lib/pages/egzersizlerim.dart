import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:physio/helpers/storage_helper.dart';
import 'package:physio/models/egzersizlerimResultDto.dart';
import 'package:physio/models/loginResultDto.dart';
import 'package:physio/models/newClickDto.dart';
import 'package:physio/services/click_post_service.dart';
import 'package:physio/services/egzersizlerim_service.dart';
import 'package:physio/src/config/app_settings.dart';

import 'cameraScreen.dart';
import 'login.dart';

class EgzersizMain extends StatefulWidget{

  @override
  EgzersizMainState createState()=>EgzersizMainState();
}

class EgzersizMainState extends State<EgzersizMain>{

  late LoginResultDto Info;
  late bool gelenBasariDurumu;
  List<EgzersizlerimResultDto> egzersiz = [];

  @override
  void initState(){
    // getUserInfo();
    getEgzersizler();
    super.initState();
  }

  void getUserInfo() async{
    UserSecureStorage.getUser().then((value) {
      setState(() {
        value = Info;
      });
    });

  }

  getEgzersizler() async{
    EgzersizlerimService egzersizlerimService = EgzersizlerimService();
    await egzersizlerimService.getEgzersizListe(PhysioAppSettings.user!.id).then((value) {
      setState(() {
        egzersiz = value;
        print(egzersiz);
      });
    });
  }

  postEgzersiz(int id)async{
    ClickPostService clickPostService = ClickPostService();
    NewClickDto newClickDto= NewClickDto(patientsMoveId: id);
    await clickPostService.postClick(newClickDto).then((value) {
      setState(() {
        value.basariDurumu = gelenBasariDurumu;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(PhysioAppSettings.user!.fullName),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("EGZERSİZLERİM",style: TextStyle(fontSize: MediaQuery.of(context).size.height/35,fontWeight: FontWeight.w500),)
                  ],
                ),
              ),
              Flexible(
                child: egzersiz.isNotEmpty ? Container(
                  child: ListView.builder(
                      itemCount:egzersiz.length ,
                      itemBuilder: (BuildContext , int index){
                        EgzersizlerimResultDto item = egzersiz[index];
                        return GestureDetector(
                          onTap: (){
                            item.state ? showDialog(
                                context: context,
                                builder: (context){
                                  return Dialog(
                                    child: Container(
                                        height: MediaQuery.of(context).size.height/6,
                                        width: MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Center(child: Text("Bu egzersizi tamamladınız.",style: TextStyle(fontSize: MediaQuery.of(context).size.height/40))),
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
                                }) : _showDialog(item.id, item.moveId) ;

                          },
                          child: Padding(
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
                          ),
                        );
                      }),
                )
                    : Container(
                  child: Center(
                  child: Text("Atanmış egzersiz bulunmamaktadır.",style: TextStyle(fontSize: MediaQuery.of(context).size.height/45),),),),
              )
            ],
          ),
        ),
      ),
    );
  }


  _showDialog(int id, int moveId){
    showDialog(
        context: context,
        builder: (BuildContext context){
      return AlertDialog(
        title: Text("Nasıl Yapılır?"),
        content : moveId == 1 ? Image.asset("assets/img/dirsek_eks_fleks.jpeg",scale: MediaQuery.of(context).size.height/250,) :
        moveId == 2 ? Image.asset("assets/img/ayak_bilek.jpeg",scale: MediaQuery.of(context).size.height/250,) :
        moveId == 3 ? Image.asset("assets/img/omuz.jpeg",scale: MediaQuery.of(context).size.height/250,) :
        moveId == 4 ? Image.asset("assets/img/bel.jpeg",scale: MediaQuery.of(context).size.height/250,) :
        moveId == 5 ? Image.asset("assets/img/squat.jpeg",scale: MediaQuery.of(context).size.height/250,) : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GestureDetector(
              onTap: (){
                postEgzersiz(id);
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => QrCodeScanner()));
              },
              child: Center(
                  child: Container(
                height: MediaQuery.of(context).size.height/27,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.black,width: 1.5)
                ),
                child: Center(child: Text("Başla",style: TextStyle(fontWeight: FontWeight.w400,fontSize: MediaQuery.of(context).size.height/35),)),)),
            ),
          )
        ],
      );
    }
    );


  }

}
