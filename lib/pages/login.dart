import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:physio/models/loginDto.dart';
import 'package:physio/models/loginResultDto.dart';
import 'package:physio/services/login_services.dart';

import 'doktor_main.dart';
import 'egzersizlerim.dart';

TextEditingController kullaniciSifreController = TextEditingController();
TextEditingController kullaniciAdiController = TextEditingController();

class Login extends StatefulWidget{

  @override
  LoginState createState()=>LoginState();
}

class LoginState extends State<Login>{

  bool _loading = false;
  bool _isObscure = true;
  late LoginService _loginService;

  @override
  void initState(){
    _loginService = LoginService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.deepPurpleAccent, Colors.white]),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/15),
                      child: Container(

                        child: Image.asset("assets/img/logo.png",scale: MediaQuery.of(context).size.height/250,),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/50),
                      child: Container(
                        height: MediaQuery.of(context).size.height/15,
                        width: MediaQuery.of(context).size.width/1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/30),
                          child: Center(
                            child: TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11),
                              ],
                              controller: kullaniciAdiController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "TC Kimlik Numaranız",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/50),
                      child: Container(
                        height: MediaQuery.of(context).size.height/15,
                        width: MediaQuery.of(context).size.width/1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/30),
                          child: Center(
                            child: TextFormField(
                              controller: kullaniciSifreController,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure ? Icons.visibility : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                                hintText: "Şifre",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/30),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            _loading = true;
                          });
                          if(kullaniciAdiController.text.isNotEmpty && kullaniciSifreController.text.isNotEmpty){
                            final LoginDto login = LoginDto(
                                UserName: kullaniciAdiController.text,
                                Password: kullaniciSifreController.text
                            );
                            Future<LoginResultDto> user = _loginService.Login(login);
                            print(user);
                            String gelen;
                            user.then((value) async {
                              setState(() {
                                _loading = false;
                              });
                              if(value.basariDurumu == false){
                                showDialog(context: context, builder: (BuildContext){
                                  return Dialog(
                                    child: Container(
                                        height: MediaQuery.of(context).size.height/6,
                                        width: MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Center(child: Text("Kullanıcı adı veya şifre hatalı!",style: TextStyle(fontSize: MediaQuery.of(context).size.height/40))),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 15.0),
                                              child: Center(
                                                child: GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      _loading =false;
                                                    });
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
                                if(value.isDoctor == true){
                                  gelen = value.id.toString();
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DoktorMain()),
                                          (Route<dynamic> route) => false);
                                }else{
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => EgzersizMain()),
                                          (Route<dynamic> route) => false);
                                }
                              }
                            });
                          }else{
                            showDialog(context: context, builder: (BuildContext){
                              return Dialog(
                                child: Container(
                                    height: MediaQuery.of(context).size.height/6,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(child: Text("Lütfen kullanıcı adı ve şifre giriniz",style: TextStyle(fontSize: MediaQuery.of(context).size.height/40))),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 15.0),
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  _loading =false;
                                                });
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
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height/15,
                          width: MediaQuery.of(context).size.width/1.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.deepPurpleAccent
                          ),
                          child: Center(child: Text("Giriş Yap",style: TextStyle(fontSize: MediaQuery.of(context).size.height/40, color: Colors.white)),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if(_loading) ...[
              Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Colors.black38),
                  child: Stack(children :[
                    Center(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height/4,
                          width: MediaQuery.of(context).size.width/2,
                          child: Lottie.asset('assets/loading.json')),
                    )
                  ],
                  )
              ),
            ],
          ],
        ),
      ),
    );
  }

}

