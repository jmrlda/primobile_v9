import 'package:flutter/material.dart';
import 'package:primobile/Database/Database.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'artigo_modelo.dart';


 List<Artigo> artigoLista = new  List<Artigo> ();
    List<Artigo> artigosDuplicado = new  List<Artigo> ();


class ArtigoSelecionarPage extends StatefulWidget {
 List<Artigo> artigos;

  ArtigoSelecionarPage({Key key, this.artigos}) : super(key: key);
  // final String title;
  @override
  _ArtigoSelecionarPageState createState() => new _ArtigoSelecionarPageState();
}

class _ArtigoSelecionarPageState extends State<ArtigoSelecionarPage> {
  TextEditingController editingController = TextEditingController();

  List<Artigo> listaArtigoSelecionado = List<Artigo>();

  var duplicateItems;

  var items = List<_ListaTile>();

  @override
  void initState() {
    super.initState();
       getArtigos().then((value) => setState(() {
       artigoLista = value;
     }) );

  }

  void filterSearchResults(String query) {
     List<Artigo> dummySearchList = List<Artigo>();

    dummySearchList.addAll(artigosDuplicado);
    if (query.trim().isNotEmpty) {
      List<Artigo> dummyListData = List<Artigo>();
      dummySearchList.forEach((item) {
        if (item.descricao.toLowerCase().contains(query.toString())
        ||  item.artigo.toLowerCase().contains(query.toString())
        ) {
          dummyListData.add(item);
        }
      });
      setState(() {
        artigoLista.clear();
        artigoLista = dummyListData;
      });
      return;
    } else {
            setState(() {
        artigoLista.clear();
        artigoLista = dummySearchList;
      });

    } 
  }

  bool isSelected = false;
  var color = Colors.white;

  // ao selecionar um artigo, adionar a lista
  // de artigos selecionados, se o artigo ja tivesse
  // sido selecionado remover da lista.
  bool adicionarArtigo(Artigo a) {
    bool existe = false;


    setState(() { 
      for (var i = 0; i < listaArtigoSelecionado.length; i++) {
      if (listaArtigoSelecionado[i].artigo == a.artigo) {
        existe = true;
        listaArtigoSelecionado.removeAt(i);


      }
    }

    if (! existe) {
      listaArtigoSelecionado.add(a);
    }
    });

    return existe;
  }

  bool existeArtigo(Artigo a) {
    bool existe = false;

    for (var i = 0; i < listaArtigoSelecionado.length; i++) {
      if (listaArtigoSelecionado[i].artigo == a.artigo) {
        existe = true;
      }
    }
    return existe;
  }

  @override
  Widget build(BuildContext context) {
        widget.artigos = ModalRoute.of(context).settings.arguments;
    if (widget.artigos !=  null) {
      listaArtigoSelecionado = widget.artigos;
    }

       getArtigos().then((value) => setState(() {
       artigosDuplicado = value;
     }) );
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: new Text("Artigos"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(listaArtigoSelecionado),
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
            Expanded(child: listaArtigo()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          Navigator.pop(context, listaArtigoSelecionado);
        },
      ),
    );
  }

  Widget listaArtigo() {

    
        if (artigoLista == null || artigoLista.length <= 0) {
      return Container(
              child: _ListaTile(
                title: Align (
                  alignment: Alignment.topCenter,

                  child: Text(
                  "Artigo não encontrado",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      ),
                ),
                )

                
    
              ),
            );          
        } else {
       return  Scrollbar(
                isAlwaysShown: true,
                child: ListView.builder(
            itemCount: artigoLista.length,
              itemBuilder: (context, index) {
              Artigo artigo = artigoLista[index];

                return new Container(
                  color: existeArtigo(artigo) == false ? Colors.white : Colors.red,
                  child: _ListaTile(
                    selected: isSelected,
                    onTap:  () {
                      adicionarArtigo(artigo);
                    },
                    leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.local_offer,
                      color: Colors.white,
                    ),
                  ),
                      title: Text(
                    artigo.descricao,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    "Cod: " + artigo.artigo +
                        ' ' +
                       "Un: " + artigo.unidade +
                        ', ' +
                        "PVP: " + artigo.preco.toString() +
                        ' MT',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                    data: artigo.descricao,
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
  final String data;

  String getTitle() {
    return this.data;
  }

  bool contem(value) {
    return this.data.toLowerCase().contains(value.toString().toLowerCase());
  }
}

Future<List<Artigo>> getArtigos() async {
  List<Artigo>  res = await DBProvider.db.getTodosArtigos();

  return res;
}