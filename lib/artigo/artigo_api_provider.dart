import 'package:dio/dio.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';

import 'artigo_modelo.dart';

class ArtigoApiProvider {

  Dio dio = new Dio();
  bool sincronizado = false;
  bool erro = false;

  Future getTodosArtigos() async {
  Map<String, dynamic> parsed = await SessaoApiProvider.read();
    Map<String, dynamic> filial = parsed['resultado'];

  String protocolo = 'http://';
  String host = filial['empresa_filial']['ip'];
  String rota = '/api/artigo';
  var url = protocolo + host + rota;    

    Response response;

       try {
      DBProvider.db.apagarTodosArtigo();

    } catch (e) {
            print("[getTodosArtigos:remove_artigo]ERRO: $e");

    }
     try {
            sincronizado = false;

     response = await dio.get( url );
    //  res = await http.get(url);

    }  catch (e) {
      print("[ArtigoApiProvider]ERRO: $e");
      erro = true;
      return null;
    }


     (response.data as List).map((artigo) async  {
      print('artigo: $artigo');
     await  DBProvider.db.insertArtigo(Artigo.fromJson(artigo));     
    }).toList();

    
    
     sincronizado = true;
      erro = false;

  }

  Future insertArtigo(List<Artigo> artigos) async {

    for (Artigo a in artigos) {
      await DBProvider.db.insertArtigo(a);
    }
  }
}
