import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:primobile/artigo/artigo_modelo.dart';
import 'package:primobile/artigo/artigo_selecionar_page.dart';
// import 'package:numberpicker/numberpicker.dart';
// import 'package:primobile/util.dart';

BuildContext contexto;

class EncomendaPage extends StatefulWidget {
  EncomendaPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EncomendaPageState createState() => new _EncomendaPageState();
}

class _EncomendaPageState extends State<EncomendaPage> {
  TextEditingController txtClienteController = TextEditingController();
  BuildContext context;
  var items = List<dynamic>();
  final encomendaItens = <dynamic>[
    // encomendaItemVazio(),
  ];

  double mercadServicValor = 0.0;
  double ivaTotal = 0.0;
  double subtotal = 0.0;
  double totalVenda = 0.0;

  double iva = 17.0;
  List<Artigo> artigos;
  @override
  void initState() {
    items.addAll(encomendaItens);

    super.initState();
  }

  void update() {
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    contexto = context;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: new Text("Encomenda"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.blue[400],
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.blue[900], // fromRGBO(7, 89, 250, 100)
                // gradient: LinearGradient(
                //     // begin: ``
                //     colors: [Colors.blueAccent, Colors.blueAccent]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    // color: Colors.red,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          totalVenda.toStringAsFixed(2).toString() + "\n",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 200,
                    // margin: EdgeInsets.only(top: 64),/s
                    padding: EdgeInsets.only(
                        top: 4, left: 16, right: 16, bottom: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            // blurRadius: 5
                          )
                        ]),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // espaco(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Mercad/Servico",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.blue[300]),
                            ),
                            Text(
                              mercadServicValor.toStringAsFixed(2).toString() +
                                  "\n",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        // espaco(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "IVA",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue[300],
                              ),
                            ),
                            Text(
                              ivaTotal.toStringAsFixed(2).toString() + "\n",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Subtotal",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.blue[300]),
                            ),
                            Text(
                              subtotal.toStringAsFixed(2).toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Spacer(),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 1.3) - 6,
                              height: 45,

                              // margin: EdgeInsets.only(top: 64),/s
                              padding: EdgeInsets.only(
                                  top: 4, left: 16, right: 16, bottom: 4),
                              decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.all(
                                  //   // Radius.circular(50)
                                  // ),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.blue),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue,
                                      // blurRadius: 5
                                    )
                                  ]),
                              child: TextField(
                                // enabled: false,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.person_outline,
                                      color: Colors.blue,
                                    ),
                                    hintText: 'Selecionar Cliente'),
                                onChanged: (value) {
                                  // filtroResultadoBusca( value );
                                },
                                onTap: () async {
                                  final result = Navigator.pushNamed(
                                      context, '/cliente_selecionar_lista');
                                  // print(result);
                                  result.then((obj) {
                                    txtClienteController.text = obj.toString();
                                  });
                                },

                                controller: txtClienteController,
                              ),
                            ),
                            //  Spacer(),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return items[index];
                  // ListTile(
                  //   title: Text('${items[index]}'),
                  // );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app, color: Colors.blue),
            title: Text('Sair'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, color: Colors.blue),
            title: Text('Adicionar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline, color: Colors.blue),
            title: Text('terminar'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() async {
      // Sair
      if (index == 0) {
        // Adicionar
      }
      if (index == 1) {
        final result = await Navigator.pushNamed(
            contexto, '/artigo_selecionar_lista',
            arguments: artigos);
        artigos = result;

        /** 
         * Se tiver artigos selecionados.
        *   limpar a lista artigos previamente selecionados
        **/
        if (result != null) {
          encomendaItens.clear();
          items.clear();
        }

        if (artigos != null) {
          // encomendaItens.clear();
          artigos.forEach((a) {
            mercadServicValor += a.preco * a.quantidade;
            subtotal += (a.preco * (iva / 100)) + a.preco;
            totalVenda += subtotal;
            ivaTotal += (a.preco * (iva / 100));
            encomendaItens.add(artigoEncomenda(a));
            // encomendaItens.elementAt(0)
          });
        }
        items.addAll(encomendaItens);
      }

      // Terminar
      if (index == 2) {
        Navigator.pushNamed(contexto, '/encomenda_sucesso');
      }
      _selectedIndex = index;
    });
  }

  ArtigoCard encomendaItem(Artigo artigo) {
    var artigo_quantidade;

    createAlertDialog(BuildContext context) {
      TextEditingController txtArtigoQtd = new TextEditingController();
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Quantidade'),
              content: TextField(
                controller: txtArtigoQtd,
              ),
              actions: <Widget>[
                MaterialButton(
                  elevation: 5.0,
                  child: Text('alterar'),
                  onPressed: () {
                    Navigator.of(context).pop(txtArtigoQtd.text.toString());
                  },
                )
              ],
            );
          });
    }

    return ArtigoCard  (
      artigo: artigo,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 4),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(artigo.artigo,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold)),
              Text(artigo.descricao,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold)),
              Text(artigo.unidade == null ? " " : artigo.unidade,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 4),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  artigo_quantidade = await createAlertDialog(contexto);
                  // print('quantidade');
                  // print(artigo_quantidade.toString());
                  // // print(artigo);
                  artigos[0].quantidade = int.parse(artigo_quantidade);
                  // artigos.forEach((a) {
                  //   if (a.artigo == artigo.artigo) {
                  //     artigo.quantidade = -22;
                  //     a.quantidade = -22;
                  //   }
                  // });
                  // artigos[0].quantidade = -223;
                  setState(() {
                    
                  });

                },
                child: Text(
                  "Qtd.: " + artigos[0].quantidade.toString(),
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Text("Prc.Unit: " + artigo.preco.toStringAsFixed(2).toString(),
                  style: TextStyle(color: Colors.blue)),
              Text(
                  "Subtotal: " +
                      (artigo.preco * artigo.quantidade).toStringAsFixed(2).toString(),
                  style: TextStyle(color: Colors.blue))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 4),
          ),
        ],
      ),
    );
  }

  Card encomendaItemVazio() {
    return Card(
        child: Column(
      children: <Widget>[
        const SizedBox(height: 50),
        RaisedButton(
          color: Colors.blue,
          onPressed: () async {
            // Navigator.pushNamed(contexto, '/artigo_selecionar_lista');
            final result =
                await Navigator.pushNamed(contexto, '/artigo_selecionar_lista');
            List<Artigo> artigos = result;
            artigos.forEach((a) {
              print('result form 2');
              print(a.descricao);
              // print(this.artigo.quantidade);
            });
          },
          child: const Text('Adicionar ',
              style: TextStyle(fontSize: 15, color: Colors.white)),
        ),
        const SizedBox(height: 50),
      ],
    ));
  }

  Slidable artigoEncomenda(Artigo artigo) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: encomendaItem(artigo),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Remover',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => null,
        ),
      ],
    );
  }
}

Padding espaco() {
  return Padding(
    padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 4),
  );
}

class ArtigoCard extends Card {
  ArtigoCard({
    Key key,
    this.color,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.child,
    this.semanticContainer = true,
    this.artigo
  }) : super(
    key :key,
    color : color,
    elevation : elevation,
    shape : shape,
    borderOnForeground : borderOnForeground,
    margin: margin,
    clipBehavior : clipBehavior
  );
  final Color color;
  final double elevation;
  final ShapeBorder shape;
  final Clip clipBehavior;
  final bool borderOnForeground;
  final EdgeInsetsGeometry margin;
  final Widget child;
  static const double _defaultElevation = 1.0;
  final bool semanticContainer;
  final Artigo artigo;
}
