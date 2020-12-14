// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';

import 'artigo_modelo.dart';

List<Artigo> artigoLista = new List<Artigo>();
List<Artigo> artigosDuplicado = new List<Artigo>();
String baseUrl = "";
String url = "";

// ignore: must_be_immutable
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

    getArtigos().then((value) {
      if (this.mounted == true) {
        setState(() {
          if (value != null && value.length > 0)
            artigosDuplicado = artigoLista = value;
          else
            artigoLista = null;
        });
      }
    });
  }

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
      if (this.mounted == true)
        setState(() {
          artigoLista.clear();
          artigoLista = dummyListData;
        });
      return;
    } else {
      if (this.mounted == true)
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
    if (this.mounted == true)
      setState(() {
        for (var i = 0; i < listaArtigoSelecionado.length; i++) {
          if (listaArtigoSelecionado[i].artigo == a.artigo) {
            existe = true;
            listaArtigoSelecionado.removeAt(i);
          }
        }

        if (!existe) {
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
    SessaoApiProvider.read().then((parsed) async {
      Map<String, dynamic> filial = parsed['resultado'];
      String protocolo = 'http://';
      String host = filial['empresa_filial']['ip'];
      String rota = '/api/ImagemUpload/artigo/';
      // var status = await getUrlStatus(url) ;
      if (this.mounted == true)
        setState(() {
          baseUrl = url = protocolo + host + rota;
        });
    });

    getArtigos().then((value) {
      if (this.mounted == true)
        setState(() {
          artigosDuplicado = value;
        });
    });
    widget.artigos = ModalRoute.of(context).settings.arguments;
    if (widget.artigos != null) {
      listaArtigoSelecionado = widget.artigos;
    }

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
    TextEditingController txtArtigoQtd = new TextEditingController();

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
              color: existeArtigo(artigo) == false ? Colors.white : Colors.red,
              child: _ListaTile(
                selected: isSelected,
                onTap: () async {
                  if (existeArtigo(artigo) == false) {
                    try {
                      txtArtigoQtd.text =
                          artigo.quantidade.toStringAsFixed(2).toString();

                      // double qtd = await showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AlertDialog(
                      //         title: Column(
                      //           children: [
                      //             Center(
                      //                 child: Text(artigo.descricao,
                      //                     style: TextStyle(fontSize: 12))),
                      //             Center(
                      //                 child: Text(
                      //                     'Total Disponivel ' +
                      //                         artigo.quantidadeStock
                      //                             .toString() +
                      //                         ' ' +
                      //                         artigo.unidade,
                      //                     style: TextStyle(fontSize: 12))),
                      //             Center(
                      //                 child: Text(
                      //                     'Quantidade em ' + artigo.unidade))
                      //           ],
                      //         ),
                      //         content: TextField(
                      //           keyboardType: TextInputType.number,
                      //           controller: txtArtigoQtd,
                      //         ),
                      //         actions: <Widget>[
                      //           Text(msg_qtd,
                      //               style: TextStyle(
                      //                   fontSize: 11, color: Colors.red)),
                      //           MaterialButton(
                      //             elevation: 5.0,
                      //             child: Text('Alterar'),
                      //             onPressed: () {
                      //               if (double.parse(txtArtigoQtd.text) <=
                      //                       artigo.quantidadeStock &&
                      //                   double.parse(txtArtigoQtd.text) > 0) {
                      //                 Navigator.of(context).pop(double.parse(
                      //                     txtArtigoQtd.text.toString()));
                      //               }
                      //             },
                      //           )
                      //         ],
                      //       );
                      //     });

                      double qtd = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String msgQtd = '';
                          return AlertDialog(
                            content: StatefulBuilder(
                                // You need this, notice the parameters below:
                                builder: (BuildContext context,
                                    StateSetter setState) {
                              return Column(
                                // Then, the content of your dialog.
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                      child: Text(artigo.descricao,
                                          style: TextStyle(fontSize: 12))),
                                  Center(
                                      child: Text(
                                          'Total Disponivel ' +
                                              artigo.quantidadeStock
                                                  .toString() +
                                              ' ' +
                                              artigo.unidade,
                                          style: TextStyle(fontSize: 14))),
                                  Center(
                                      child: Text(
                                          'Quantidade em ' + artigo.unidade)),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    controller: txtArtigoQtd,
                                    autofocus: true,
                                    onTap: () => txtArtigoQtd.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset:
                                                txtArtigoQtd.value.text.length),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(msgQtd,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                      alignment: Alignment.bottomRight,
                                      child: MaterialButton(
                                        elevation: 5.0,
                                        child: Text('Alterar'),
                                        onPressed: () {
                                          if (this.mounted == true) {
                                            try {
                                              if (double.parse(
                                                          txtArtigoQtd.text) <=
                                                      artigo.quantidadeStock &&
                                                  double.parse(
                                                          txtArtigoQtd.text) >
                                                      0) {
                                                Navigator.of(context).pop(
                                                    double.parse(txtArtigoQtd
                                                        .text
                                                        .toString()));
                                              } else {
                                                if (double.parse(
                                                        txtArtigoQtd.text) >
                                                    artigo.quantidadeStock) {
                                                  if (this.mounted == true) {
                                                    setState(() {
                                                      msgQtd = 'Quantidade ' +
                                                          txtArtigoQtd.text +
                                                          ' ' +
                                                          artigo.unidade +
                                                          ' maior que o Stock disponivel ';
                                                    });
                                                  }
                                                } else if (double.parse(
                                                        txtArtigoQtd.text) <=
                                                    0) {
                                                  if (this.mounted == true) {
                                                    setState(() {
                                                      msgQtd =
                                                          'Valido somente valores numericos positivos ';
                                                    });
                                                  }
                                                }
                                              }
                                            } catch (err) {
                                              if (this.mounted == true) {
                                                setState(() {
                                                  msgQtd =
                                                      'Valido somente valores numericos e positivos ';
                                                });
                                              }
                                            }
                                          }
                                        },
                                      ))
                                ],
                              );
                            }),
                            actions: null,
                          );
                        },
                      );
                      if (qtd != null) {
                        artigo.quantidade = qtd;
                        adicionarArtigo(artigo);
                      } else {
                        artigo.quantidade = 1.0;
                      }
                    } catch (err) {
                      artigo.quantidade = 1.0;
                    }
                  }
                },
                leading: ClipOval(
                  child: Icon(Icons.error),
                  //  CachedNetworkImage(
                  //   width: 45,
                  //   height: 45,
                  //   fit: BoxFit.cover,
                  //   imageUrl: url,
                  //   placeholder: (context, url) => CircularProgressIndicator(),
                  //   errorWidget: (context, url, error) => Icon(Icons.error),
                  // ),
                ),
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

// Future<List<Artigo>> getArtigos() async {
//   List<Artigo> res = await DBProvider.db.getTodosArtigos();

//   return res;
// }


Future<List<Artigo>> getArtigos() async {
  List<Artigo> res;
  try {
    res = await DBProvider.db.getTodosArtigos();
  } catch (err) {
    res = null;
  }

  return res;
}
