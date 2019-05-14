import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:random_message/utils.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenAwareSize(MediaQuery.of(context).size.width, context),
      height: screenAwareSize(MediaQuery.of(context).size.height, context),
      
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xFF263d5a),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.white,
              tooltip: 'Çıkış Yap',
              onPressed: (){},
            )
          ],
        ),
        body: Container(
          color: Color(0xFF263d5a),
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 25),
                  Hero(
                    tag: 'profile',
                    child: Container(
                      height: 125.0,
                      width: 125.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(62.5),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/sedan.PNG'))),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Sedan ERDEM',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Ankara TR',
                    style:
                        TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '985',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'KONUŞMA SAYISI',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '-400',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'CEZA PUANI',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                  fontSize: 10),
                            )
                          ],
                        ),
                        
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
