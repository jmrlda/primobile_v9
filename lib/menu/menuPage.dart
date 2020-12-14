import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:primobile/artigo/artigo_api_provider.dart';
import 'package:primobile/cliente/cliente_api_provider.dart';
import 'package:primobile/encomenda/encomenda_api_provider.dart';
import 'package:primobile/menu/opcoes.dart';
import 'package:flushbar/flushbar.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'dart:async';


Timer timer;
 BuildContext dialogContext;

class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool is_loading = true;
  var artigoApi = ArtigoApiProvider();
  var clienteApi = ClienteApiProvider();
  var encomendaApi = EncomendaApiProvider();
  bool artigo_sincronizado = false;
  bool cliente_sincronizado = false;
  String estado_sync = "";
  String estado_sync_num = "";
  BuildContext menu_contexto;
  String baseUrl;

  @override
  Widget build(BuildContext context) {
    menu_contexto = context;

    (Connectivity().checkConnectivity()).then((conexaoResultado) {
      if (conexaoResultado != ConnectivityResult.mobile &&
          conexaoResultado != ConnectivityResult.wifi) {
        Flushbar(
          title: "Atenção",
          // message:  "Dispositivo sem conexão WIFI ou Dados Moveis. Por Favor Active para sincronizar dados!",
          messageText: Text(
              'Dispositivo sem conexão WIFI ou Dados Moveis. Por Favor Active para sincronizar dados!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
        )..show(context);
      }
    });

    SessaoApiProvider.read().then((parsed) async {
      Map<String, dynamic> filial = parsed['resultado'];
      String protocolo = 'http://';
      String host = filial['empresa_filial']['ip'];
      // var status = await getUrlStatus(url) ;
      setState(() {
        baseUrl = protocolo + host;
      });
    });

    createAlertDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Atenção'),
              content: Text('Deseja Sair'),
              actions: <Widget>[
                MaterialButton(
                  elevation: 5.0,
                  child: Text('Sim'),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                MaterialButton(
                  elevation: 5.0,
                  child: Text('Não'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    return WillPopScope(
      child: Scaffold(
          appBar: new AppBar(
            title: new Center(
              child: Text('Menu'),
            ),
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
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3.5,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 55.0,
                          child: Image.asset('assets/images/jmr_logo.png'),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      // container menu body
                      Container(
                        width: MediaQuery.of(context).size.width - 16,
                        height: MediaQuery.of(context).size.height / 2,
                        margin: EdgeInsets.only(top: 64),
                        child: GridView.count(
                          crossAxisCount: 3,
                          children: menuItemView(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
      onWillPop: () async {
        createAlertDialog(context);
        return false;
      },
    );

    // @override
// void dispose() {
//   timer?.cancel();
//   super.dispose();
// }
  }

  List<Widget> menuItemView() {
    return [
      Material(
          color: Colors.white,
          child: Column(
            children: [
              Center(
                child: Ink(
                  width: 65,
                  height: 65,
                  decoration: const ShapeDecoration(
                    color: Colors.deepOrange,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    iconSize: 35,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, '/encomenda_novo');
                    },
                  ),
                ),
              ),
              Center(
                child: Text(
                  "ENCOMENDA",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )),
      Material(
        color: Colors.white,
        child: Column(children: [
          Center(
            child: Ink(
              width: 65,
              height: 65,
              decoration: const ShapeDecoration(
                color: Colors.redAccent,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                iconSize: 35,
                color: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, '/encomenda_lista');
                },
              ),
            ),
          ),
          Center(
            child: Text(
              "ENCOMENDA",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              "LISTA",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          )
        ]),
      ),
      Material(
          color: Colors.white,
          child: Column(
            children: [
              Center(
                child: Ink(
                  width: 65,
                  height: 65,
                  decoration: const ShapeDecoration(
                    color: Colors.green,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.local_offer),
                    iconSize: 35,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, '/artigo_lista');
                    },
                  ),
                ),
              ),
              Center(
                child: Text(
                  "ARTIGO",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )),
      Material(
        color: Colors.white,
        child: Column(
          children: [
            Center(
              child: Ink(
                width: 65,
                height: 65,
                decoration: const ShapeDecoration(
                  color: Colors.lightBlue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.person,
                  ),
                  iconSize: 35,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/cliente_lista');
                  },
                ),
              ),
            ),
            Center(
              child: Text(
                "CLIENTE",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      )
    ];
  }

  void opcaoAcao(String opcao) async {
    var conexaoResultado = await (Connectivity().checkConnectivity());

    if (opcao == 'Sincronizar') {
      if (conexaoResultado == ConnectivityResult.mobile ||
          conexaoResultado == ConnectivityResult.wifi) {
            
    try {
      estado_sync = "Cliente";
      estado_sync_num = "(1/3)";
        clienteApi.getTodosClientes().then((listaCliente) {
          // reduntante mas util para informar o estado dos modelos
         setState(() {
            if (clienteApi.erro == false ) {
                clienteApi.sincronizado = true;
            } else {
                clienteApi.erro = true;
            }
          });
        });

  
      estado_sync = "Artigo";
      estado_sync_num = "(2/3)";
       artigoApi.getTodosArtigos().then((value) {
          // reduntante mas util para informar o estado dos modelos
         setState(() {
            if (artigoApi.erro == false ) {
                artigoApi.sincronizado = true;
            } else {
                artigoApi.erro= true;
            }
          });
       });
      estado_sync_num = "Encomenda";
      estado_sync = "(3/3)";
       encomendaApi.getTodasEncomendas().then((value) {
          // reduntante mas util para informar o estado dos modelos
         setState(() {
            if (encomendaApi.erro == false ) {
                encomendaApi.sincronizado = true;
            } else {
                encomendaApi.erro = true;
            }
          });
       });
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      dialogContext = context;

          return WillPopScope(
                child: AlertDialog(
                  title: Center(child: Text('Sincronizando')),
                  content: Container(
                      width: 50,
                      height: 50,
                      child: Center(child: CircularProgressIndicator())),
                ),
                onWillPop: () async {
                  return false;
                },
              );
    },
  );
    // new Future.delayed(const Duration(seconds: 15), () {
  //      const oneSec = const Duration(seconds:1);
  // new Timer.periodic(oneSec, (Timer t) => print('hi!'));
Timer.periodic(Duration(seconds: 3), (timer) {


 if (clienteApi.sincronizado == true &&
                    artigoApi.sincronizado == true &&
                    encomendaApi.sincronizado == true) {

                      timer.cancel();
  Navigator.pop(dialogContext);
             Flushbar(
                    title: "Informação",
                    // message:  "Dispositivo sem conexão WIFI ou Dados Moveis. Por Favor Active para sincronizar dados!",
                    messageText: Text(
                        'Dados sincronizados com sucesso!',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    duration: Duration(seconds: 4),
                    backgroundColor: Colors.green,
                  )..show(menu_contexto);

                }
                if (clienteApi.erro == true ||
                    artigoApi.erro == true ||
                    encomendaApi.erro == true) {
                        timer.cancel();
                  Flushbar(
                    title: "Atenção",
                    // message:  "Dispositivo sem conexão WIFI ou Dados Moveis. Por Favor Active para sincronizar dados!",
                    messageText: Text(
                        'Ocorreu um erro. Por favor tente novamente!',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    duration: Duration(seconds: 4),
                    backgroundColor: Colors.red,
                  )..show(menu_contexto);
  Navigator.pop(dialogContext);
                }

});
 
 
    } catch (e) {
      print('Erro: $e.message');
    }


      } else {
        Flushbar(
          title: "Atenção",
          // message:  "Dispositivo sem conexão WIFI ou Dados Moveis. Por Favor Active para sincronizar dados!",
          messageText: Text(
              'Dispositivo sem conexão WIFI ou Dados Moveis. Por Favor Active e continue!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
        )..show(context);
      }
    } else if (opcao == 'Fechar Sessão') {
      Navigator.pushReplacementNamed(context, '/');
    } else if (opcao == 'Alterar Senha') {
      Navigator.pushNamed(context, '/alterar_senha');
    }
  }

}
     
void SincronizarDialog(BuildContext context) {
      dialogContext = context;

        bool rv = false;
         showDialog(
            context: context,
            builder: (context) {          
              return WillPopScope(
                child: AlertDialog(
                  title: Center(child: Text('Aguarde')),
                  content: Container(
                      width: 50,
                      height: 50,
                      child: Center(child: CircularProgressIndicator())),
                ),
                onWillPop: () async {
                  return rv;
                },
              );
            });
      }
  // Future _loadFromApi() async {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //        return StatefulBuilder(
  //         builder: (context, setState) {
         
  //           if (this.mounted == true) {
  //             setState(() {
  //               if (clienteApi.sincronizado == true &&
  //                   artigoApi.sincronizado == true &&
  //                   encomendaApi.sincronizado == true) {
  //                 Navigator.of(context).pop();
  //               }
  //               if (clienteApi.erro == true ||
  //                   artigoApi.erro == true ||
  //                   encomendaApi.erro == true) {
  //                 Flushbar(
  //                   title: "Atenção",
  //                   // message:  "Dispositivo sem conexão WIFI ou Dados Moveis. Por Favor Active para sincronizar dados!",
  //                   messageText: Text(
  //                       'Ocorreu um erro. Por favor tente novamente!',
  //                       style: TextStyle(
  //                           color: Colors.white, fontWeight: FontWeight.bold)),
  //                   duration: Duration(seconds: 4),
  //                   backgroundColor: Colors.red,
  //                 )..show(menu_contexto);
  //                 Navigator.of(context).pop();
  //               }
  //             });
  //           }

  //            return WillPopScope(
  //             child: AlertDialog(
  //               title: Container(
  //                 child: Center(
  //                     child: Text("Sincronizando " +
  //                         estado_sync +
  //                         " Aguarde ... " +
  //                         estado_sync_num)),
  //               ),
  //               content: Container(
  //                   width: 50,
  //                   height: 50,
  //                   child: Center(child: CircularProgressIndicator())),
  //               actions: <Widget>[],
  //             ),
  //             onWillPop: () async => false,
  //           );
  //                       // });s

  //         },
  //       );
  //     },
  //   );

  //   try {
  //     estado_sync = "Cliente";
  //     estado_sync_num = "(1/3)";
  //      clienteApi.getTodosClientes();

  //     setState(() {
  //       if ( clienteApi.erro == false)
  //       clienteApi.sincronizado = true;
  //     });
  //     estado_sync = "Artigo";
  //     estado_sync_num = "(2/3)";
  //      artigoApi.getTodosArtigos();
  //   setState(() {
  //       if ( artigoApi.erro == false)
  //       artigoApi.sincronizado = true;
  //     });
  //     estado_sync_num = "Encomenda";
  //     estado_sync = "(3/3)";
  //      encomendaApi.getTodasEncomendas();

  //         setState(() {
  //       if ( encomendaApi.erro == false)
  //       encomendaApi.sincronizado = true;
  //     });
  //   } catch (e) {
  //     print('Erro: $e.message');
  //   }
  // }


class SnackBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: Text('Voilá! Um SnackBar!'),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () {
                // código para desfazer a ação!
              },
            ),
          );
          // Encontra o Scaffold na árvore de widgets
          // e o usa para exibir o SnackBar!
          Scaffold.of(context).showSnackBar(snackBar);
        },
        child: Text('Exibir SnackBar'),
      ),
    );
  }
}
