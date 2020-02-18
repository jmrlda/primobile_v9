import 'package:dio/dio.dart';
import 'package:primobile/Database/Database.dart';

import 'usuario_modelo.dart';


class UsuarioApiProvider {

Future<List<Usuario>> getTodosUsuario(  ) async {
    var url = 'https://2b1e04b0.ngrok.io/api/usuario';
    Response response;

    try {
     response = await Dio().get( url );
          } on DioError catch (e) {
      print(e);
      return null;
    }

    return (response.data as List).map((usuario) {
      DBProvider.db.insertUsuario(Usuario.fromJson(usuario));
    }).toList();
  }

}