import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    // begin: ``
                    colors: [Colors.blue, Colors.blueAccent]),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50.0,
                  child: Icon(
                    Icons.widgets,
                    size: 50.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: 45,
            margin: EdgeInsets.only(top: 64),
            padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  hintText: 'Email'),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: 45,
            margin: EdgeInsets.only(top: 32),
            padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.vpn_key,
                    color: Colors.grey,
                  ),
                  hintText: 'Senha'),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 32),
              child: Text(
                'Esqueci a Senha',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only( left:30.0, right: 30.0, bottom: 60),
            child: MaterialButton(
              minWidth: double.infinity,
              shape:StadiumBorder(),
              color: Colors.blue,
              child: Text("Entrar", style: TextStyle(color: Colors.white, fontSize: 20),),
              onPressed: () {
                Navigator.pushNamed(context, '/menu');

              }),
            ),
          
        ],
      ),
    ));
  }


}

