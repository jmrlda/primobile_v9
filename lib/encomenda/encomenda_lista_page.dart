import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:primobile/Database/Database.dart';
import 'encomendaItem_modelo.dart';
import 'encomenda_modelo.dart';


List<Encomenda> encomendas = new List<Encomenda>();
List<EncomendaItem> encomendaItens = new List<EncomendaItem>();

List<Encomenda> encomendaDuplicado = new List<Encomenda>();
List<Widget> children = List<Widget>();

class EncomendaListaPage extends StatefulWidget {
  EncomendaListaPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EncomendaPageState createState() => new _EncomendaPageState();
}

class _EncomendaPageState extends State<EncomendaListaPage> {
  TextEditingController txt_pesquisar_encomenda = TextEditingController();

  @override
  void initState() {
    super.initState();
    getEncomenda().then((value) => setState(() {
          encomendas = value;
        }));

    getEncomendaItem().then((value) => setState(() {
          encomendaItens = value;
        }));
  }

  void filterSearchResults(String query) {
    List<Encomenda> dummySearchList = List<Encomenda>();

    dummySearchList.addAll(encomendaDuplicado);
    if (query.trim().isNotEmpty) {
      List<Encomenda> dummyListData = List<Encomenda>();
      dummySearchList.forEach((item) {
        if (item.cliente.cliente.toLowerCase().contains(query.toString())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        encomendas.clear();
        encomendas = dummyListData;
      });
      return;
    } else {
      setState(() {
        encomendas.clear();
        encomendas = dummySearchList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getEncomenda().then((value) => setState(() {
          //  artigos = value;
          encomendaDuplicado = value;
        }));
    getEncomendaItem().then((value) => setState(() {
          encomendaItens = value;
        }));
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: new Text("Encomendas"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Column(
              children: [
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
                        padding: EdgeInsets.only(
                            top: 4, left: 16, right: 16, bottom: 4),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
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
                            filterSearchResults(value);
                          },
                          controller: txt_pesquisar_encomenda,
                        ),
                      ),
                    ],
                  ),
                ),
                listarEncomenda()
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget listarEncomenda() {
    List<Widget> children = List<Widget>();
    if (encomendas == null || encomendas.length <= 0) {
      return Container(
        child: _ListaTile(
            title: Align(
          alignment: Alignment.topCenter,
          child: Text(
            "Encomenda não encontrado",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
        )),
      );
    } else {
      // List encDB = encomendas;
      List<Encomenda> li = encomendas; //List<Encomenda> ();
      List<EncomendaItem> item = encomendaItens;
      li.forEach((enc) {
        // List<EncomendaItem> liEnc = item.map((e) => e.encomendaPk == enc1.id );

        children.add(Padding(
            padding: const EdgeInsets.only(top: 16),
            child: encomenda(context, enc, item)));
      });

      return Expanded(child: ListView(children: children));
    }
  }
}

Widget listarArtigo() {
  if (encomendas == null || encomendas.length <= 0) {
    return Container(
      child: _ListaTile(
          title: Align(
        alignment: Alignment.topCenter,
        child: Text(
          "Encomenda não encontrado",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
          ),
        ),
      )),
    );
  } else {
    return Scrollbar(
      isAlwaysShown: true,
      child: ListView.builder(
        itemCount: encomendas.length,
        itemBuilder: (context, index) {
          Encomenda encomenda = encomendas[index];
          return Container(
              child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.local_offer,
                color: Colors.white,
              ),
            ),
            title: Text(
              encomenda.cliente.cliente.toString() ,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "teste" + encomenda.artigos.length.toString(),
              style: TextStyle(color: Colors.blueAccent, fontSize: 16),
            ),
          )
            
              );
        },
      ),
    );
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
  final String data;

  String getTitle() {
    return this.data;
  }

  bool contem(value) {
    return this.data.toLowerCase().contains(value.toString().toLowerCase());
  }
}

Future teste() async {
  var res = await DBProvider.db.getTodosArtigos();

  return res;
}

Future<List<Encomenda>> getEncomenda() async {
  List<Encomenda> res = await DBProvider.db.getTodasEncomendas();

  return res;
}

