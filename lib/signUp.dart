import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final email = TextField(
   keyboardType: TextInputType.emailAddress,
    autofocus: false,
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.email,
        color: Colors.lightBlueAccent,
      ),
      hintText: 'Email',
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    ),
    textInputAction: TextInputAction.next,
    style: TextStyle(
        fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 20),
  );
  final password = TextField(
    autofocus: false,
    obscureText: true,
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.vpn_key,
        color: Colors.lightBlueAccent,
      ),
      hintText: 'Şifre',
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    ),
    textInputAction: TextInputAction.next,
    style: TextStyle(
        fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 20),
  );
  final name =TextField(
    autofocus: false,
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.person,
      color: Colors.lightBlueAccent,),
      hintText: 'Adınız',
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      
    ),
    textInputAction: TextInputAction.next,
    style: TextStyle(
        fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 20),
  );
  final surname =TextField(
    autofocus: false,
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.person,
      color: Colors.lightBlueAccent,),
      hintText: 'Soyadınız',
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      
    ),
    textInputAction: TextInputAction.next,
    style: TextStyle(
        fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 20),
  );
  final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: (){},
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:120.0),
            child: Text(
              'Kayıt Ol',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          SizedBox(width: 80),
          Icon(Icons.navigate_next,color: Colors.white,)
        ]),
      ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0.0,
      ),
      resizeToAvoidBottomPadding: false,
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
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  color: Colors.white,
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 36.0, bottom: 36.0),
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
                      SizedBox(height: 48.0),
                      name,
                      SizedBox(height: 16.0,),
                      surname,
                      SizedBox(height: 16.0,),
                      email,
                      SizedBox(height: 16.0),
                      password,
                      SizedBox(height: 16.0),
                      signUpButton
                    ],
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
