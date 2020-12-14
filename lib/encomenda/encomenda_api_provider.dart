import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/artigo/artigo_modelo.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'encomenda_modelo.dart';
import 'package:http/http.dart' as http;

class EncomendaApiProvider {
  bool sincronizado = false;

  Future<List<Encomenda>> getTodasEncomendas() async {
    bool erro = false;
    Map<String, dynamic> parsed = await SessaoApiProvider.read();
    Map<String, dynamic> resultado = parsed['resultado'];
    String protocolo = 'http://';
    String host = resultado['empresa_filial']['ip'];
    String _usuario = resultado['usuario'];
    String rota = '/api/encomenda/'+ _usuario;
    var url = protocolo + host + rota;
    Response response;

    try {
     await DBProvider.db.remove_encomenda();

    } catch (e) {
            print("[EncomendaApiProvider:remove_encomenda]ERRO: $e");

    }

    try {
      sincronizado = false;

      response = await Dio().get(url);

    } on DioError catch (e) {
      print("[getTodasEncomendas]ERRO: $e");
      return null;
      
    }

    try {
      (response.data as List).map((encomenda) async {

         Encomenda _enc = Encomenda.fromJson(encomenda);

        int rv = await this.insertEncomenda(_enc);
        rv == 0 ? print('sucesso') : print('erro');
      }).toList();
      sincronizado = true;
    } on DioError catch (e) {
      print("[getTodasEncomendas]ERRO: $e");
            sincronizado = false;

      return null;
    }
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
