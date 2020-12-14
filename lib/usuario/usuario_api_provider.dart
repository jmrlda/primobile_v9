import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';

import 'usuario_modelo.dart';


class UsuarioApiProvider {

Future<List<Usuario>> getTodosUsuario(  ) async {
    // var url = 'https://2b1e04b0.ngrok.io/api/usuario';
  Map<String, dynamic> parsed = await SessaoApiProvider.read();
  Map<String, dynamic> filial = parsed['resultado'];
  String protocolo = 'http://';
  String host = filial['empresa_filial']['ip'];
  String rota = '/api/usuario';
  var url = protocolo + host + rota;  

    Response response;

    try {
        Dio dio;
  dio = new Dio()
    ..interceptors.add(RetryInterceptor(
      dio: dio,
      options: const RetryOptions(
        retries: 3, // numero de tentativas antes de falhar
        retryInterval: const Duration(seconds: 3),
         
      )
    ));
     response = await dio.get( url );
          } on DioError catch (e) {
      print(e);
      return List();
    }

    return (response.data as List).map((usuario) {
      DBProvider.db.insertUsuario(Usuario.fromJson(usuario));
    }).toList();
  }

}