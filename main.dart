import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(loading_root_page());
}

class loading_root_page extends StatelessWidget{
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Center(child: Text("Bağlantını Kontrol Et"),);
          }else if(snapshot.hasData){
            return loading_root_pageSt();
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
      debugShowCheckedModeBanner: true,
    );

  }
}

class loading_root_pageSt extends StatefulWidget{
  @override
  _loading_root_pageStState createState() => _loading_root_pageStState();
}

class _loading_root_pageStState extends State<loading_root_pageSt>{

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  Future<void> userRegister() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: t1.text, password: t2.text)
        .then((kullanici) {
      FirebaseFirestore.instance
          .collection("Kullanicilar")
          .doc(t1.text)
          .set({
        "KullaniciEposta": t1.text,
        "KullaniciSifre": t2.text,
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email Adresi",
                ),
                controller: t1,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Şifre",
                ),
                controller: t2,
              ),
              TextButton(
                child: Text("Kayıt Yap"),
                onPressed: (){
                  userRegister();
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}