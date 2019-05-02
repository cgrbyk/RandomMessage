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

  AppLifecycleState _lifecycleState;
  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lifecycleState = state;
    });
  }

  void _showDialog(String title,String message) {
    //
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(
              message),
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

  Alignment algPicker(Client c) {
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
      List<Rmesaj> gelenmesajDizi = new List<Rmesaj>();
      gelenmesajDizi = await _uzakDatabase.mesajcek();
      if (!gelenmesajDizi[0].isnull) {
        if (_lifecycleState == AppLifecycleState.paused) {
          bil.bildirimGonder("Mesaj Geldi", gelenmesajDizi[0].mesaj,
              gelenmesajDizi[0].mindex.toString());
        }
        for (Rmesaj gelenmesaj in gelenmesajDizi) {
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
              new Container(
                  height: MediaQuery.of(context).size.height / 5 * 4,
                  child: FutureBuilder<List<Client>>(
                    future: DBProvider.db.getAllClients(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Client>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          controller: sc,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            Client item = snapshot.data[index];
                            var dismissible = Dismissible(
                              key: UniqueKey(),
                              background: Container(color: Colors.red),
                              onDismissed: (dissmissdirection) async {
                                print("Dissmisssed " + index.toString());
                                await DBProvider.db.deleteFromIndex(item.index);

                                setState(() {});
                              },
                              child: ListTile(
                                title: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    color: Colors.white,
                                    child: SizedBox(
                                        height: 50,
                                        child: Align(
                                            alignment: algPicker(item),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, right: 16.0),
                                              child: Text(item.kelime + " ",
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  )),
                                            )))),
                                //leading: Text(item.index.toString()),
                              ),
                            );
                            return dismissible;
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 48.0),
                child: TextField(
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
