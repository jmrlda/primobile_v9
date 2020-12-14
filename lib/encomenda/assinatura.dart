
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:flutter/material.dart';


class AssinaturaDigital extends StatefulWidget {

  @override
  _AssinaturaDigitalState createState() => _AssinaturaDigitalState();
}

class _AssinaturaDigitalState extends State<AssinaturaDigital> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3.5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Valor alterado"));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Stack(
            children: <Widget>[
              // Container(
              //   height: 300,
              //   child: Center(
              //     child: Text('Big container to test scrolling issues'),
              //   ),
              // ),
              //SIGNATURE CANVAS
              Signature(
                controller: _controller,
                // height: 300,
                backgroundColor: Colors.white,


              ),
              // OK AND CLEAR BUTTONS
              Container(
                decoration: const BoxDecoration(color: Colors.black),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //SHOW EXPORTED IMAGE IN NEW ROUTE
                    IconButton(
                      icon: const Icon(Icons.check),
                      color: Colors.blue,
                      onPressed: () async {
                        if (_controller.isNotEmpty) {

                          _controller.toPngBytes().then((data){

                         if (data.length > 0)  {
                          Navigator.of(context).pop(data);                      

                         }
                          });
                          
                          // toPngBytes();
                          // File('../assets/images/ok.png').writeAsBytesSync(data, flush: true);
                            // await writeImage('teste.png', data);
                            // data = (await readImage('teste.png')).toString();
                            
                      
                        }
                          Navigator.of(context).pop();                      


                      },
                    ),
                    //CLEAR CANVAS
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.blue,
                      onPressed: () {
                        setState(() => _controller.clear());
                      },
                    ),
                  ],
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }

  Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<void> writeImage(String filename, Uint8List buffer) async {
  try {
final path = await _localPath;
   final file = File('$path/'+ filename);
   file.writeAsBytesSync(buffer);

  } catch( err ) {
    print('Ocorreu um erro');
    print(err);
  }
}

Future<Uint8List> readImage(String filename) async {
  try {
    final path = await _localPath;
    final file = File('$path/'+filename);
    Uint8List contents =  file.readAsBytesSync();
    return contents;
  } catch (e) {
    print("Ocrreu um erro");
    print(e);
   throw e;
  }
}

}