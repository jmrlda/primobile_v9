import 'package:dio/dio.dart';
import 'package:primobile/Database/Database.dart';

import 'encomenda_modelo.dart';


class EncomendapiProvider {

Future<List<Encomenda>> getTodasEncomendas(String  token) async {
    var url = 'https://5ac64b0b.ngrok.io/api/encomendas';
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

    return (response.data as List).map((encomenda) {
      print('cliente: $encomenda');
      // print(artigo);
      DBProvider.db.insertUsuario(encomenda.fromJson(encomenda));
    }).toList();
  }



  void insertEncomenda(Encomenda encomenda) async {
      await DBProvider.db.insertEncomenda(encomenda);    
  }
}