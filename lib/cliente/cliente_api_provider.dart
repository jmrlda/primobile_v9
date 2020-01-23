import 'package:dio/dio.dart';
import 'package:primobile/Database/Database.dart';

import 'cliente_modelo.dart';


class ClienteApiProvider {

Future<List<Cliente>> getTodosClientes(String  token) async {
    var url = 'https://primobile.herokuapp.com/clientes';
    Response response;

    try {
     response = await Dio().get( url,  options: Options(
       headers: {
         "x-access-token": 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwZXJmaWwiOiJhZG1pbiIsIm5vbWUiOiJqbXJhZG1pbiIsImlhdCI6MTU3ODQ5NDY5NCwiZXhwIjoxNTc4NDk0OTk0fQ.SwrH7RQT3TbbIUzaaQe6ZSVkiSlagB_WItc3fqqwm1E'
       }
     ) );
      
      print('response');
      print(response);
    } on DioError catch (e) {
      print(e.response.data);
      return null;
    }

    return (response.data as List).map((cliente) {
      print('cliente: $cliente');
      // print(artigo);
      DBProvider.db.insertCliente(Cliente.fromJson(cliente));
    }).toList();
  }

}