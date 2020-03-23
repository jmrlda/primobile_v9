// import 'package:dio/dio.dart';

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class SessaoApiProvider {

  static String base_url = 'http://146.148.49.80:4000';
  static Future<bool> login(String nome_email, String senha) async {
    var login_url = '/usuarios/login';

    try {
    var response = await http.post(base_url + login_url, body: {"nome": nome_email, "senha": senha});
    Map<String, dynamic> parsed =  Map<String, dynamic>();
    parsed = jsonDecode(response.body);
    if ( parsed ['resultado'] == null ) {
      return false;
    }
    _save(response.body);
      read();
    } catch (e) {
      return false;
    }


  return true;
  }
   

   // ler dados da sessao armazenado em um ficheiro
   // e retornar o seu conteudo 
  static  Future<Map<String, dynamic>> read() async {
     Map<String, dynamic> parsed =  Map<String, dynamic>();

    try {
      final directorio = await getApplicationDocumentsDirectory();
      final file = File('${directorio.path}/sessao.json');

      String text = await file.readAsString();
     parsed = jsonDecode(text);

    } catch ( e ) {
      print('nao foi possivel ler o ficheiro');
    }

    return parsed;
  }



/** 
 *  Salvar dados da sessao em um ficheiro para seu uso posterior
 * 
 **/
  static _save(String data) async {
    final directorio = await getApplicationDocumentsDirectory();
    final file = File('${directorio.path}/sessao.json');
    await file.writeAsString(data);
  }
}