Future<List<EncomendaItem>>  getEncomendaItem() async {
  List<EncomendaItem> res = await DBProvider.db.getTodasEncomendaItens();

  return res;
}

// metodos uteis

ExpansionTile encomendaItem(
    BuildContext context, Encomenda enc, List<EncomendaItem> itens) {
  int count = 0;
  double totalValor = 0.0;
  List<DataTable> encomendaItens = List<DataTable>();

  encomendaItens.add(DataTable(
    columns: [
      DataColumn(
        label: Text(
          "Artigo",
          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900,
        ))),
      DataColumn(
        label: Text(
          "Qtd.",
          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900,
        ))),
      DataColumn(
        label: Text(
          "p.Unit",
          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900,
        ))),
      DataColumn(
        label: Text(
          "Estado",
          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900,
        )))


        
    ], rows: [],
  ));

  itens.forEach((element) {
    EncomendaItem e = element;
    if (e.encomendaPk.toString() == enc.id) {
      totalValor += e.valorTotal;
      count++;
      encomendaItens.elementAt(0).rows.add(
          DataRow(
            cells:[
              DataCell(Text(e?.artigoPk.toString())),
              DataCell(Text(e.quantidade.toString())),
              DataCell(Text(e.valorUnit.toString())),
              DataCell(Text(enc.estado)),

            ]
          )
          );
    }
  });

  return ExpansionTile(
    title: Padding(
      padding: EdgeInsets.only(top: 15, left: 16, right: 16),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.,
        children: <Widget>[
          Text(enc.id.toString(),
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          Padding(
            padding: EdgeInsets.only(left: 55),
            child: Text(enc.encomenda_id,
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        ],
      ),
    ),
    subtitle: Column(
      children: [
        Divider(),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(count > 1 ?  count.toString() + " Artigos" : "1 Artigo",
                  style: TextStyle(color: Colors.blue, fontSize: 14)),
              Padding(
                padding: EdgeInsets.only(
                  left: 30,
                ),
                child: Text(totalValor.toString() + "MTN",
                    style: TextStyle(color: Colors.blue, fontSize: 14)),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 30,
                ),
                child: Text(enc.cliente.cliente,
                    style: TextStyle(color: Colors.blue, fontSize: 14)),
              ),
            ],
          ),
        ),
      ],
    ),
    children: encomendaItens,
  );

  
}

Slidable encomenda(
    BuildContext context, Encomenda enc, List<EncomendaItem> itens) {

  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.18,
    child: encomendaItem(context, enc, itens),
    secondaryActions: <Widget>[
      IconSlideAction(
        caption: 'Editar',
        color: Colors.black45,
        icon: Icons.edit,
        onTap: () {
          // EncomendapiProvider encomendaApi = EncomendapiProvider();
          // encomendaApi.getTodasEncomendas("token");
          // EncomendaPage();
        },
      ),
      IconSlideAction(
        caption: 'Cancelar',
        color: Colors.blueGrey,
        icon: Icons.block,
        onTap: () => EncomendaListaPage(),
      ),
      IconSlideAction(
        caption: 'Remover',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () => _ackAlert(context),
      ),
      IconSlideAction(
        caption: 'Ver',
        color: Colors.green,
        icon: Icons.open_with,
      ),
    ],
  );
}

Future<void> _ackAlert(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // title: Text('Not in stock'),
        content: Container(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                Icons.block,
                size: 180,
                color: Colors.blue,
              ),
              Text(
                'Tem a certeza que\n deseja remover ?',
                style: TextStyle(color: Colors.blue),
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            shape: CircleBorder(),
            color: Colors.blue[100],
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(15.0),
            splashColor: Colors.blueAccent,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Nao",
              style: TextStyle(fontSize: 18.0, color: Colors.blue),
            ),
          ),
          FlatButton(
            shape: CircleBorder(),
            color: Colors.red,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(15.0),
            splashColor: Colors.blueAccent,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Sim",
              style: TextStyle(fontSize: 18.0),
            ),
          )
        ],
      );
    },
  );
}
