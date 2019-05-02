import 'package:flutter/material.dart';
import 'utils.dart';
import 'package:flutter/cupertino.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  
  Widget card(){
    return Container(
      width: screenAwareSize(MediaQuery.of(context).size.width, context),
      height: screenAwareSize(65, context),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Card(
        elevation: 2,
        color: Color(0xff466a96),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.folder,color: Colors.white,size: 30,),
            SizedBox(width: 20,),
            Text('Sürüm Notları',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)
          ],
        ),
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
              CupertinoIcons.back,
              size: screenAwareSize(20.0, context),
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Ayarlar',style: TextStyle(fontFamily: 'Montserrrat',fontSize: 20,fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: Container(
          width: screenAwareSize(MediaQuery.of(context).size.width, context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              card(),
              SizedBox(height: 10,),
              card(),
            ],
          ),
        ),
        
      ),
    );
  }
}