import 'package:dio/dio.dart';
import 'package:primobile/Database/Database.dart';

import 'artigo_modelo.dart';

class ArtigoApiProvider {
  void getTodosArtigos() async {
    // var url = 'http://127.0.0.1:3000/artigos';
    var url = 'http://192.168.0.104:9191/api/artigo';
    Response response;
    try {
      response = await Dio().get(url);
      List a = response.data;
      a.forEach((x) async {
    await DBProvider.db.insertArtigo( Artigo.fromJson(x));
      });

    } on DioError catch (e) {
      print("[ArtigoApiProvider]ERRO: $e.message");
    }


  }

  void insertArtigo(List<Artigo> artigos) async {

    for (Artigo a in artigos) {
      await DBProvider.db.insertArtigo(a);
    }
  }
}
