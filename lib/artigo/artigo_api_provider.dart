import 'package:dio/dio.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';

import 'artigo_modelo.dart';

class ArtigoApiProvider {
  void getTodosArtigos() async {
    // var url = 'http://127.0.0.1:3000/artigos';
    // var url = 'https://2b1e04b0.ngrok.io/api/artigo/';
  Map<String, dynamic> parsed = await SessaoApiProvider.read();
    Map<String, dynamic> filial = parsed['resultado'];

  String protocolo = 'http://';
  String host = filial['empresa_filial']['ip'];
  String rota = '/api/artigo';
  var url = protocolo + host + rota;    

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
