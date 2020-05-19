import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'encomenda_modelo.dart';
import 'package:http/http.dart' as http;

class EncomendapiProvider {


  Future<List<Encomenda>> getTodasEncomendas(String token) async {
    
  Map<String, dynamic> parsed = await SessaoApiProvider.read();
  Map<String, dynamic> filial = parsed['resultado'];
  String protocolo = 'http://';
  String host = filial['empresa_filial']['ip'];
  String rota = '/api/encomenda';
  var url = protocolo + host + rota;  
    Response response;

    try {
      response = await Dio().get(url,
          options: Options(headers: {
            "x-access-token":
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwZXJmaWwiOiJhZG1pbiIsIm5vbWUiOiJqbXJhZG1pbiIsImlhdCI6MTU3ODQ5NDY5NCwiZXhwIjoxNTc4NDk0OTk0fQ.SwrH7RQT3TbbIUzaaQe6ZSVkiSlagB_WItc3fqqwm1E'
          }));

      print('response');
      print(response);
    } on DioError catch (e) {
      print(e.response.data);
      return null;
    }

    return (response.data as List).map((encomenda) {
      print('cliente: $encomenda');
      // print(artigo);
      DBProvider.db.insertUsuario(encomenda.fromJson(encomenda));
    }).toList();
  }

  Future<int> insertEncomenda(Encomenda encomenda) async {
    try {
      await DBProvider.db.insertEncomenda(encomenda);

    } catch(err) {
      return -1;
    }

    return 0;
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


      // verificar o codigo do status
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }
}
