import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:physio/helpers/storage_helper.dart';
import 'package:physio/models/hastalarListeResultDto.dart';
import 'package:physio/models/loginResultDto.dart';
import 'package:physio/services/hastalar_liste_service.dart';
import 'package:physio/src/config/app_settings.dart';
import 'egzersiz_atama.dart';
import 'login.dart';

class DoktorMain extends StatefulWidget{

  @override
  DoktorMainState createState()=>DoktorMainState();
}

class DoktorMainState extends State<DoktorMain>{

  List<HastalarListeResultDto> hastalar = [];

  HastalarListeService? hastalarListeService;
  late LoginResultDto Info;
  @override
  void initState() {
     getUserInfo();
    hastalarListeService = HastalarListeService();
    getHastalar();
    super.initState();
  }

  void getUserInfo() async{
    UserSecureStorage.getUser().then((value) {
      setState(() {
        print(value);
        value = Info;
      });
    });

  }


  getHastalar() async{
     await hastalarListeService?.getHastaListe(2).then((value){
      setState(() {
        hastalar = value;
      });
      print(hastalar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Dr. " + PhysioAppSettings.user!.fullName),
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
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("HASTALARIM",style: TextStyle(fontSize: MediaQuery.of(context).size.height/35,fontWeight: FontWeight.w500),)
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                      itemCount: hastalar.length,
                    itemBuilder: (BuildContext context, int index) {
                      HastalarListeResultDto item = hastalar[index];
                      return  Padding(
                        padding: const EdgeInsets.only(bottom: 11.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                          ),
                          height: MediaQuery.of(context).size.height/11,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EgzersizAtamaMain(text: item)));
                            },
                            child: Padding(
                              padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/35,left: MediaQuery.of(context).size.width/21),
                              child: Text(item.fullName,style: TextStyle(fontSize: MediaQuery.of(context).size.height/40,fontWeight: FontWeight.w400),),
                            ),
                          ),
                          ),
                      );
                    },
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