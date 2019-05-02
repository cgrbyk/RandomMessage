import 'dart:async';
import 'package:flutter/material.dart';
import 'ApiDatabase.dart';
import 'mesajlasma.dart';
import 'KULDATA.dart';
import 'utils.dart';
import 'settings.dart';

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
    if (sonuc != "1" && sonuc != null) {
      KULDATA.mesajid = sonuc;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Mesajlasma()),
      );
    }
  }

  Widget settings() {
    return SizedBox(
      width: screenAwareSize(140, context),
      height: 100,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () {
           Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()));
        },
        padding: EdgeInsets.all(12),
        color: Colors.deepPurpleAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.settings,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text('Ayarlar',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget profile() {
    return SizedBox(
      width: screenAwareSize(140, context),
      height: 100,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () {},
        padding: EdgeInsets.all(12),
        color: Colors.deepOrangeAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.person,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text('Profil',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget eslesButton() {
    return SizedBox(
      width: screenAwareSize(300, context),
      height: 100,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () async {
          vil = true;
          String sonuc = await _uzakDatabase.esles();
          if (sonuc == "20") {
            KULDATA.mesajid = await _uzakDatabase.eslesmeControl();
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
        color: Colors.blueAccent,
        child: Text('Esles',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white)),
      ),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Random',
              style: TextStyle(
                  fontFamily: 'Montserrat', fontSize: 50, color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Message',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 70,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color(0xFF263d5a),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              size: screenAwareSize(20.0, context),
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
        body: Container(
          width: screenAwareSize(MediaQuery.of(context).size.width, context),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: screenAwareSize(200, context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[title()],
                ),
              ),
              SizedBox(
                height: screenAwareSize(40, context),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  eslesButton(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      profile(),
                      SizedBox(
                        width: 20,
                      ),
                      settings()
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
