import 'package:flutter/material.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/util.dart';

import 'cliente_modelo.dart';


class ClientePage extends StatefulWidget {
  ClientePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ClientePageState createState() => new _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  TextEditingController editingController = TextEditingController();

  // final duplicateItems = List<String>.generate(10000, (i) => "Item $i");

  static List<Cliente> listaCliente =  [
    Cliente(cliente: "A&L001", nome: "A & L Enterprises, Lda.", numContrib: 400079900, endereco: Endereco(ruaAv: "Matola") ),
    Cliente(cliente: "ABB001", nome: "Abby Supermarket - Sociedade Unipessoal, Lda.", numContrib: 400079900, endereco: Endereco(ruaAv: "Av. Karl Marx No. 1902") ),
    Cliente(cliente: "ABO001", nome: "Aboubakar Ntakirutimana", numContrib: 400079900, endereco: Endereco(ruaAv: "Bairro Mapandane, No. 714, R/C, Cidade da Matola") ),
    Cliente(cliente: "ANG001", nome: "Angel Mini-Supermercado", numContrib: 400079900, endereco: Endereco(ruaAv: "Av. Fernao de Magalhaes nº 797/801") ),
  ];
  
  final duplicateItems = <ListaTile>[];
    
  //           ListaTile(
  //             leading: CircleAvatar(
  //               backgroundColor: Colors.blue,
  //               // radius: 50.0,
  //               child: Icon(
  //                 Icons.person,
  //                 color: Colors.white,
  //                 // size: 50.0,
  //               ),
  //             ),
  //             title: Text(
  //               'Dercio Guirruta',
  //               style: TextStyle(
  //                   color: Colors.blue,
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             subtitle: Text(
  //               'Maputo, xipamanine',
  //               style:
  //                   TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  //             ),
  //             data: 'Dercio Guirruta',
  //           ),

  //           ListaTile(
  //             leading: CircleAvatar(
  //               backgroundColor: Colors.blue,
  //               // radius: 50.0,
  //               child: Icon(
  //                 Icons.person,
  //                 color: Colors.white,
  //                 // size: 50.0,
  //               ),
  //             ),
  //             title: Text(
  //               'Bernardo',
  //               style: TextStyle(
  //                   color: Colors.blue,
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             subtitle: Text(
  //               'Maputo, Maputo, av.angola',
  //               style:
  //                   TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  //             ),
  //             data: 'Bernardo',
  //           ),

  //           ListaTile(
  //             leading: CircleAvatar(
  //               backgroundColor: Colors.blue,
  //               // radius: 50.0,
  //               child: Icon(
  //                 Icons.person,
  //                 color: Colors.white,
  //                 // size: 50.0,
  //               ),
  //             ),
  //             title: Text(
  //               'Leo',
  //               style: TextStyle(
  //                   color: Colors.blue,
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             subtitle: Text(
  //               'Maputo, Malanga',
  //               style:
  //                   TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  //             ),

  //             data: "Leo"
  //           ),

  //           ListaTile(
  //             leading: CircleAvatar(
  //               backgroundColor: Colors.blue,
  //               // radius: 50.0,
  //               child: Icon(
  //                 Icons.person,
  //                 color: Colors.white,
  //                 // size: 50.0,
  //               ),
  //             ),
  //             title: Text(
  //               'Jorge Rodrigues',
  //               style: TextStyle(
  //                   color: Colors.blue,
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             subtitle: Text(
  //               'Maputo, Zimpeto',
  //               style:
  //                   TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  //             ),
  //             data: "Jorge Rodrigues",
  //           ),
	// 		ListaTile(
  //             leading: CircleAvatar(
  //               backgroundColor: Colors.blue,
  //               // radius: 50.0,
  //               child: Icon(
  //                 Icons.person,
  //                 color: Colors.white,
  //                 // size: 50.0,
  //               ),
  //             ),
  //             title: Text(
  //               'Casquinho',
  //               style: TextStyle(
  //                   color: Colors.blue,
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             subtitle: Text(
  //               'Nacala, Av. Eduardo Mondlane',
  //               style:
  //                   TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  //             ),
  //             data: 'Casquinho'
  //           ),

	// 		ListaTile(
  //             leading: CircleAvatar(
  //               backgroundColor: Colors.blue,
  //               // radius: 50.0,
  //               child: Icon(
  //                 Icons.person,
  //                 color: Colors.white,
  //                 // size: 50.0,
  //               ),
  //             ),
  //             title: Text(
  //               'Teste',
  //               style: TextStyle(
  //                   color: Colors.blue,
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             subtitle: Text(
  //               'Maputo, xipamanine',
  //               style:
  //                   TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  //             ),
  //             data: 'Teste'
  //           ),

	// 		ListaTile(
	// 			  leading: CircleAvatar(
  //               backgroundColor: Colors.blue,
  //               // radius: 50.0,
  //               child: Icon(
  //                 Icons.person,
  //                 color: Colors.white,
  //                 // size: 50.0,
  //               ),
  //             ),
  //             title: Text(
  //               'Dercio Guirruta',
  //               style: TextStyle(
  //                   color: Colors.blue,
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             subtitle: Text(
  //               'Maputo, xipamanine',
  //               style:
  //                   TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  //             ),
  //             data: 'Dercio Guirruta'
  //           ),

	// 		ListaTile(
  //             leading: CircleAvatar(
  //               backgroundColor: Colors.blue,
  //               // radius: 50.0,
  //               child: Icon(
  //                 Icons.person,
  //                 color: Colors.white,
  //                 // size: 50.0,
  //               ),
  //             ),
  //             title: Text(
  //               'Dercio Guirruta',
  //               style: TextStyle(
  //                   color: Colors.blue,
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             subtitle: Text(
  //               'Maputo, xipamanine',
  //               style:
  //                   TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  //             ),
  //             data: 'Dercio Guirruta'

  //           ),
  // ];

  var items = List<ListaTile>();

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<ListaTile> dummySearchList = List<ListaTile>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<ListaTile> dummyListData = List<ListaTile>();
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
        appBar:  new AppBar(
        backgroundColor: Colors.blue,
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
       floatingActionButton: FloatingActionButton(
        child: Icon(Icons.sync),
        onPressed: () async {
          // List<Artigo> artigos = await DBProvider.db.getTodosArtigos();
          // duplicateItems = artigos;
          // print('size');
          // print(artigos.length);
          listaCliente.forEach((cliente) async {
            print(cliente.cliente);
            await DBProvider.db.insertCliente(cliente);
            setState(() {

            });
          });
        },
      ),
    );
  }
}
