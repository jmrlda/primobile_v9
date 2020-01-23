import 'package:flutter/material.dart';
import 'package:primobile/Database/Database.dart';

import 'artigo_modelo.dart';

class ArtigoSelecionarPage extends StatefulWidget {
  ArtigoSelecionarPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ArtigoSelecionarPageState createState() => new _ArtigoSelecionarPageState();
}

class _ArtigoSelecionarPageState extends State<ArtigoSelecionarPage> {
  TextEditingController editingController = TextEditingController();

  // final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  static List<Artigo> testArtigos = [
    Artigo(artigo: '0001', descricao: 'Garrafa Whisky 1l', quantidade: 3, preco: 100.0, iva: 17.0, civa: 0, unidade: "kg"),
    Artigo(artigo: '00251', descricao: 'Nutro Bacon Superior Nacos Kg', quantidade: 3, preco: 300.0, iva: 17.0, civa: 0, unidade: "kg"),
    Artigo(artigo: '00252', descricao: 'Nutro Bacon Extra (1/2) Kg', quantidade: 3, preco: 400.0, iva: 17.0, civa: 0, unidade: "kg"),
    Artigo(artigo: '00253', descricao: 'Nutro Cabeca Fumada Kg', quantidade: 3, preco: 520.10, iva: 17.0, civa: 0, unidade: "kg"),
    Artigo(artigo: '00939', descricao: 'Espina Fiambre de Peito de Peru Cozido Kg', quantidade: 3, preco: 210.0, iva: 17.0, civa: 0, unidade: "kg"),
  ];

  List<Artigo> listaArtigoSelecionado = List<Artigo>();
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
            Expanded(
              child: listaArtigo()
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
        child: Icon(Icons.save),
        onPressed: () async {

          // testArtigos.forEach((artigo) async {
          //   print(artigo.artigo);
          //   await DBProvider.db.novoArtigo(artigo);
          //   setState(() {

          //   });
          // });

          // List<Artigo> artigos = await DBProvider.db.getTodosArtigos();
          // duplicateItems = artigos;
          // print('size');
          // print(artigos.length);
          Navigator.pop(context, listaArtigoSelecionado);


        },
      ),
    );
  }

  
Widget listaArtigo() {
  return FutureBuilder(
    future: teste(),
    builder: (context, snap) {
      if (snap.connectionState == ConnectionState.none &&
          snap.hasData == null) {
        return Container();
      }
      return ListView.builder(
        
        itemCount: snap.data.length,
        itemBuilder: (context, index) {
          Artigo artigo = snap.data[index];
          // artigo.fetchArtigos();
          return Container(
            child: _ListaTile(

              onTap: () {
                // Navigator.pop(context, 'Yep!');
                listaArtigoSelecionado.add(artigo);

                print('itens');

                listaArtigoSelecionado.forEach((item) {
                  print (item.descricao);
                });
                

              },
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
                artigo.artigo +  ' ' +  artigo.unidade + ', ' + artigo.preco.toString() + ' MT',
                style: TextStyle(color: Colors.blueAccent, fontSize: 16),
              ),
              data: artigo.descricao,
            ),
          );
          
        },
        
      );
    },
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
    var res =  await DBProvider.db.getTodosArtigos();

    return res;
    // duplicateItems = List<_ListaTile>.generate(testArtigos.length, (i) {
    //   return _ListaTile(
    //     leading: CircleAvatar(
    //       backgroundColor: Colors.blue,
    //       // radius: 50.0,
    //       child: Icon(
    //         Icons.local_offer,
    //         color: Colors.white,
    //         // size: 50.0,
    //       ),
    //     ),
    //     title: Text(
    //       testArtigos[i].descricao,
    //       style: TextStyle(
    //           color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
    //     ),
    //     subtitle: Text(
    //       testArtigos[i].artigo +
    //           ' UN, ' +
    //           testArtigos[i].preco.toString() +
    //           ' meticais',
    //       style: TextStyle(color: Colors.blueAccent, fontSize: 16),
    //     ),
    //     data: testArtigos[i].descricao,
    //   );
    // });
  }