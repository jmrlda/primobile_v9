// exeterno
import 'package:flutter_slidable/flutter_slidable.dart';

// local
import 'package:flutter/material.dart';
import 'package:primobile/encomenda/encomenda_nova_page.dart';

class EncomendaListaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: DefaultTabController(
        length: choices.length,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              centerTitle: true,
              title: const Text(
                'Encomenda',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              bottom: TabBar(
                isScrollable: true,
                tabs: choices.map((Choice choice) {
                  return Tab(
                    text: choice.title,
                    icon: Icon(choice.icon),
                  );
                }).toList(),
              ),
                    leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
            ),
            body: Container(
              color: Colors.blue[200],
              child: TabBarView(
                children: choices.map((Choice choice) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ChoiceCard(choice: choice),
                  );
                }).toList(),
              ),
            )),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Recente', icon: Icons.access_time),
  const Choice(title: 'Pendente', icon: Icons.timelapse),
  const Choice(title: 'Atendidos', icon: Icons.alarm_on),
  const Choice(title: 'Cancelados', icon: Icons.alarm_off),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;
  final BuildContext context = null;

  @override
  Widget build(BuildContext context) {
    // final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return ListView(
      children: <Widget>[
        encomenda(context),
        Divider(),
        encomenda(context),
        Divider(),
        encomenda(context),
        Divider(),
        encomenda(context),
        Divider(),
        encomenda(context),
        Divider(),
        encomenda(context),

      ],
    );
  }

  Card tabBody(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Not in stock'),
          content: Container(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  Icons.block,
                  size: 180,
                  color: Colors.blue,
                ),
                Text(
                  'Tem a certeza que\n deseja remover ?',
                  style: TextStyle(color: Colors.blue),
                )
              ],
            ),
          ),
          actions: <Widget>[

            FlatButton(
              shape: CircleBorder(),
              color: Colors.blue[100],
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(15.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Nao",
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
              ),
            ),
            FlatButton(
              shape: CircleBorder(),
              color: Colors.red,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(15.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Sim",
                style: TextStyle(fontSize: 18.0),
              ),
            )
            
          ],
        );
      },
    );
  }

  Slidable encomenda(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: encomendaItem(),
      // actions: <Widget>[
      //   IconSlideAction(
      //     caption: 'Archive',
      //     color: Colors.blue,
      //     icon: Icons.archive,
      //     onTap: () => _ackAlert(context),
      //   ),
      //   IconSlideAction(
      //     caption: 'Share',
      //     color: Colors.indigo,
      //     icon: Icons.share,
      //     onTap: () => _showSnackBar('Share'),
      //   ),
      // ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: Colors.black45,
          icon: Icons.edit,
          onTap: () => EncomendaPage(),
        ),
          IconSlideAction(
          caption: 'Cancelar',
          color: Colors.blueGrey,
          icon: Icons.block,
          onTap: () => EncomendaPage(),
        ),
        IconSlideAction(
          caption: 'Remover',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _ackAlert(context),
        ),
      ],
    );
  }


}

SizedBox encomendaItem() {
  return SizedBox(
      child: Column(
    children: <Widget>[
      Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15, left: 16, right: 16),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.,
                children: <Widget>[
                  Text("ENC001",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: EdgeInsets.only(left: 55),
                    child: Text("Dercio Guirruta",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("5 Artigos",
                      style: TextStyle(color: Colors.blue, fontSize: 16)),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30,
                    ),
                    child: Text("No Valor de  300.00 meticais ",
                        style: TextStyle(color: Colors.blue, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
    ],
  ));
}

//  Widget _dialogRemoverItem() => AlertDialog(

//       title: Text(
//         "How to follow us?",
//         textAlign: TextAlign.center,
//       ),
//       titleTextStyle: TextStyle(
//           color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700),
//       titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//       content: Text("1. You should login in the facebook.\n"
//           "2. You should search the Flutter Open.\n"
//           "3. Then, you can follow the Flutter Open."),
//       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       contentTextStyle: TextStyle(color:  Colors.black87, fontSize: 16),
//       actions: <Widget>[
//         Container(
//           height: 40,
//           width: 100,
//           child: FlatButton(
//             child: Text(
//               "Sure",
//               style: TextStyle(color:  Colors.black87),
//             ),
//             color:  Colors.red,
//             onPressed: () {
//               print("Hello");
//             },
//           ),
//         )
//       ],
//       shape: RoundedRectangleBorder(
//           side: BorderSide(
//             style: BorderStyle.none,
//           ),
//           borderRadius: BorderRadius.circular(10)),
//     );
