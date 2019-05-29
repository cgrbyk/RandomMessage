import 'dart:async';
import 'package:flutter/material.dart';
import 'package:random_message/kontrolDonus.dart';
import 'ClientModel.dart';
import 'Database.dart';
import 'ApiDatabase.dart';
import 'KULDATA.dart';
import 'rmesaj.dart';
import 'bildirim.dart';

class Mesajlasma extends StatefulWidget {
  @override
  SecondRoute createState() => SecondRoute();
}

class SecondRoute extends State<Mesajlasma> with WidgetsBindingObserver {
  TextEditingController girilen = new TextEditingController();
  ApiDatabase _uzakDatabase = ApiDatabase();
  ScrollController sc = new ScrollController();
  Timer _everySecond;
  Timer _every5Second;
  List<Rmesaj> mesajlar = List<Rmesaj>();

  AppLifecycleState _lifecycleState;
  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lifecycleState = state;
    });
  }

  void _showDialog(String title, String message) {
    //
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Alignment algPicker(Rmesaj c) {
    //print(c.gonderenid.toString()+"----"+KULDATA.kulId.toString());
    if (c.gonderenid == KULDATA.kulId) {
      return Alignment.centerRight;
    } else {
      return Alignment.centerLeft;
    }
  }

  @override
  void initState() {
    super.initState();
    _uzakDatabase.setmindextozero();
    DBProvider.db.deleteAll();
    Bildirim bil = new Bildirim();
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      Client rnd = Client();
      mesajlar= await _uzakDatabase.mesajcek();
      if (!mesajlar[0].isnull) {
        if (_lifecycleState == AppLifecycleState.paused) {
          bil.bildirimGonder("Mesaj Geldi", mesajlar[0].mesaj,
              mesajlar[0].mindex.toString());
        }
        for (Rmesaj gelenmesaj in mesajlar) {
          _uzakDatabase.incmindex();
          rnd.kelime = " " + gelenmesaj.mesaj;
          rnd.index = gelenmesaj.mindex;
          rnd.gonderenid = gelenmesaj.gonderenid;
          await DBProvider.db.newClient(rnd);
        }
        sc.animateTo(sc.position.maxScrollExtent,
            duration: Duration(seconds: 1), curve: Curves.ease);
        setState(() {});
      }
    });
    _every5Second = Timer.periodic(Duration(seconds: 5), (Timer t) async {
      String mesajkontrol = await _uzakDatabase.bitiskontrol();
      print("Mesaj Kontrol donen = " + mesajkontrol);
      if (mesajkontrol == "10") {
        _everySecond.cancel();
        _every5Second.cancel();
        await DBProvider.db.deleteAll();
        if (Navigator.canPop(context)) Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.lightBlueAccent,
        title: Text(KULDATA.ortakAdi + " ile konuşuyorsun"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () async {
              _everySecond.cancel();
              _every5Second.cancel();
              await _uzakDatabase.eslesmeBitir();
              await DBProvider.db.deleteAll();
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          )
        ],
        leading: new Container(),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 16.0, 5.0, 0.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              new Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: mesajlar.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              color: Colors.white,
                              child: SizedBox(
                                  height: 50,
                                  child: Align(
                                      alignment: algPicker(mesajlar[index]),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16.0),
                                        child: Text(mesajlar[index].mesaj + " ",
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            )),
                                      )))),
                          //leading: Text(item.index.toString()),
                        );
                      },
                    ),
                  )
                ],
              ),
              TextField(
                controller: girilen,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Mesajını Yaz',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                textInputAction: TextInputAction.send,
                maxLength: 60,
                onSubmitted: (String s) async {
                  Client rnd = Client(
                      kelime: girilen.value.text + " ",
                      gonderenid: KULDATA.kulId);
                  KontrolDonus ayni = await _uzakDatabase.mesajGonder(s);
                  if (!ayni.issame)
                    await DBProvider.db.newClient(rnd);
                  else {
                    _showDialog(ayni.kelime, ayni.mesaj);
                  }
                  girilen.clear();
                  FocusScope.of(context).requestFocus(new FocusNode());
                  sc.animateTo(sc.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                  setState(() {});
                },
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
