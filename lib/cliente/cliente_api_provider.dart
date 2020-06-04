import 'package:dio/dio.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/encomenda/encomenda_modelo.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';

import 'cliente_modelo.dart';


class ClienteApiProvider {
  bool sincronizado = false;
  bool erro = false;
  Dio dio = new Dio();

Future  getTodosClientes() async {
    // var url = 'https://2b1e04b0.ngrok.io/api/cliente';
  Map<String, dynamic> parsed = await SessaoApiProvider.read();
  Map<String, dynamic> filial = parsed['resultado'];
  String protocolo = 'http://';
  String host = filial['empresa_filial']['ip'];
  String rota = '/api/cliente';
  var url = protocolo + host + rota;    

    Response response;

    try {
      DBProvider.db.apagarTodosClientes();

    } catch (e) {
            print("[getTodosClientes:remove_cliente]ERRO: $e");

    }
    try {

            sincronizado = false;
     response = await dio.get( url );

    } on DioError catch (e) {
      print("[ClienteApiProvider]ERRO: $e");
      erro = true;
      return null;
    }

   (response.data as List).map((cliente) async  {
      print('cliente: $cliente');
      await DBProvider.db.insertCliente(Cliente.fromJson(cliente));
    }).toList();

      sincronizado = true;
            erro = false;

  }


  void insertEncomenda(List<Encomenda> encomendas) async {

    for (Encomenda enc in encomendas) {
    await DBProvider.db.insertEncomenda(enc);
    }
  }
}



