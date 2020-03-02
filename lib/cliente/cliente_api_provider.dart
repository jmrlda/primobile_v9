import 'package:dio/dio.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/encomenda/encomenda_modelo.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';

import 'cliente_modelo.dart';


class ClienteApiProvider {

Future<List<Cliente>> getTodosClientes() async {
    // var url = 'https://2b1e04b0.ngrok.io/api/cliente';
  Map<String, dynamic> parsed = await SessaoApiProvider.read();
  Map<String, dynamic> filial = parsed['resultado'];
  String protocolo = 'http://';
  String host = filial['empresa_filial']['ip'];
  String rota = '/api/cliente';
  var url = protocolo + host + rota;    
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
      print(e?.response);
      return null;
    }

    return (response.data as List).map((cliente) {
      print('cliente: $cliente');
      DBProvider.db.insertCliente(Cliente.fromJson(cliente));
    }).toList();
  }


  void insertEncomenda(List<Encomenda> encomendas) async {

    for (Encomenda enc in encomendas) {
      int rv = await DBProvider.db.insertEncomenda(enc);
      print('sucesso pt2 $rv');
    }
  }
}



