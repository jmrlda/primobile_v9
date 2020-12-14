import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:dio_retry/dio_retry.dart';
import 'package:primobile/Database/Database.dart';

import 'package:primobile/sessao/sessao_api_provider.dart';
import '../util.dart';
import 'encomenda_modelo.dart';
import 'package:http/http.dart' as http;

class EncomendaApiProvider {
  bool sincronizado = false;
  bool erro = false;
 List<Encomenda> lista ;
  Future<List<Encomenda>> getTodasEncomendas() async {
  
    Map<String, dynamic> parsed = await SessaoApiProvider.read();
    Map<String, dynamic> resultado = parsed['resultado'];
    String protocolo = 'http://';
    String host = resultado['empresa_filial']['ip'];
    String _usuario = resultado['usuario'];
    String rota = '/api/encomenda/'+ _usuario;
    var url = protocolo + host + rota;
    var response;

    try {
      await DBProvider.db.removeEncomenda();

    } catch (e) {
            print("[EncomendaApiProvider:removeEncomenda]ERRO: $e");

    }

    try {
      sincronizado = false;
  // Dio dio;
  // dio = new Dio()
  //   ..interceptors.add(RetryInterceptor(
  //     dio: dio,
  //     options: const RetryOptions(
  //       retries: 3, // numero de tentativas antes de falhar
  //       retryInterval: const Duration(seconds: 3),
         
  //     )
  //   ));
      // response =  await dio.get(url);
     response =  await http.get(url);

    } on DioError catch (e) {
      print("[getTodasEncomendas]ERRO: $e");
            erro = true;

      return List();
      
    }

       dynamic data =  json.decode(response.body);

      lista = (data as List).map((encomenda)   {
       return  Encomenda.fromJson(encomenda);
    }).toList();

    
    
     var status = await insertEncomendas(lista);
     
      if (status == true) {
        
      sincronizado = true;
      erro = false;
      } else {
        erro = true;
      }

   

      return lista;
  }

  Future<int> insertEncomenda(Encomenda encomenda) async {
    int rv = -1;
    try {
      rv = await DBProvider.db.insertEncomenda(encomenda);
    } catch (err) {
      return -2;
    }

    return rv;
  }

Future<bool> insertEncomendas(List<Encomenda> encomendas) async {
  bool rv = false;
try {

    for (Encomenda e in encomendas) {
       await DBProvider.db.insertEncomenda(e);
    }
    rv = true;
    } catch(  ex) {
      erro = true;
      rv = false;
      print('[insertEncomendas] ' + ex);
    }
    return rv;
  }

  Future<bool> removeEncomendaByid(int id) async {
    bool rv = false;
    try {
      rv = await DBProvider.db.removeEncomendaById (id);
    } catch (err) {
      rv = false;
    }

    return rv;
  }
  Future<http.Response> postEncomenda(Encomenda encomenda) async {
    Map<String, dynamic> parsed = await SessaoApiProvider.read();
    Map<String, dynamic> filial = parsed['resultado'];
    String protocolo = 'http://';
    String host = filial['empresa_filial']['ip'];
    String rota = '/api/encomenda';
    var url = protocolo + host + rota;

    var body = json.encode(encomenda.toMapApi());

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    

    return response;
  }


/// @postEncomendaAssinatura - metodo responsavel por enviar imagem contendo assinatura do cliente como 

///  comprovativo da encomenda.

/// @ argumento

///  # encomenda - necessario para criar a url da encomenda 

///  # filename - nome que sera usado para armazenar a imagem

///  # assinatura - bytes da imagem contendo a assinatura

/// @ retorno - HTTP response contendo o codigo de status do carregamento da assinatura

Future<int> postEncomendaAssinatura(Encomenda encomenda, String filename, dynamic assinatura, File file ) async {
    Map<String, dynamic> parsed = await SessaoApiProvider.read();
    Map<String, dynamic> filial = parsed['resultado'];
    String protocolo = 'http://';
    String host = filial['empresa_filial']['ip'];
    String rota = '/api/ImagemUpload/encomenda/' +  encomenda.encomenda_id.replaceAll('/', '_');
    String url = protocolo + host + rota;
    print('url' + url);
     Response response;
     try {
         response = await uploadImage(file,  url);
    // verificar o codigo do status

     } catch (e) {
            print("[postEncomendaAssinatura] erro: Exception");
            print(e);

     } 
   
    return   response.statusCode;
  }




  Future<http.Response> postBuscarDesconto(Encomenda encomenda) async {
    Map<String, dynamic> parsed = await SessaoApiProvider.read();
    Map<String, dynamic> filial = parsed['resultado'];
    String protocolo = 'http://';
    String host = filial['empresa_filial']['ip'];
    String rota = '/api/RegrasPrecoDesconto';
    var url = protocolo + host + rota;
    Map mapa = new Map();
    List<String> artigoPromo = new List<String>();

    encomenda.artigos.forEach((element) {
      artigoPromo.add(element.artigo);
     });

    mapa["cliente"] = encomenda.cliente.cliente;
    mapa["artigo"] = artigoPromo;

    var body = json.encode(mapa);
    var response;
    try {
     response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    }catch( err ) {
      response = err;
    }


    // verificar o codigo do status
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }



}
