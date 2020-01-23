import 'package:flutter/material.dart';

class EncomendaSucessoPage extends StatelessWidget {
  const EncomendaSucessoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue[50],
        child: Container(
          child: Card(
            margin: EdgeInsets.only(top: 120, bottom: 120, left: 50, right: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.block,
                  color: Colors.blue,
                  size: 200,
                ),
                Text(
                  "Aguarde",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
                MaterialButton(
                  height: 56,
                  
                  color: Colors.blue[50],
                  shape: CircleBorder(),
                  child: Text('OK', style: TextStyle(
                     color: Colors.blue
                  ),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ));
  }
}