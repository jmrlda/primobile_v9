import 'package:flutter/material.dart';
import 'package:primobile/Database/Database.dart';
import 'artigo_modelo.dart';

class ArtigoPage extends StatefulWidget {
  ArtigoPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ArtigoPageState createState() => new _ArtigoPageState();
}

class _ArtigoPageState extends State<ArtigoPage> {
  TextEditingController editingController = TextEditingController();

  // final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  static List<Artigo> testArtigos = [];

  // List<Artigo> getArtigo() async {
  //   Lis
  // }
  var duplicateItems;

  var items = List<_ListaTile>();

  @override
  void initState() {
    // items.addAll(duplicateItems);
    // print(Artigo().fetchArtigos());
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
        title: new Text("Artigos"),
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
                      // gradient: LinearGradient(
                      //     // begin: ``
                      //     colors: [Colors.blueAccent, Colors.blueAccent]),
                      ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 45,
                    // margin: EdgeInsets.only(top: 64),/s
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        // borderRadius: BorderRadius.all(
                        //   // Radius.circular(50)
                        // ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            // blurRadius: 5
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
            Expanded(child: listaArtigo()
                // ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: items.length,
                //   itemBuilder: (context, index) {
                //     return items[index];
                //     // ListTile(
                //     //   title: Text('${items[index]}'),
                //     // );
                //   },
                // ),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.sync),
        onPressed: () async {
          // testArtigos.forEach((artigo) async {
          //   print(artigo.artigo);
          //   await DBProvider.db.novoArtigo(artigo);
          //   setState(() {

          //   });
          // });
          // getTodosArtigos('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlMTQ1OWRmN2M4ZmFhMDU1Y2U1NTJhNCIsInBlcmZpbCI6ImFkbWluIiwiZG9jdW1lbnRvIjoidmQyIiwiaWF0IjoxNTc4NDcyMTk1LCJleHAiOjE1Nzg0NzI0OTV9.UfjxlYt9sL8XjUWVgtbaxdkfl93L8xo6KlL1saLYMQA');
          // List<Artigo> artigos = await DBProvider.db.getTodosArtigos();
          // duplicateItems = artigos;
          // print('size');
          // print(artigos.length);
        },
      ),
    );
  }
}

Widget listaArtigo() {
  return FutureBuilder(
    future: teste(),
    builder: (context, snap) {
      if ((snap.connectionState == ConnectionState.none &&
              snap.hasData == null) ||
          snap.connectionState == ConnectionState.waiting) {
        return Container(
          child: CircularProgressIndicator(),
        );
      } else if (snap.connectionState == ConnectionState.done) {
        if (snap.hasError) {
          return Text('Erro: ${snap.error}');
        }
        return ListView.builder(
          itemCount: snap.data.length,
          itemBuilder: (context, index) {
            Artigo artigo = snap.data[index];
            // artigo.fetchArtigos();
            return Container(
              child: _ListaTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  // radius: 50.0,
                  child: Icon(
                    Icons.local_offer,
                    color: Colors.white,
                    // size: 50.0,
                  ),
                ),
                title: Text(
                  artigo.descricao,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  artigo.artigo +
                      ' ' +
                      artigo.unidade +
                      ', ' +
                      artigo.preco.toString() +
                      ' MT',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                ),
                data: artigo.descricao,
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
