

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http  ;
import 'package:path_provider/path_provider.dart';

class SessaoApiProvider {
  static String base_url = 'http://146.148.49.80:4000';

  /// @login  - Metodo para controlo de entrada e sessão dos usuarios

  /// @Retorno : inteiro 

  ///            0 - sucesso

  ///            1 - falha na autenticação

  ///            2 - falha de acesso a internet

  ///            3 - Erro desconhecido

  /// 

  static Future<Map<String, dynamic>> login(String nome_email, String senha, bool online) async {
    Map<String, dynamic> rv  =  Map<String, dynamic>();
    rv = {'status': -1, 'descricao' : ""};

      
    var login_url = '/usuarios/login';
    nome_email = nome_email.trim();
    try {
      var sessao = await read();
      var response;
      if (online == true) {
        response = await http.post(base_url + login_url,
            body: {"nome": nome_email, "senha": senha});
                        rv['status'] = 0;
                        rv['descricao'] = "login sucesso";

      } else {
        if (sessao == null || sessao.length == 0) {
                  rv['status'] = 1;
                        rv['descricao'] = "Sem arquivo da sessão";        } else {
          if (sessao["nome"].toString().toLowerCase() ==
                  nome_email.toLowerCase() &&
              sessao["senha"] == senha) {
                  rv['status'] = 0;
                        rv['descricao'] = "login da sessão sucesso";          } 
        }
      }

      Map<String, dynamic> parsed = Map<String, dynamic>();
      if ( response != null) {
        parsed = jsonDecode(response.body);
        if (parsed['resultado'] == null) {
          rv['status'] = 1;
          rv['descricao'] = "Erro de autenticação";      } else {
      _save(jsonEncode({
        "nome": nome_email,
        "senha": senha,
        "resultado": parsed['resultado'],
      }));
      sessao = await read();
        rv['status'] = 0;
        rv['descricao'] = "login sucesso";      }

      }
     
    } catch (e) {
      // if (e.osError.errorCode == 111) {
      //   rv =  2;
      // }

                        rv['status'] = 3;
                        rv['descricao'] = e;
    }

  

    return rv;
  }

  // ler dados da sessao armazenado em um ficheiro
  // e retornar o seu conteudo
  static Future<Map<String, dynamic>> read() async {
    Map<String, dynamic> parsed = Map<String, dynamic>();

    try {
      final directorio = await getApplicationDocumentsDirectory();
      final file = File('${directorio.path}/sessao.json');
      if ( file.existsSync() == true) {

      String text = await file.readAsString();
      parsed = jsonDecode(text);
            } else {
                    print('[sessao read] Atenção Ficheiro não existe!');

              return Map();
            }

    } catch (e) {
      print('nao foi possivel ler o ficheiro');
      return Map();
    }

    return parsed;
  }

///  Salvar dados da sessao em um ficheiro para seu uso posterior

  static _save(String data) async {
    final directorio = await getApplicationDocumentsDirectory();
    final file = File('${directorio.path}/sessao.json');
    await file.writeAsString(data);
  }

  // ignore: slash_for_doc_comments
  /**
   * 
   * @Retorno : inteiro 
   *            0 - sucesso
   *            1 - falha autenticacao
   *            2 - falha acesso internet
   *            3 - Erro desconhecido
   * 
   */
  static Future<int> alterarSenha(
      String senha_actual, String senha_nova, String senha_confirmar) async {
    var novasenha_url = '/usuarios/alterarsenha';

    try {
      var sessao = await read();
      var response;
      String nome_email = sessao["nome"].toString();
      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessao nao existe');
      } else {
        response = await http.post(base_url + novasenha_url, body: {
          "nome": nome_email,
          "senha_actual": senha_actual,
          "senha_nova": senha_nova,
          "senha_confirmar":senha_confirmar
        });
      }
      Map<String, dynamic> parsed = Map<String, dynamic>();
      parsed = jsonDecode(response.body);
      if (parsed['resultado'] == null) {
        return 1;
      }
    } catch (e) {
      if (e.osError.errorCode == 111) {
        return 2;
      }

      return 3;
    }

    return 0;
  }
}
