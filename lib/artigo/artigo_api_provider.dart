import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:primobile/Database/Database.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';

import 'artigo_modelo.dart';

class ArtigoApiProvider {

 
  bool sincronizado = false;
  bool notfound = false;
  bool erro = false;
  var dio;
    // dio.interceptors.add(RetryInterceptor(
    //   dio: dio,
    //   options: const RetryOptions(
    //     retries: 3, // numero de tentativas antes de falhar
    //     retryInterval: const Duration(seconds: 3),
         
    //   ), 
    // ));
    // dio.interceptors(RetryInterceptor(
    
    // ))
  Future getTodosArtigos() async {
  Map<String, dynamic> parsed = await SessaoApiProvider.read();
    Map<String, dynamic> filial = parsed['resultado'];

  String protocolo = 'http://';
  String host = filial['empresa_filial']['ip'];
  String rota = '/api/artigo';
  var url = protocolo + host + rota;    
//  dio  = Dio()
//   ..interceptors.add(RetryInterceptor(
//     dio: dio,
//     options: const RetryOptions(
//       retries: 3, // Number of retries before a failure
//       retryInterval: const Duration(seconds: 3), // Interval between each retry
//  // Evaluating if a retry is necessary regarding the error. It is a good candidate for updating authentication token in case of a unauthorized error (be careful with concurrency though)
//     )
//   )
// ); 
    var response;

    //    try {
    //   DBProvider.db.apagarTodosArtigo();

    // } catch (e) {
    //         print("[getTodosArtigos:remove_artigo]ERRO: $e");

    // }
     try {
            sincronizado = false;

    //  response = await dio.get( url );
     response =  await http.get(url);

    }  catch (e) {
      print("[ArtigoApiProvider]ERRO: $e");
      erro = true;
      notfound = true;
      throw e;
    }

   dynamic data = await json.decode(response.body);

     List<Artigo> lista = (data as List).map((artigo)   {
    //   print('artigo: $artigo');
    //  await  DBProvider.db.insertArtigo(Artigo.fromJson(artigo));   
    //  sincronizado = true;
    //  notfound = false;
    //   erro = false;  
    return Artigo.fromJson(artigo);
    }).toList();

    
          // sincronizado = true;

     var status = await  insertArtigo(lista);

      if (status == true) {
      sincronizado = true;
      erro = false;
      } else {
        erro = true;
      }

  return lista;
  }

  Future<bool> insertArtigo(List<Artigo> artigos) async  {
    bool rv = false;
try {

    // for (Artigo a in artigos) {
      
       await DBProvider.db.insertArtigoAll(artigos);
        
    // }
    rv = true;
    } catch(  ex) {
      erro = true;
      print('[insertArtigo] ' + ex);
      rv = false;
    }

    return rv;

  }

  Future<http.Response> postArtigo(Artigo artigo) async {
    Map<String, dynamic> parsed = await SessaoApiProvider.read();
    Map<String, dynamic> filial = parsed['resultado'];
    String protocolo = 'http://';
    String host = filial['empresa_filial']['ip'];
    String rota = '/api/artigo';
    var url = protocolo + host + rota;

    var body = json.encode(artigo.toMap());

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    // verificar o codigo do status

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<http.Response> postArtigoFoto(Artigo artigo) async {
    Map<String, dynamic> parsed = await SessaoApiProvider.read();
    Map<String, dynamic> filial = parsed['resultado'];
    String protocolo = 'http://';
    String host = filial['empresa_filial']['ip'];
    String rota = '/api/artigo';
    var url = protocolo + host + rota;

    var body = json.encode(artigo.imagemToMap());

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    // verificar o codigo do status

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }
}
