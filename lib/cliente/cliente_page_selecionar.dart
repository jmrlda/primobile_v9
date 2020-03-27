import 'package:flutter/material.dart';
import 'package:primobile/Database/Database.dart';
import 'cliente_modelo.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';


class ClienteSelecionarPage extends StatefulWidget {
  ClienteSelecionarPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ClienteSelecionarPageState createState() => new _ClienteSelecionarPageState();
}

class _ClienteSelecionarPageState extends State<ClienteSelecionarPage> {

  TextEditingController editingController = TextEditingController();
  var duplicateItems;
  var items = List<_ListaTile>();

  @override
  void initState() {
    super.initState();
  }

  void filterSearchResults(String query) {
    List<_ListaTile> dummySearchList = List<_ListaTile>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<_ListaTile> dummyListData = List<_ListaTile>();
      dummySearchList.forEach((item) {
        if (item.contem(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
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
                  BoxDecoration(color: Color.fromRGBO(241, 249, 255, 100)
                      ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 45,
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
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
            Expanded(child: listaCliente()
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.sync),
        onPressed: () async {
        },
      ),
    );
  }
}

Widget listaCliente() {
  return FutureBuilder(
    future: teste(),
    builder: (context, snap) {
      if ((snap.connectionState == ConnectionState.none &&
              snap.hasData == null) ||
          snap.connectionState == ConnectionState.waiting) {
        return ListView(
          children: <Widget>[
            SizedBox(
               
              child: Loading(
                    indicator: BallPulseIndicator(), color: Colors.blueAccent, size: 10.0,),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 36),
              child: Center(child: Text('Aguardando resultado...'),),
            )
          ],
        );
      } else if (snap.connectionState == ConnectionState.done) {
        if (snap.hasError) {
          return Text('Erro: ${snap.error}');
        }
        return ListView.builder(
          itemCount: snap.data.length,
          itemBuilder: (context, index) {
            Cliente cliente = snap.data[index];
            return Container(
              child: _ListaTile(
              onTap: () {
                Navigator.pop(context, cliente);
              },
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
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  cliente.endereco.descricao +
                      ' - ' +
                      cliente.numContrib.toString() 
                      ,
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                ),
                data: cliente,
              ),
            );
          },
        );
      }
      return Text('Ocorreu um erro desconhecido: ${snap.error}');
    },
  );
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

Future teste() async {
  var res = await DBProvider.db.getTodosClientes();

  return res;
}
