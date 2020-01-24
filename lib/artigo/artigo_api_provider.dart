import 'package:dio/dio.dart';
import 'package:primobile/Database/Database.dart';

import 'artigo_modelo.dart';


class ArtigoApiProvider {

Future<List<Artigo>> getTodosArtigos() async {
    // var url = 'http://127.0.0.1:3000/artigos';
    var url = 'https://f3409807.ngrok.io/api/artigo';
    Response response;
    print(url);   
    try {
     response = await Dio().get( url);
      
      print('response');
      print(response);
    } on DioError catch (e) {
      print(e.response);
      return null;
    }

    return (response.data as List).map((artigo) {
      print('artigo: $artigo');
      // print(artigo);
      DBProvider.db.insertArtigo(Artigo.fromJson(artigo));
    }).toList();
  }

}