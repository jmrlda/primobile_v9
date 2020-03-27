import 'package:dio/dio.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';

import 'artigo_modelo.dart';

class ArtigoApiProvider {

  bool sincronizado = false;
  void getTodosArtigos() async {
  Map<String, dynamic> parsed = await SessaoApiProvider.read();
    Map<String, dynamic> filial = parsed['resultado'];

  String protocolo = 'http://';
  String host = filial['empresa_filial']['ip'];
  String rota = '/api/artigo';
  var url = protocolo + host + rota;    

    Response response;
     try {
            sincronizado = false;

     response = await Dio().get( url );

    } on DioError catch (e) {
      print("[ArtigoApiProvider]ERRO: $e");
      return null;
    }


     (response.data as List).map((artigo) async  {
      print('cliente: $artigo');
     await  DBProvider.db.insertArtigo(Artigo.fromJson(artigo));     
    }).toList();
     sincronizado = true;

  }

  Future insertArtigo(List<Artigo> artigos) async {

    for (Artigo a in artigos) {
      await DBProvider.db.insertArtigo(a);
    }
  }
}
