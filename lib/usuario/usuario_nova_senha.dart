import 'package:flutter/material.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:connectivity/connectivity.dart';

class AlterarSenhaPage extends StatefulWidget {
  AlterarSenhaPage({Key key}) : super(key: key);

  @override
  _AlterarSenhaPageState createState() => _AlterarSenhaPageState();
}

class _AlterarSenhaPageState extends State<AlterarSenhaPage> {
  var isLoading = false;
  TextEditingController txtNomeEmail = new TextEditingController();
  TextEditingController txtSenhaActual = new TextEditingController();
  TextEditingController txtSenhaNova = new TextEditingController();
  TextEditingController txtSenhaConfirmar = new TextEditingController();

  BoxDecoration boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]);

  BoxDecoration boxDecorationSenhaActual = BoxDecoration(
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
          height: 200,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50.0,
                child: Image.asset('assets/images/jmr_logo.jpg'),
              ),
            ],
          ),
        ),

        // campo senha actual
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              margin: EdgeInsets.only(top: 32),
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: boxDecorationSenhaActual,
              child: TextField(
                obscureText: true,
                obscuringCharacter: '*',
                controller: txtSenhaActual,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.lock_open,
                      color: Colors.grey,
                    ),
                    hintText: 'Senha Actual'),
              ),
            )
          ],
        ),
        // campo nova senha

        Container(
          width: MediaQuery.of(context).size.width / 1.1,
          // height: 45,
          margin: EdgeInsets.only(top: 32),
          padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
          decoration: boxDecoration,
          child: TextField(
            obscureText: true,
            obscuringCharacter: '*',
            controller: txtSenhaNova,
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                hintText: 'Nova Senha'),
          ),
        ),
        // campo confirmacao nova senha

        Container(
          width: MediaQuery.of(context).size.width / 1.1,
          // height: 45,
          margin: EdgeInsets.only(top: 32),
          padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
          decoration: boxDecoration,
          child: TextField(
            obscureText: true,
            obscuringCharacter: '*',
            controller: txtSenhaConfirmar,
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                hintText: 'Confirmar Nova Senha'),
          ),
        ),

        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 50),
            child: MaterialButton(
                minWidth: double.infinity,
                // shape: StadiumBorder(),
                color: Colors.blue,
                child: Text(
                  "Alterar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  String senhaActual = txtSenhaActual.text.trim();
                  String senhaNova = txtSenhaNova.text.trim();
                  String senhaConfirmar = txtSenhaConfirmar.text.trim();
                  if (senhaActual.length < 6) {
                    setState(() => {
                          boxDecorationSenhaActual = BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.red, blurRadius: 5)
                              ])
                        });
                  } else if (senhaNova.length < 6) {
                    setState(() => {
                          boxDecorationSenhaActual = BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.red, blurRadius: 5)
                              ]),
                          boxDecoration = BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.red, blurRadius: 5)
                              ])
                        });
                  } else if (senhaActual == senhaNova &&
                      senhaNova == senhaConfirmar) {
                    boxDecorationSenhaActual = BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.red, blurRadius: 5)
                        ]);
                    boxDecoration = BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.red, blurRadius: 5)
                        ]);
                    setState(() => {boxDecorationSenhaActual, boxDecoration});
                  } else if ((senhaNova != senhaConfirmar)) {
                    setState(() => {
                          boxDecoration = BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.red, blurRadius: 5)
                              ])
                        });
                  } else {
                    boxDecoration = BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]);

                    boxDecorationSenhaActual = BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]);

                    var conexaoResultado =
                        await (Connectivity().checkConnectivity());
                    if (conexaoResultado == ConnectivityResult.mobile ||
                        conexaoResultado == ConnectivityResult.wifi) {
                      int rv = await SessaoApiProvider.alterarSenha(
                          senhaActual, senhaNova, senhaConfirmar);
                      if (rv == 1) {
                        setState(() {
                          boxDecoration = BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.red, blurRadius: 5)
                              ]);

                          //  boxDecorationSenhaActual = BoxDecoration(
                          //                   borderRadius: BorderRadius.all(Radius.circular(50)),
                          //                   color: Colors.white,
                          //                   boxShadow: [
                          //                     BoxShadow(color: Colors.red, blurRadius: 5)
                          //                   ]);
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("atenção"),
                              content: Text(
                                  "Erro de autenticação. Senha actual incorrecto"),
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
                      } else if (rv == 3) {
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
                      } else if (rv == 0) {
                        txtNomeEmail.clear();
                        txtSenhaActual.clear();
                        txtSenhaNova.clear();
                        txtSenhaConfirmar.clear();
                        Navigator.pushReplacementNamed(context, '/sucesso');
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
                  }

                  // Usuario usuario = await DBProvider.db.login(nome, senha);
                }),
          ),
        ),
      ],
    )));
  }
}
