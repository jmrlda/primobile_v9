// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:primobile/util.dart';

import 'artigo_modelo.dart';

List<Artigo> artigoLista = new List<Artigo>();
List<Artigo> artigosDuplicado = new List<Artigo>();
String baseUrl = "";
String url = "";

// ignore: must_be_immutable
class ArtigoPage extends StatefulWidget {
  List<Artigo> artigos;

  ArtigoPage({Key key, this.artigos}) : super(key: key);
  // final String title;
  @override
  _ArtigoPageState createState() => new _ArtigoPageState();
}

class _ArtigoPageState extends State<ArtigoPage> {
  TextEditingController editingController = TextEditingController();

  List<Artigo> listaArtigoSelecionado = List<Artigo>();

  var duplicateItems;

  var items = List<_ListaTile>();

  @override
  void initState() {
    super.initState();

    SessaoApiProvider.read().then((parsed) async {
      Map<String, dynamic> filial = parsed['resultado'];
      String protocolo = 'http://';
      String host = filial['empresa_filial']['ip'];
      String rota = '/api/ImagemUpload/artigo/';
      // var status = await getUrlStatus(url) ;
            if (this.mounted == true) {

      setState(() {
        baseUrl = url = protocolo + host + rota;
      });
            }
    });
          if (this.mounted == true) {

    getArtigos().then((value) => setState(() {
          if (value != null && value.length > 0)
            artigosDuplicado = artigoLista = value;
          else
            artigoLista = null;
        }));
          }
  }

  // metodo para busca de artigos na lista
  void filterSearchResults(String query) {
    List<Artigo> dummySearchList = List<Artigo>();

    dummySearchList.addAll(artigosDuplicado);
    if (query.trim().isNotEmpty) {
      List<Artigo> dummyListData = List<Artigo>();
      dummySearchList.forEach((item) {
        if (item.descricao
                .toLowerCase()
                .contains(query.toString().toLowerCase()) ||
            item.artigo
                .toLowerCase()
                .contains(query.toString().toLowerCase())) {
          dummyListData.add(item);
        }
      });
            if (this.mounted == true) {

      setState(() {
        artigoLista.clear();
        artigoLista = dummyListData;
      });
            }
      return;
    } else {
            if (this.mounted == true) {

      setState(() {
        artigoLista.clear();
        artigoLista = dummySearchList;
      });
            }
    }
  }

  var color = Colors.white;

  @override
  Widget build(BuildContext context) {
    getArtigos().then((value) {
      if (this.mounted == true) {
        setState(() {
          artigosDuplicado = value;
        });
      }
    });

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        actions: [
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
    );
  }

  Widget listaArtigo() {
    if (artigoLista != null && artigoLista.length <= 0) {

      getArtigos().then((value) {
            if (this.mounted == true) {

       setState(() {
            if (value != null && value.length > 0)
              artigosDuplicado = artigoLista = value;
            else
              artigoLista = null;
            });
            
            }});
    }
    if (artigoLista == null) {
      return Container(
        child: Text(
          "Nenhum Artigo encontrado. Sincronize os Dados",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      );
    } else if (artigoLista.length <= 0) {
      return Column(
        children: [CircularProgressIndicator(), Text("Aguarde")],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    } else {
      return Scrollbar(
        isAlwaysShown: false,
        child: ListView.builder(
          itemCount: artigoLista.length,
          itemBuilder: (context, index) {
            Artigo artigo = artigoLista[index];
            url = baseUrl + artigo.artigo;

            return new Container(
              child: _ListaTile(
                leading: GestureDetector(
                    child: ClipOval(child: networkIconImage(url)),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(child: Text(artigo.descricao)),
                            // memory(artigos[index].imagemBuffer as Uint8List, width: 350, height: 250)
                            content: 
                            CachedNetworkImage(
                              imageUrl: baseUrl + artigo.artigo,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),

                            actions: <Widget>[
                              IconButton(
                                icon: new Icon(Icons.close),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            ],
                          );
                        },
                      );
                    }),
                title: Text(
                  artigo.descricao,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                subtitle: Text(
                  "Cod: " +
                      artigo.artigo +
                      ' ' +
                      "Un: " +
                      artigo.unidade +
                      ', ' +
                      "PVP: " +
                      artigo.preco.toString() +
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

  void opcaoAcao(String opcao) async {
    if (opcao == 'sincronizar') {
      if (artigoLista != null && artigoLista.length > 0) {
        setState(() {
          artigoLista.clear();
        });
      }
      SincronizarModelo(context, "artigo").then((value) async {
        if (value) {
          artigoLista = await getArtigos();
        }
      });
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
  List<Artigo> res;
  try {
    res = await DBProvider.db.getTodosArtigos();
  } catch (err) {
    res = null;
  }

  return res;
}

class Opcoes {
  static const String Sincronizar = 'sincronizar';

  static const List<String> escolha = <String>[
    Sincronizar,
  ];
}

Widget networkIconImage(url) {
  // Widget rv;
  // try {
  //   rv = CachedNetworkImage(
  //     width: 45,
  //     height: 45,
  //     fit: BoxFit.cover,
  //     imageUrl: url,
  //     placeholder: (context, url) => CircularProgressIndicator(),
  //     errorWidget: (context, url, error) => Icon(Icons.error),
      
  //   );
  // } catch (err) {
  //   rv = Icon(Icons.error);
  // }

  return Icon(Icons.error);
}
