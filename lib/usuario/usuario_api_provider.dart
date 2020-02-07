import 'package:dio/dio.dart';
import 'package:primobile/Database/Database.dart';

import 'usuario_modelo.dart';


class UsuarioApiProvider {

Future<List<Usuario>> getTodosUsuario(String  token) async {
    var url = 'https://5ac64b0b.ngrok.io/api/usuario';
    Response response;

    try {
     response = await Dio().get( url,  options: Options(
       headers: {
         "x-access-token": 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwZXJmaWwiOiJhZG1pbiIsIm5vbWUiOiJqbXJhZG1pbiIsImlhdCI6MTU3ODY2NDQ3OCwiZXhwIjoxNTc4NjY0Nzc4fQ.7opVkjeD6atNxV0iaX-scqdflLSV-Z2chZ_hpK00jYY'
       }
     ) );
      
      print('response');
      print(response);
    } on DioError catch (e) {
      print(e.response.data);
      return null;
    }

    return (response.data as List).map((usuario) {
      print('cliente: $usuario');
      // print(artigo);
      DBProvider.db.insertUsuario(Usuario.fromJson(usuario));
    }).toList();
  }

}