import 'package:flutter/material.dart';
import 'package:primobile/artigo/artigo_api_provider.dart';
import 'package:primobile/cliente/cliente_api_provider.dart';
import 'package:primobile/encomenda/encomenda_api_provider.dart';
import 'package:primobile/menu/opcoes.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool is_loading = true;
  var artigoApi = ArtigoApiProvider();
  var clienteApi = ClienteApiProvider();
  var encomendaApi = EncomendaApiProvider();
  bool artigo_sincronizado = false;
  bool cliente_sincronizado = false;
  String estado_sync = "";
  String estado_sync_num = "";

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
                        child: Image.asset('assets/images/jmr_logo.jpg'),
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

  List<Widget> menuItemView() {
    return [
      Material(
          color: Colors.white,
          child: Column(
            children: [
              Center(
                child: Ink(
                  width: 75,
                  height: 75,
                  decoration: const ShapeDecoration(
                    color: Colors.deepOrange,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    iconSize: 35,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, '/encomenda_novo');
                    },
                  ),
                ),
              ),
              Center(
                child: Text(
                  "ENCOMENDA",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )),
      Material(
        color: Colors.white,
        child: Column(children: [
          Center(
            child: Ink(
              width: 75,
              height: 75,
              decoration: const ShapeDecoration(
                color: Colors.redAccent,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                iconSize: 35,
                color: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, '/encomenda_lista');
                },
              ),
            ),
          ),
          Center(
            child: Text(
              "ENCOMENDA",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              "LISTA",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          )
        ]),
      ),
      Material(
          color: Colors.white,
          child: Column(
            children: [
              Center(
                child: Ink(
                  width: 75,
                  height: 75,
                  decoration: const ShapeDecoration(
                    color: Colors.green,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.local_offer),
                    iconSize: 35,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, '/artigo_lista');
                    },
                  ),
                ),
              ),
              Center(
                child: Text(
                  "ARTIGO",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )),
      Material(
        color: Colors.white,
        child: Column(
          children: [
            Center(
              child: Ink(
                width: 75,
                height: 75,
                decoration: const ShapeDecoration(
                  color: Colors.lightBlue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.person,
                  ),
                  iconSize: 35,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/cliente_lista');
                  },
                ),
              ),
            ),
            Center(
              child: Text(
                "CLIENTE",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      )
    ];
  }

  void opcaoAcao(String opcao) async {
    if (opcao == 'Sincronizar') {
      await _loadFromApi();
    } else if (opcao == 'Sair') {
      Navigator.pushReplacementNamed(context, '/');
    } else if (opcao == 'Alterar Senha') {
      Navigator.pushNamed(context, '/alterar_senha');
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
                if ((clienteApi.sincronizado == true &&
                    artigoApi.sincronizado == true &&
                    encomendaApi.sincronizado == true)) {
                  Navigator.of(context).pop();
                }
              });
            });

            return WillPopScope(
              child: AlertDialog(
                title: Container(
                  child: Text("Sincronizando " + estado_sync + " Aguarde ... " + estado_sync_num),
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
      estado_sync = "Cliente";
      estado_sync_num = "(1/3)";
      await clienteApi.getTodosClientes();
      estado_sync_num = "Encomenda";
            estado_sync = "(2/3)";
      await encomendaApi.getTodasEncomendas();
      estado_sync = "Artigo";
                  estado_sync_num = "(3/3)";
      await artigoApi.getTodosArtigos();
    } catch (e) {
      print('Erro: $e.message');
    }
  }
}
