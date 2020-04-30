import 'package:flutter/material.dart';
import 'package:primobile/artigo/artigo_api_provider.dart';
import 'package:primobile/cliente/cliente_api_provider.dart';
import 'package:primobile/menu/opcoes.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:primobile/sessao/loginPage.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
      bool is_loading = true;
      var artigoApi = ArtigoApiProvider();
      var clienteApi = ClienteApiProvider();
      bool artigo_sincronizado = false;
      bool cliente_sincronizado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Center(
            child: Text('Menu'),
          ),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: opcaoAcao,
              itemBuilder: (BuildContext context) {
                return Opcoes.escolha.map((String escolha) {
                  return PopupMenuItem<String>(
                    value: escolha,
                    child: Text(escolha),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
                  child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.5,
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
                        child: Icon(
                          Icons.widgets,
                          size: 50.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    // container menu body
                    Container(
                      width: MediaQuery.of(context).size.width - 16,
                      height: MediaQuery.of(context).size.height / 2,
                      margin: EdgeInsets.only(top: 64),
                      child: GridView.count(
                        crossAxisCount: 3,
                        children: menuItemView(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  List<Card> menuItemView() {
    return [
      Card(
        color: Colors.white,
        child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/encomenda_novo');
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(Icons.add_shopping_cart, size: 80, color: Colors.blue),
                  Text('ENCOMENDA'),
                ],
              ),
            )),
      ),
      Card(
        color: Colors.white,
        child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/encomenda_lista');
            },
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.shopping_cart, size: 80, color: Colors.blue),
                  Text('ENCOMENDA'),
                  Text('LISTA'),
                ],
              ),
            )),
      ),
      Card(
        color: Colors.white,
        child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/artigo_lista');
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.local_offer, size: 80, color: Colors.blue),
                  Text('ARTIGO'),
                ],
              ),
            )),
      ),
      Card(
        color: Colors.white,
        child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/cliente_lista');
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.person, size: 80, color: Colors.blue),
                  Text(
                    'CLIENTE',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            )),
      ),
    ];
  }

  void opcaoAcao(String opcao) async {
    if (opcao == 'sincronizar') {
      await _loadFromApi();
    } else if (opcao == 'sair' ) {
              Navigator.pushReplacementNamed(context, '/' );
    }
  }

  Future _loadFromApi() async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            new Future.delayed(new Duration(seconds: 3), () {
                                            

              setState(() {
               if (clienteApi.sincronizado == true &&
                  artigoApi.sincronizado == true ) {
                       Navigator.of(context).pop();

                  }
              });
            });

            return WillPopScope(
              child: AlertDialog(
                title: Container(
                  child:
                      Text("Sincronizando Aguarde ..."),
                ),
                content: Loading(
                    indicator: BallPulseIndicator(), color: Colors.blueAccent),
                actions: <Widget>[],
              ),
              onWillPop: () async => false,
            );
          },
        );
      },
    );

    try {
         artigoApi.getTodosArtigos();
         clienteApi.getTodosClientes();
    } catch (e) {
      print('Erro: $e.message');
    }
  }
}
