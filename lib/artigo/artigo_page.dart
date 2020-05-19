import 'package:flutter/material.dart';
import 'package:primobile/Database/Database.dart';
import 'artigo_modelo.dart';


    List<Artigo> artigos;
    List<Artigo> artigosDuplicado = new  List<Artigo> ();
    bool carregado = false;

class ArtigoPage extends StatefulWidget {
  ArtigoPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ArtigoPageState createState() => new _ArtigoPageState();
}

class _ArtigoPageState extends State<ArtigoPage> {

  TextEditingController editingController = TextEditingController();

  @override
  void initState()  {  
    super.initState();
    getArtigos().then((value) => setState(() {
       artigos = value;
       carregado = true;
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
        artigos.clear();
        artigos = dummyListData;
        carregado = true;
      });
      return;
    } else {
            setState(() {
        artigos.clear();
        artigos = dummySearchList;
                carregado = true;

      });

    } 
  }

  @override
  Widget build(BuildContext context)  {
     getArtigos().then((value) => setState(() {
      //  artigos = value;
       artigosDuplicado = value;
               carregado = true;

     }) );
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
            Expanded(child: listarArtigo()
                ),
          ],
        ),
      ),
  
    );
  }
}
        List<Widget> children;

Widget listarArtigo() {


        if (artigos == null || artigos.length <= 0) {

          if ( carregado == false ) {
            return Container(
              child: CircularProgressIndicator(),
            );
          }

      return Container(
              child: Center(
                child: CircularProgressIndicator()
              ));         
        } else {
 return Scrollbar(
   isAlwaysShown: true, 
    child: ListView.builder(
            itemCount: artigos.length,
            itemBuilder: (context, index) {
              Artigo artigo = artigos[index];
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
                    artigo.descricao,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
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
Future<List<Artigo>> getArtigos() async {
  List<Artigo>  res = await DBProvider.db.getTodosArtigos();

  return res;
}