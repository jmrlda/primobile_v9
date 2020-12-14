import 'package:flutter/material.dart';
import 'package:primobile/Database/Database.dart';
import '../util.dart';
import 'cliente_modelo.dart';

List<Cliente> clientes = new List<Cliente>();
List<Cliente> clientesDuplicado = new List<Cliente>();

class ClientePage extends StatefulWidget {
  ClientePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ClientePageState createState() => new _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  TextEditingController editingController = TextEditingController();
  var duplicateItems;
  var items = List<_ListaTile>();
  var cli = Future;

  @override
  void initState() {
    super.initState();
    clientes = null;
    void getCli() async {
      clientes = await getClientes();
      // .then((value) => setState(() {
      //    clientes = value;
      //  }) );
    }

    getCli();
  }

  void filterSearchResults(String query) {
    List<Cliente> dummySearchList = List<Cliente>();

    dummySearchList.addAll(clientesDuplicado);
    if (query.trim().isNotEmpty) {
      List<Cliente> dummyListData = List<Cliente>();
      dummySearchList.forEach((item) {
        if (item.nome.toLowerCase().contains(query.toString()) ||
            item.cliente.toLowerCase().contains(query.toString())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        clientes.clear();
        clientes = dummyListData;
      });
      return;
    } else {
      setState(() {
        clientes.clear();
        clientes = dummySearchList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getClientes().then((value) => setState(() {
          clientesDuplicado = value;
        }));
    return new Scaffold(
      appBar: new AppBar(
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
        centerTitle: true,
        title: new Text("Clientes"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration:
                  BoxDecoration(color: Color.fromRGBO(241, 249, 255, 100)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 45,
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                      )
                    ]),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: 'Procurar'),
                      onChanged: (value) {
                        // filtroResultadoBusca( value );
                        filterSearchResults(value);
                      },
                      controller: editingController,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: listaCliente()),
          ],
        ),
      ),
    );
  }

  void opcaoAcao(String opcao) async {
    if (opcao == 'sincronizar') {
      SincronizarModelo(context, "cliente").then((value) async {
        if (value) {
          setState(() async {
            clientes = null;
          });
          clientes = await getClientes();
        }
      });
    }
  }

  Widget listaCliente() {
    if (clientes == null) {
      return Column(
        children: [CircularProgressIndicator(), Text("Aguarde")],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    } else if (clientes.length <= 0) {
      return Container(
        child: Text(
          "Nenhum Cliente encontrado. Sincronize os Dados",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return Scrollbar(
        isAlwaysShown: true,
        child: ListView.builder(
          itemCount: clientes.length,
          itemBuilder: (context, index) {
            Cliente cliente = clientes[index];
            return Container(
              child: _ListaTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.local_offer,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  cliente.nome,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  cliente.endereco.descricao +
                      ' - ' +
                      cliente.numContrib.toString() +
                      ' - ' +
                      "Encomenda Pendente: " +
                      cliente.encomendaPendente.toStringAsFixed(2) +
                      ' - ' +
                      "Venda não Convertida: " +
                      cliente.vendaNaoConvertida.toStringAsFixed(2) +
                      ' - ' +
                      "Total Deb: " +
                      cliente.totalDeb.toStringAsFixed(2) +
                      ' - ' +
                      "Limite Credito: " +
                      cliente.limiteCredito.toStringAsFixed(2),
                  style: TextStyle(color: Colors.blueAccent, fontSize: 14),
                ),
                data: cliente,
              ),
            );
          },
        ),
      );
    }
  }
}

class _ListaTile extends ListTile {
  _ListaTile(
      {Key key,
      this.leading,
      this.title,
      this.subtitle,
      this.trailing,
      this.isThreeLine = false,
      this.dense,
      this.contentPadding,
      this.enabled = true,
      this.onTap,
      this.onLongPress,
      this.selected = false,
      this.data = ""})
      : super(
            key: key,
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            isThreeLine: isThreeLine,
            dense: dense,
            contentPadding: contentPadding,
            enabled: enabled,
            onTap: onTap,
            onLongPress: onLongPress,
            selected: selected);
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final bool isThreeLine;
  final bool dense;
  final EdgeInsetsGeometry contentPadding;
  final bool enabled;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final bool selected;
  final dynamic data;

  dynamic getTitle() {
    return this.data;
  }

  bool contem(value) {
    return this.data.toLowerCase().contains(value.toString().toLowerCase());
  }
}

Future getClientes() async {
  return await DBProvider.db.getTodosClientes();
}

class Opcoes {
  static const String Sincronizar = 'sincronizar';

  static const List<String> escolha = <String>[
    Sincronizar,
  ];
}
