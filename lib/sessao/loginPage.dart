import 'package:flutter/material.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:connectivity/connectivity.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var isLoading = false;
  TextEditingController txtNomeEmail = new TextEditingController();
  TextEditingController txtSenha = new TextEditingController();
  BoxDecoration boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]);
  Dialog dialog = new Dialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
                Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.9,
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

          // campo email
                    Container(
            width: MediaQuery.of(context).size.width / 1.1,
            margin: EdgeInsets.only(top: 64),
            padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
            decoration: boxDecoration,
            child: TextField(
              controller: txtNomeEmail,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  hintText: 'Email'),
            ),
          ),


            // campo senha
            Container(
            width: MediaQuery.of(context).size.width / 1.1,
            // height: 45,
            margin: EdgeInsets.only(top: 32),
            padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
            decoration: boxDecoration,
            child: TextField(
              obscureText: true,
              obscuringCharacter: '*',
              controller: txtSenha,
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


          Align(
            alignment: FractionalOffset.bottomCenter,
                      child: Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 60),
              child: MaterialButton(
                  minWidth: double.infinity,
                  shape: StadiumBorder(),
                  color: Colors.blue,
                  child: Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () async {
                    String nome = txtNomeEmail.text.trim();
                    String senha = txtSenha.text.trim();
                    var conexaoResultado =
                        await (Connectivity().checkConnectivity());
                    if (conexaoResultado == ConnectivityResult.mobile ||
                        conexaoResultado == ConnectivityResult.wifi) {
                      int rv = await SessaoApiProvider.login(nome, senha);
                      if (rv == 1) {
                        setState(() {
                          boxDecoration = BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.red, blurRadius: 5)
                              ]);
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("atenção"),
                              content: Text(
                                  "Erro de autenticação. Verificar o Nome e a Senha"),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text("Fechar"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else if (rv == 2) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("atenção"),
                              content: Text(
                                  "Erro de Conexão. Sem acesso a internet ou servidor não responde!"),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text("Fechar"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }else if (rv == 3) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("atenção"),
                              content: Text(
                                  "Ocorreu um erro desconhecido. Tentar novamente!"),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text("Fechar"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } 
                      else if (rv == 0) {
                        txtNomeEmail.clear();
                        txtSenha.clear();
                        Navigator.pushNamed(context, '/menu');
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("atenção"),
                            content: Text(
                                "Erro de Conexão. Verificar se os Dados ou Wifi estão ligados!"),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Fechar"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }

                    // Usuario usuario = await DBProvider.db.login(nome, senha);
                  }),
            ),
          ),
            ],
          )
        )
        
        );
  }
}
