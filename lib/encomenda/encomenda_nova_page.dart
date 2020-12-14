import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:primobile/artigo/artigo_modelo.dart';
import 'package:primobile/encomenda/encomenda_lista_page.dart';
import 'package:primobile/encomenda/encomenda_modelo.dart';
import 'package:primobile/encomenda/encomenda_api_provider.dart';
// import 'package:primobile/artigo/artigo_api_provider.dart';

// import 'package:numberpicker/numberpicker.dart';
// import 'package:primobile/util.dart';
import 'package:primobile/cliente/cliente_modelo.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:primobile/usuario/usuario_modelo.dart';

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
  final List<dynamic> encomendaItens = <dynamic>[
    // encomendaItemVazio(),
  ];

  double mercadServicValor = 0.0;
  double noIva = 0.0;
  double ivaTotal = 0.0;
  double subtotal = 0.0;
  double totalVenda = 0.0;
  Cliente cliente = Cliente();
  double iva = 17.0;
  List<Artigo> artigos;
  List artigo_json = List();
  @override
  void initState() {
    // encomendaItens.add(encomendaItemVazio());
    items.addAll(encomendaItens);

    super.initState();
  }

  void update(cb) {
    setState(() {
      cb();
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
              height: 285,
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
                    margin: EdgeInsets.only(top: 2, bottom: 0),
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
                    width: MediaQuery.of(context).size.width - 30,
                    height: 200,
                    padding: EdgeInsets.only(
                        top: 5, left: 16, right: 16, bottom: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
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
                              "Mercadoria/Serviço",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.blue),
                            ),
                            Text(
                              mercadServicValor.toStringAsFixed(2).toString() +
                                  "\n",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
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
                                color: Colors.blue,
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
                              "Total",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.blue),
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
                              width: (MediaQuery.of(context).size.width - 62),
                              height: 60,

                              // margin: EdgeInsets.only(top: 64),/s
                              padding: EdgeInsets.only(
                                  top: 4, left: 6, right: 16, bottom: 4),
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
                                    this.cliente = obj;
                                    if ((this.cliente.anulado == false &&
                                            this.cliente.limiteCredito == 0) ||
                                        this.cliente.anulado == false &&
                                            this.cliente.totalDeb <
                                                this.cliente.limiteCredito) {
                                      txtClienteController.text =
                                          this.cliente.nome;
                                    } else {
                                      String msg = "";
                                       if (this.cliente.anulado == true) {
                                                  msg = "Cliente anulado. Entre em contacto com o Administrador";

                                       } else  if (this.cliente.totalDeb  >
                                                this.cliente.limiteCredito) {
                                                  msg = "Cliente excedeu o limite de Credito de " + this.cliente.limiteCredito.toString() +" MTN. Entre em contacto com o Administrador";
                                                }

                                       showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("atenção"),
                              content: Text(
                                  msg),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text("ok"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                                    }
                                  });
                                },

                                controller: txtClienteController,
                                readOnly: true,
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

  void _onItemTapped(int index) {
    setState(() async {
      // Sair
      if (index == 0) {
        Navigator.of(context).pop();
      }
      if (index == 1) {
        final result = await Navigator.pushNamed(
            contexto, '/artigo_selecionar_lista',
            arguments: artigos);
        if (result != null) {
          artigos = result;
        }

        refresh2();

        // Terminar
      }
      if (index == 2) {
        createAlertDialog(BuildContext context) {
          TextEditingController txtArtigoQtd = new TextEditingController();

          return showDialog(
              context: contexto,
              builder: (contexto) {
                return AlertDialog(
                  title: Text('Aguarde'),
                  content: Container(
                      width: 50,
                      height: 50,
                      child: Center(child: CircularProgressIndicator())),
                );
              });
        }

        createAlertDialog(contexto);

        if (artigos.length > 0) {
          EncomendaApiProvider encomendaApi = EncomendaApiProvider();
          Map<String, dynamic> rv = await SessaoApiProvider.read();
          Map<String, dynamic> _usuario = rv['resultado'];

          Usuario usuario = Usuario(
              usuario: _usuario['usuario'],
              nome: _usuario['nome'],
              perfil: _usuario['perfil'],
              documento: _usuario['documento']);
          Encomenda encomenda = new Encomenda(
              cliente: this.cliente,
              vendedor: usuario,
              artigos: artigos,
              dataHora: DateTime.now(),
              estado: "pendente",
              valorTotal: totalVenda,
              encomenda_id: usuario.usuario +
                  DateTime.now().day.toString() +
                  DateTime.now().month.toString() +
                  "/" +
                  DateTime.now().hour.toString() +
                  "/" +
                  DateTime.now().minute.toString() +
                  "/" +
                  DateTime.now().second.toString());

          try {
            await encomendaApi.insertEncomenda(encomenda);
            await encomendaApi.postEncomenda(encomenda);
          } catch (e) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("atenção"),
                  content: Text("Ocorreu um erro. " + e.toString()),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Fechar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }

          Navigator.pushNamed(contexto, '/encomenda_sucesso');
          // limpar a lista de itens apos envio ou salvo na baese de dados;
          items.clear();
          encomendaItens.clear();
          artigos.clear();
          txtClienteController.clear();
          mercadServicValor = 0;
          subtotal = 0;
          totalVenda = 0;
          ivaTotal = 0;
          noIva = 0;
        } else {
          print('selecionar minimo 1 artigo');
        }
      }
      _selectedIndex = index;
    });
  }

  ArtigoCard encomendaItem(Artigo artigo) {
    var artigoQuantidade;

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

    return ArtigoCard(
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
                  artigoQuantidade = await createAlertDialog(contexto);
                  // print('quantidade');
                  // print(artigoQuantidade.toString());
                  // // print(artigo);
                  artigo.quantidade = double.parse(artigoQuantidade);
                  // artigos.forEach((a) {
                  //   if (a.artigo == artigo.artigo) {
                  //     artigo.quantidade = -22;
                  //     a.quantidade = -22;
                  //   }
                  // });
                  // artigos[0].quantidade = -223;

                  setState(() {
                    // calcular o custo da encomenda que pode ter preco
                    // ja incluido iva ou nao.
                    // Verificar o caso e calcular o custo total.

                    // refresh();
                    refresh2();
                    // if (artigos != null) {
                    //   ivaTotal =
                    //       totalVenda = subtotal = mercadServicValor = 0.0;

                    //   artigos.forEach((a) {
                    //     mercadServicValor += a.preco * a.quantidade;
                    //     subtotal += ((a.preco * a.quantidade) * (iva / 100)) +
                    //         (a.preco * a.quantidade);
                    //     totalVenda += subtotal;
                    //     ivaTotal += ((a.preco * a.quantidade) * (iva / 100));
                    //     encomendaItens.add(artigoEncomenda(a));
                    //     // encomendaItens.elementAt(0)
                    //   });
                    // }
                  });
                },
                child: Text(
                  "Qtd.: " + artigo.quantidade.toString(),
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Text("Prc.Unit: " + artigo.preco.toStringAsFixed(2).toString(),
                  style: TextStyle(color: Colors.blue)),
              Text(
                  "Subtotal: " +
                      (artigo.preco * artigo.quantidade)
                          .toStringAsFixed(2)
                          .toString(),
                  style: TextStyle(color: Colors.blue))
              // Text(
              //     "Subtotal: " +
              //         ( (artigo.pvp1 / ((iva + 100) / 100) ) * artigo.quantidade)
              //             .toStringAsFixed(2)
              //             .toString(),
              //     style: TextStyle(color: Colors.blue))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 4),
          ),
        ],
      ),
    );
  }

  void refresh2() {
    /** 
         * Se tiver artigos selecionados.
        *   limpar a lista artigos previamente selecionados
        **/

    encomendaItens.clear();
    items.clear();

    if (artigos != null) {
      // encomendaItens.clear();
      ivaTotal = totalVenda = subtotal = mercadServicValor = 0.0;
      encomendaItens.clear();

      artigos.forEach((a) {
        if (a.pvp1Iva == true) {
          noIva = (a.pvp1 / ((iva + 100) / 100)) * a.quantidade;
          mercadServicValor += (a.pvp1 / ((iva + 100) / 100)) * a.quantidade;

          subtotal += a.pvp1 * a.quantidade;
          totalVenda = subtotal;
          ivaTotal = mercadServicValor * (iva / 100);
          encomendaItens.add(artigoEncomenda(a));
        } else {
          mercadServicValor += (a.pvp1 / ((iva + 100) / 100)) * a.quantidade;

          subtotal += (a.pvp1 / ((iva + 100) / 100)) * a.quantidade;
          totalVenda += subtotal;
          ivaTotal += mercadServicValor * (iva / 100);
          encomendaItens.add(artigoEncomenda(a));
        }
        // encomendaItens.elementAt(0)
      });
    }
    setState(() {
      items.addAll(encomendaItens);
    });
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
            await Navigator.pushNamed(contexto, '/artigo_selecionar_lista');
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
          onTap: () => {
            setState(() => {
                  removeEncomenda(artigo),
                  refresh2(),
                }),
          },
        ),
      ],
    );
  }

  void removeEncomenda(Artigo a) {
    for (var i = 0; i < encomendaItens.length; i++) {
      if (encomendaItens[i].child.artigo.artigo == a.artigo) {
        encomendaItens.removeAt(i);
        artigos.removeAt(i);
      }
    }
  }
}

Padding espaco() {
  return Padding(
    padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 4),
  );
}

class ArtigoCard extends Card {
  ArtigoCard(
      {Key key,
      this.color,
      this.elevation,
      this.shape,
      this.borderOnForeground = true,
      this.margin,
      this.clipBehavior,
      this.child,
      this.semanticContainer = true,
      this.artigo})
      : super(
          key: key,
          color: color,
          elevation: elevation,
          shape: shape,
          borderOnForeground: borderOnForeground,
          margin: margin,
          clipBehavior: clipBehavior,
        );
  final Color color;
  final double elevation;
  final ShapeBorder shape;
  final Clip clipBehavior;
  final bool borderOnForeground;
  final EdgeInsetsGeometry margin;
  final Widget child;
  final bool semanticContainer;
  final Artigo artigo;
}
