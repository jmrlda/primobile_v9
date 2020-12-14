import 'dart:io';

import 'package:dio/dio.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

// local
import 'package:primobile/Database/Database.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';

import '../util.dart';
import 'cliente_modelo.dart';


class ClienteApiProvider {
  bool sincronizado = false;
  bool notfound = false;
  bool erro = false;
  Dio dio;
  
  
Future<List<Cliente>>  getTodosClientes() async {
    // var url = 'https://2b1e04b0.ngrok.io/api/cliente';
  Map<String, dynamic> parsed = await SessaoApiProvider.read();
  Map<String, dynamic> filial = parsed['resultado'];
  String protocolo = 'http://';
  String host = filial['empresa_filial']['ip'];
  String rota = '/api/cliente';
  var url = protocolo + host + rota;    
// dio = new Dio()
//   ..interceptors.add(RetryInterceptor(
//     dio: dio,
//       options: const RetryOptions(
//         retries: 3, // numero de tentativas antes de falhar
//         retryInterval: const Duration(seconds: 3),
         
//       )
//     ));
    var response;
    try {

            sincronizado = false;
    //  response = await dio.get( url );
      response = await http.get(url);

    } on DioError catch (e) {
      print("[ClienteApiProvider]ERRO: $e");
      erro = true;
      notfound = true;
    }
   dynamic data =  json.decode(response.body);
   List<Cliente> lista = (data as List).map((cliente)   {
     return Cliente.fromJson(cliente);
    }).toList();
      // sincronizado = true;
      
    
    var status = await insertClientes(lista);

      if (status == true) {
      sincronizado = true;
      erro = false;
      } else {
        erro = true;
      }
  return lista;
  }

  
Future<bool> insertClientes(List<Cliente> cliente) async {
  bool rv = false;
try {

    // for (Cliente c in cliente) {
      await DBProvider.db.insertClienteAll(cliente);
    // }
    rv = true;
    } catch(  ex) {
      erro = true;
      rv = false;
      print('[insertEncomendas] ' + ex);
    }
    return rv;
  }




   Future<http.Response> postClienteFoto(Cliente cliente) async {
    Map<String, dynamic> parsed = await SessaoApiProvider.read();
    Map<String, dynamic> filial = parsed['resultado'];
    String protocolo = 'http://';
    String host = filial['empresa_filial']['ip'];
    String rota = '/api/cliente';
    var url = protocolo + host + rota;

    var body = json.encode(cliente.imagemToMap());

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    // verificar o codigo do status

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }



Future<Response> postClienteImagem(Cliente cliente, String filename, dynamic image ) async {
    Map<String, dynamic> parsed = await SessaoApiProvider.read();
    Map<String, dynamic> filial = parsed['resultado'];
    String protocolo = 'http://';
    String host = filial['empresa_filial']['ip'];
    String rota = '/api/ImagemUpload/cliente/' +  cliente.cliente;
    String url = protocolo + host + rota;
     File file = await writeByteFile(filename, image);
    Response response = await uploadImage(file,  url);
    // verificar o codigo do status
    print("${response.statusCode}");
    return   response;
  }
}
