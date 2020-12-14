import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// local
import 'package:primobile/Database/Database.dart';
import '../util.dart';
import 'encomendaItem_modelo.dart';
import 'encomenda_modelo.dart';


List<Encomenda> encomendas = new List<Encomenda>();
List<EncomendaItem> encomendaItens = new List<EncomendaItem>();

List<Encomenda> encomendaDuplicado = new List<Encomenda>();
List<Widget> children = List<Widget>();
String filtro = null;
bool sort = true;

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
    encomendas = null;
    sort = true;
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
      floatingActionButton: lista_controlo(),
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
    void opcaoAcao(String opcao) async {
    if (opcao == 'sincronizar') {

      setState(()=> {
              SincronizarModelo(context,"encomenda")
      });
    }
  }



  Widget listarEncomenda() {
    List<Widget> children = List<Widget>();
   
 if (encomendas == null) {
    return Container(child: Center(child: CircularProgressIndicator()));

  } else if (encomendas.length <= 0) {

    return Container(
      child: Text(
        "Nenhuma encomenda encontrada. Sincronize os Dados",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  } else {
      // List encDB = encomendas;
      List<Encomenda> li = encomendas; //List<Encomenda> ();
      List<EncomendaItem> item = encomendaItens;
      // li.forEach((enc)
            int pos = 1;
      if ( sort == true) {
                                li = li.reversed.toList();

                // pos = li.length - 1;
      } else {
        // pos = 1;
                li = encomendas;

      }
      for (int i = 0; i < li.length; i++) {
        Encomenda enc = li[i];
        // List<EncomendaItem> liEnc = item.map((e) => e.encomendaPk == enc1.id );
         if ( filtro == 'pendente') {
          if (enc.estado != 'pendente') continue;
        } else if ( filtro == 'processado') {
          if (enc.estado != 'processado') continue;
        }

        children.add(Padding(
            padding: const EdgeInsets.only(top: 16),
            child: encomenda(context, enc, item, pos)));

    //  sort == true ? pos-- : pos++;
    pos++;
      }

      return Expanded(child: ListView(children: children));
    }
  }
  

Widget lista_controlo() {

 return  SpeedDial(
          // both default to 16
          marginRight: 18,
          marginBottom: 20,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          visible: true,
          // If true user is forced to close dial manually 
          // by tapping main button and overlay is not rendered.
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.view_list),
              backgroundColor: Colors.blue,
              label: 'Todas encomendas',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => setState(()=>filtro=null),
            ),
            SpeedDialChild(
              child: Icon(Icons.schedule),
              backgroundColor: Colors.red,
              label: 'Pendentes',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => setState(()=>filtro = 'pendente'),
            ),
            SpeedDialChild(
              child: Icon(Icons.done_all),
              backgroundColor: Colors.green,
              label: 'Processadas',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => setState(()=>filtro = 'processado'),
            ),
          
           SpeedDialChild(
              child: Icon(Icons.sort),
              backgroundColor: Colors.yellow,
              label: sort == false  ? 'Modo Descendente' : 'Modo Ascendente',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => setState(()=> sort = !sort),
            ),
          ],
        );
    
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
    BuildContext context, Encomenda enc, List<EncomendaItem> itens, pos) {
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
          "P.Unit",
          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900,
        ))),
   DataColumn(
        label: Text(
          "Subtotal",
          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900,
        ))),
   


        
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
              DataCell(Text((e.valorUnit * e.quantidade).toStringAsFixed(2))),
            ]
          )
          );
    }
  });

  MaterialColor cor = enc.estado == "pendente" ? Colors.red : Colors.blue;
  


  return ExpansionTile(
    title: Padding(
      padding: EdgeInsets.only(top: 15, left: 16, right: 16),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.,
        children: <Widget>[
          Text(pos.toString(),
              style:
                  TextStyle(color: cor, fontWeight: FontWeight.bold)),
          Padding(
            padding: EdgeInsets.only(left: 55),
            child: Text(enc.encomenda_id,
                style: TextStyle(
                    color: cor,
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
                  style: TextStyle(color: cor, fontSize: 14)),
              Padding(
                padding: EdgeInsets.only(
                  left: 30,
                ),
                child: Text(double.parse(totalValor.toStringAsFixed(2)).toString() + "MTN",
                    style: TextStyle(color: cor, fontSize: 14)),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 30,
                ),
                child: Text(enc.cliente.cliente,
                    style: TextStyle(color: cor, fontSize: 14)),
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
    BuildContext context, Encomenda enc, List<EncomendaItem> itens, pos) {

  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.18,
    child: encomendaItem(context, enc, itens, pos),
   
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


  class Opcoes {
  static const String Sincronizar = 'sincronizar';

  static const List<String> escolha = <String>[
    Sincronizar,
  ];

}

