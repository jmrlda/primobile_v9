// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/cliente/cliente_api_provider.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import '../util.dart';
import 'cliente_modelo.dart';

List<Cliente> clientes = new List<Cliente>();
List<Cliente> clientesDuplicado = new List<Cliente>();
Widget clienteAvatarMmini;
bool carregandoImagem = false;

class ClientePage extends StatefulWidget {
  ClientePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ClientePageState createState() => new _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  TextEditingController editingController = TextEditingController();
  var duplicateItems;
  var items = List<_ListaTile>();
  var cli = Future;
  String baseUrl = "", url = "";
  // Widget clienteAvatar;
  @override
  void initState() {
    super.initState();
    SessaoApiProvider.read().then((parsed) async {
      Map<String, dynamic> filial = parsed['resultado'];
      String protocolo = 'http://';
      String host = filial['empresa_filial']['ip'];
      String rota = '/api/ImagemUpload/cliente/';
      // var status = await getUrlStatus(url) ;
      setState(() {
        baseUrl = url = protocolo + host + rota;
      });
    });
    getClientes().then((value) {
      if (this.mounted == true) {
        setState(() {
          if (value != null && value.length > 0)
            clientes = clientesDuplicado = value;
          else
            clientes = null;
        });
      }
    });
  }

  void filterSearchResults(String query) {
    List<Cliente> dummySearchList = List<Cliente>();

    dummySearchList.addAll(clientesDuplicado);
    if (query.trim().isNotEmpty) {
      List<Cliente> dummyListData = List<Cliente>();
      dummySearchList.forEach((item) {
        if (item.nome.toLowerCase().contains(query.toString().toLowerCase()) ||
            item.cliente
                .toLowerCase()
                .contains(query.toString().toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        clientes.clear();
        clientes = dummyListData;
      });
      return;
    } else {
      setState(() {
        clientes.clear();
        clientes = dummySearchList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getClientes().then((value) => setState(() {
          clientesDuplicado = value;
        }));

    return new Scaffold(
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
            Expanded(child: listaCliente()),
          ],
        ),
      ),
    );
  }

  void opcaoAcao(String opcao) async {
    if (opcao == 'sincronizar') {
      setState(() {
        clientes.clear();
      });
      SincronizarModelo(context, "cliente").then((value) async {
        if (value) {
          clientes = await getClientes();
        }
      });
    }
  }

  Widget listaCliente() {
    Future<dynamic> clienteAvatarWidget(Cliente cliente, String base) {

      
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          Widget clienteAvatar =  CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: url,
            placeholder: (context, url) => Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 5),
                Center(child: Text('Carregando'))
              ],
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          );
          return AlertDialog(
            content: StatefulBuilder(
              // You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  // Then, the content of your dialog.
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                        child: Text(
                      cliente.nome,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    SizedBox(height: 5),
                    clienteAvatar,
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new IconButton(
                          icon: Icon(Icons.add_photo_alternate),
                          onPressed: () {
                            abrirGaleria().then((buffer) {
                              ClienteApiProvider clienteApi =
                                  new ClienteApiProvider();
                              try {
                                // Uint8List buffer= dataFromBase64String(va);
                                String filename = cliente.cliente + '.png';
                                setState(() => clienteAvatar = Column(
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 5),
                                        Center(
                                          child: Text('Aguarde'),
                                        )
                                      ],
                                    ));
                                clienteApi
                                    .postClienteImagem(
                                        cliente, filename, buffer)
                                    .then((value) {
                                  if (value.statusCode >= 200 &&
                                      value.statusCode < 300) {
                                    setState(() =>
                                        clienteAvatar =     CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: url,
                                          placeholder: (context, url) => Column(
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(height: 5),
                                              Center(child: Text('Carregando'))
                                            ],
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )
                                        );
                                  }
                                });
                              } catch (err) {
                                print('Ocorreu um erro:');
                                print(err);
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: new Icon(Icons.add_a_photo),
                          onPressed: () async {
                            openCamera("nome").then((buffer) async {
                              ClienteApiProvider clienteApi =
                                  new ClienteApiProvider();
                              try {
                                // Uint8List buffer= dataFromBase64String(va);
                                String filename = cliente.cliente + '.png';
                                setState(() => clienteAvatar = Column(
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 5),
                                        Center(
                                          child: Text('Aguarde'),
                                        )
                                      ],
                                    ));

                                setState(() => carregandoImagem = true);
                                clienteApi
                                    .postClienteImagem(
                                        cliente, filename, buffer)
                                    .then((value) {
                                  if (value.statusCode >= 200 &&
                                      value.statusCode < 300) {
                                    setState(() =>
                                        clienteAvatar = CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: url,
                                          placeholder: (context, url) => Column(
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(height: 5),
                                              Center(child: Text('Carregando'))
                                            ],
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )
                                        );
                                    setState(() => carregandoImagem = false);

                                    // Navigator.pushReplacementNamed(context, '/cliente_lista');

                                  }
                                });
                              } catch (err) {
                                print('Ocorreu um erro:');
                                print(err);
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: new Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    )
                  ],
                );
              },
            ),
            actions: [],
          );
        },
      );
    }
    if ( clientes != null && clientes.length <= 0) {
        getClientes().then((value) {
          if (this.mounted == true) {
            setState(() {
              if (value != null && value.length > 0)
                clientes = clientesDuplicado = value;
              else
                clientes = null;
            });
          }
        });
      }

    if (clientes == null) {
      return Container(
        child: Text(
          "Nenhum Cliente encontrado. Sincronize os Dados",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      );
    } else if (clientes.length <= 0) {
      return Column(
        children: [CircularProgressIndicator(), Text("Aguarde")],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    } else {
      return Scrollbar(
        isAlwaysShown: false,
        child: ListView.builder(
          itemCount: clientes.length,
          itemBuilder: (context, index) {
            Cliente cliente = clientes[index];
            url = baseUrl + cliente.cliente;
            clienteAvatarMmini = GestureDetector(
                child: ClipOval(
                    child:  CachedNetworkImage(
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                  imageUrl: url,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
                ),
                onTap: () async {
                  clienteAvatarWidget(cliente, baseUrl).then((value) {
                    // setState(() =>   clientes = clientesDuplicado);
                  });
                });
            return Container(
              child: _ListaTile(
                leading: carregandoImagem == false
                    ? clienteAvatarMmini
                    : CircularProgressIndicator() //Text(index.toString())

                ,
                title: Text(
                  cliente.nome,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  cliente.endereco.descricao +
                      ' - ' +
                      cliente.numContrib.toString().replaceAll(" ", "") +
                      ' - ' +
                      "Encomenda Pendente: " +
                      cliente.encomendaPendente.toStringAsFixed(2) +
                      ' - ' +
                      "Venda não Convertida: " +
                      cliente.vendaNaoConvertida.toStringAsFixed(2) +
                      ' - ' +
                      "Total Deb: " +
                      cliente.totalDeb.toStringAsFixed(2) +
                      ' - ' +
                      "Limite Credito: " +
                      cliente.limiteCredito.toStringAsFixed(2),
                  style: TextStyle(color: Colors.blueAccent, fontSize: 14),
                ),
                data: cliente,
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
  final dynamic data;

  dynamic getTitle() {
    return this.data;
  }

  bool contem(value) {
    return this.data.toLowerCase().contains(value.toString().toLowerCase());
  }
}

Future getClientes() async {
  return await DBProvider.db.getTodosClientes();
}

class Opcoes {
  static const String Sincronizar = 'sincronizar';

  static const List<String> escolha = <String>[
    Sincronizar,
  ];
}
