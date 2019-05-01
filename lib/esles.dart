import 'dart:async';

import 'package:flutter/material.dart';
import 'ApiDatabase.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'mesajlasma.dart';
import 'KULDATA.dart';

class Esles extends StatefulWidget {
  @override
  EslesmeEkrani createState() => EslesmeEkrani();
}

class EslesmeEkrani extends State<Esles> {
  ApiDatabase _uzakDatabase = ApiDatabase();
  bool vil = false;

  @override
  void initState() {
    super.initState();
    ilkGiris();
  }

  void ilkGiris() async {
    String sonuc = await _uzakDatabase.eslesmeControl();
    if (sonuc != "1" && sonuc!=null ) {
      KULDATA.mesajid = sonuc;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Mesajlasma()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final eslesButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ButtonTheme(
        minWidth: 200.0,
        height: 100.0,
        child: RaisedButton(
          shape: CircleBorder(),
          elevation: 2.0,
          child: Text(
            'Eşleş',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          onPressed: () async {
            vil = true;
            String sonuc = await _uzakDatabase.esles();
            if (sonuc == "20") {             
              KULDATA.mesajid = await _uzakDatabase.eslesmeControl();
              KULDATA.ortakAdi = await _uzakDatabase.ortak(KULDATA.mesajid);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Mesajlasma()),
              );
            } else if (sonuc == "30") {
              while (true) {
                await Future.delayed(Duration(seconds: 2));
                print("2 saniye");
                String sonuc = await _uzakDatabase.eslesmeControl();
                if (sonuc != "1") {
                  KULDATA.ortakAdi = await _uzakDatabase.ortak(sonuc);
                  KULDATA.mesajid = sonuc;
                  break;
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Mesajlasma()),
              );
            }
          },
          padding: EdgeInsets.all(12),
          color: Colors.lightBlueAccent,
        ),
      ),
    );
    final spinner = Visibility(
        visible: vil,
        child: SpinKitRipple(
          color: Colors.white,
          size: 50,
        ));

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              Colors.lightBlueAccent,
              Colors.lightBlue,
              Colors.blueAccent,
              Colors.blue,
            ],
          )),
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: MediaQuery.of(context).size.height / 1.4,
              padding: EdgeInsets.only(top: 10, left: 8, right: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32)),
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 24.0, bottom: 24.0),
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Random',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Message',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 100.0),
                        eslesButton
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32)),
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            spinner
          ]),
        ));
  }
}
