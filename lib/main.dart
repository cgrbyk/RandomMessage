import 'package:flutter/material.dart';
import 'esles.dart';
import 'ApiDatabase.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'signUp.dart';

//import 'package:flutter_screenutil/flutter_screenutil.dart';
void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));

class NavigationItem {
  final Text title;
  final Color color;
  NavigationItem(this.title, this.color);
}

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
  int selectedIndex = 0;
  List<NavigationItem> items = [
    NavigationItem(Text('Giriş'), Colors.lightBlueAccent),
    NavigationItem(Text('Kayıt'), Colors.lightBlueAccent)
  ];

  FocusNode kulsifreNode = new FocusNode();
  Widget _buildItem(NavigationItem item, bool isSelected) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: isSelected
            ? MediaQuery.of(context).size.width / 2
            : MediaQuery.of(context).size.width / 2.7,
        height: 50,
        decoration: BoxDecoration(
            color: isSelected ? item.color : Color(0xff405f87),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DefaultTextStyle.merge(
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.white24),
                child: item.title),
          ],
        ));
  }

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

    Widget bottomPanel() {
      return Container(
        padding: EdgeInsets.only(left: 16,right: 16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 10,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) {
              var itemIndex = items.indexOf(item);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = itemIndex;
                    print(itemIndex);
                  });
                },
                child: _buildItem(item, selectedIndex == itemIndex),
              );
            }).toList()),
      );
    }

    
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
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
      padding: EdgeInsets.only(top: 8),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
      padding: EdgeInsets.only(top: 8),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
              'Facebook ile giriş yap',
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
        style: TextStyle(
            color: Colors.black45, fontFamily: 'Montserrat', fontSize: 12),
      ),
      onPressed: () {},
    );
    final createAccount = FlatButton(
      child: Text(
        'Hala üye değil misiniz?',
        style: TextStyle(
            color: Colors.black45, fontFamily: 'Montserrat', fontSize: 12),
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
      
      bottomNavigationBar: bottomPanel(),
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xFF263d5a),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: Colors.white,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 0.0, bottom: 24.0),
                      children: <Widget>[
                        SizedBox(height: 16),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[forgotLabel],
                        ),
                        SizedBox(height: 8.0),
                        socialLogin,
                        SizedBox(height: 8.0),
                        facebookLoginButton,
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
