import 'package:flutter/material.dart';
import 'esles.dart';
import 'ApiDatabase.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
  TextEditingController rekulsifre = TextEditingController();
  TextEditingController kulAdi = TextEditingController();
  TextEditingController kulSoyadi = TextEditingController();
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
        duration: Duration(milliseconds: 300),
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

  Widget callPage(int _selectedIndex) {
    switch (_selectedIndex) {
      case 0:
        return Container(
          height: MediaQuery.of(context).size.height / 1.3,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                left: 24.0, right: 24.0, top: 0.0, bottom: 24.0),
            children: <Widget>[
              SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Randomm',
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
              email(),
              SizedBox(height: 16.0),
              password(kulsifre),
              SizedBox(height: 8.0),
              loginButton(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  forgotLabel(),
                ],
              ),
              SizedBox(height: 8.0),
              socialLogin(),
              SizedBox(height: 8.0),
              facebookLoginButton(),
            ],
          ),
        );
      case 1:
        return Container(
          height: MediaQuery.of(context).size.height / 1.3,
          child: ListView(
            scrollDirection: Axis.vertical,
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
              name(),
              SizedBox(height: 8.0),
              surname(),
              SizedBox(height: 8.0),
              email(),
              SizedBox(height: 8.0),
              password(kulsifre),
              SizedBox(height: 8.0),
              password(rekulsifre),
              SizedBox(height: 8.0),
              signUpButton(),
            ],
          ),
        );

        break;
      default:
        return MyApp();
    }
  }

  Widget email() {
    return TextField(
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
  }

  Widget password(TextEditingController tecontroller) {
    return TextField(
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
      controller: tecontroller,
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
  }

  Widget name() {
    return TextField(
      autofocus: false,
      controller: kulAdi,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person,
          color: Colors.lightBlueAccent,
        ),
        hintText: 'Adınız',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      textInputAction: TextInputAction.next,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 20),
    );
  }

  Widget surname() {
    return TextField(
      autofocus: false,
      controller: kulSoyadi,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person,
          color: Colors.lightBlueAccent,
        ),
        hintText: 'Soyadınız',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      textInputAction: TextInputAction.next,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 20),
    );
  }

  Widget signUpButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () {
          if (kulsifre.text.isEmpty || kulAdi.text.isEmpty || kulSoyadi.text.isEmpty || kulmail.text.isEmpty || rekulsifre.text.isEmpty) {
            _showDialog("Boş bırakılamaz", "Lütfen bütün alanları doldurun");
          } else {
            if (kulsifre.text == rekulsifre.text) {
              _database.kayit(
                  kulAdi.text, kulSoyadi.text, kulmail.text, kulsifre.text);
            } else {
              _showDialog("şifre", "Şifreler aynı olmalıdır");
            }
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text(
            'Kayıt Ol',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          Icon(
            Icons.navigate_next,
            color: Colors.white,
          )
        ]),
      ),
    );
  }

  Widget loginButton() {
    return Padding(
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
            _showDialog("Başarısız giriş", "KullanıcıAdı veya şifre yanlış");
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[          
          Text(
            'Giriş Yap',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          Icon(
            Icons.navigate_next,
            color: Colors.white,
          )
        ]),
      ),
    );
  }

  Widget facebookLoginButton() {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () {},
        padding: EdgeInsets.all(12),
        color: Color(0xFF3b5998),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ImageIcon(
              AssetImage("assets/facebook.png"),
              color: Colors.white,
            ),
            AutoSizeText(
              'Facebook ile giriş yap',
              maxLines: 1,
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
  }

  Widget forgotLabel() {
    return FlatButton(
      child: Text(
        'Şifremi Unuttum',
        style: TextStyle(
            color: Colors.grey, fontFamily: 'Montserrat', fontSize: 16),
      ),
      onPressed: () {},
    );
  }

  Widget socialLogin() {
    return Row(
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
  }

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          width: MediaQuery.of(context).size.width / 10,
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    Widget bottomPanel() {
      return Container(
        padding: EdgeInsets.only(left: 16, right: 16),
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
                  });
                },
                child: _buildItem(item, selectedIndex == itemIndex),
              );
            }).toList()),
      );
    }

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
                    child: callPage(selectedIndex)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
