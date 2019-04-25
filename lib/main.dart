import 'package:flutter/material.dart';
import 'esles.dart';
import 'ApiDatabase.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'signUp.dart';

//import 'package:flutter_screenutil/flutter_screenutil.dart';
void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController kulmail = TextEditingController();
  TextEditingController kulsifre = TextEditingController();
  ApiDatabase _database = ApiDatabase();
  bool visible = false;
  bool falsePassword = false;

  FocusNode kulsifreNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    Widget horizontalLine() => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: MediaQuery.of(context).size.width / 6,
            height: 1.0,
            color: Colors.black26.withOpacity(.2),
          ),
        );

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
      controller: kulmail,
      textInputAction: TextInputAction.next,
      onSubmitted: (String s) {
        FocusScope.of(context).requestFocus(kulsifreNode);
      },
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
      controller: kulsifre,
      focusNode: kulsifreNode,
      textInputAction: TextInputAction.done,
      onSubmitted: (String s) async {
        visible = true;
        setState(() {});
        bool girissonuc =
            await _database.giris(kulmail.value.text, kulsifre.value.text);
        if (girissonuc) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Esles()),
          );
        } else {
          print("Kullanici adi veya sifre yanlis");
        }
      },
      style: TextStyle(
          fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 20),
    );
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          visible = true;
          setState(() {});
          bool girissonuc =
              await _database.giris(kulmail.value.text, kulsifre.value.text);
          if (girissonuc) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Esles()),
            );
          } else {
            print("Kullanici adi veya sifre yanlis");
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 120.0),
            child: Text(
              'Giriş Yap',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          SizedBox(width: 40),
          Icon(
            Icons.navigate_next,
            color: Colors.white,
          )
        ]),
      ),
    );
    final facebookLoginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {},
        padding: EdgeInsets.all(12),
        color: Color(0xFF3b5998),
        child: Row(
          children: <Widget>[
            ImageIcon(
              AssetImage("assets/facebook.png"),
              color: Colors.white,
            ),
            SizedBox(width: 20),
            Text(
              'Facebook ile giriş YAP AMK',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20),
            )
          ],
        ),
      ),
    );
    final googleLoginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {},
        padding: EdgeInsets.all(12),
        color: Color(0xFFff3e30),
        child: Row(
          children: <Widget>[
            ImageIcon(
              AssetImage("assets/google.png"),
              color: Colors.white,
            ),
            SizedBox(width: 50),
            Text(
              'Google ile giriş yap',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20),
            )
          ],
        ),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Şifremi Unuttum',
        style: TextStyle(color: Colors.white54),
      ),
      onPressed: () {},
    );
    final createAccount = FlatButton(
      child: Text(
        'Hala üye değil misiniz?',
        style: TextStyle(color: Colors.white54),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUp()),
        );
      },
    );
    final spinner = Visibility(
        visible: visible,
        child: SpinKitRipple(
          color: Colors.white,
          size: 50,
        ));
    final socialLogin = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        horizontalLine(),
        Text(
          'Sosyal Medya',
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Montserrat',
          ),
        ),
        horizontalLine()
      ],
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xFF263d5a),
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
            Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    color: Colors.white,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 0.0, bottom: 24.0),
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
                        SizedBox(height: 8),
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
                        SizedBox(height: 24.0),
                        email,
                        SizedBox(height: 16.0),
                        password,
                        SizedBox(height: 8.0),
                        loginButton,
                        SizedBox(height: 8.0),
                        socialLogin,
                        SizedBox(height: 8.0),
                        facebookLoginButton,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            createAccount,
            forgotLabel,
            spinner,
          ],
        ),
      ),
    );
  }
}
