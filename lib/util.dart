import 'package:flutter/material.dart';

import 'artigo/artigo_api_provider.dart';
import 'cliente/cliente_api_provider.dart';
import 'encomenda/encomenda_api_provider.dart';

Future SincronizarModelo(context, modelo) async {
  var artigoApi = ArtigoApiProvider();
  var clienteApi = ClienteApiProvider();
  var encomendaApi = EncomendaApiProvider();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          new Future.delayed(new Duration(seconds: 3), () {
            setState(() {
              if (modelo == "cliente") {
                if (clienteApi.sincronizado == true) {
                  Navigator.of(context).pop();
                }
              } else if (modelo == "artigo") {
                if (artigoApi.sincronizado == true) {
                  Navigator.of(context).pop();
                }
              } else if (modelo == "encomenda") {
                if (encomendaApi.sincronizado == true) {
                  Navigator.of(context).pop();
                }
              }
            });
          });

          return WillPopScope(
            child: AlertDialog(
              title: Container(
                child: Text("Sincronizando Aguarde ..."),
              ),
              content: Container(
                  width: 50,
                  height: 50,
                  child: Center(child: CircularProgressIndicator())),
              actions: <Widget>[],
            ),
            onWillPop: () async => false,
          );
        },
      );
    },
  );

  try {
    if (modelo == "cliente") {
      clienteApi.getTodosClientes();
    } else if (modelo == "artigo") {
      artigoApi.getTodosArtigos();
    } else if (modelo == "encomenda") {
      encomendaApi.getTodasEncomendas();
    }
  } catch (e) {
    print('Erro: $e.message');
  }
}



class SucessoPage extends StatelessWidget {
  const SucessoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue[50],
        child: Container(
          child: Card(
            margin: EdgeInsets.only(top: 120, bottom: 120, left: 50, right: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                  size: 200,
                ),
                Text(
                  "Sucesso",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
          
                MaterialButton(
                  height: 56,
                  color: Colors.blue[50],
                  shape: CircleBorder(),
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                )
              ],
            ),
          ),
        ));
  }
}
