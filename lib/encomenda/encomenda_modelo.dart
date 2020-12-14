import 'dart:convert';

import 'package:primobile/Database/Database.dart';
import 'package:primobile/artigo/artigo_modelo.dart';
import 'package:primobile/cliente/cliente_modelo.dart';
import 'package:primobile/usuario/usuario_modelo.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:intl/intl.dart';

class Encomenda {
  String id;
  Cliente cliente;
  Usuario vendedor;
  List<Artigo> artigos;
  List artigos_json = List();
  double valorTotal;
  String estado;
  DateTime dataHora;
  String encomenda_id;

  Encomenda(
      {this.id,
      this.cliente,
      this.vendedor,
      this.artigos,
      this.valorTotal,
      this.estado,
      this.dataHora,
      this.encomenda_id});

  factory Encomenda.fromMap(Map<String, dynamic> json) {
    Usuario usuario = Usuario(
        usuario: '276D1CB0-6C8F-4078-8904-2E119D13B4FB',
        nome: 'dercio',
        perfil: 'admin',
        documento: 'vd',
        senha: 'rere');

    Cliente cliente = Cliente(cliente: json['cliente']);
    Future<Map<String, dynamic>> sessao = SessaoApiProvider.read();
    sessao.then((value) => {});
    return new Encomenda(
        id: json['encomenda'].toString(),
        cliente: cliente,
        vendedor: usuario,
        artigos: List<Artigo>(),
        valorTotal: json['valor'],
        estado: json['estado'],
        dataHora: DateTime.tryParse(json['data_hora']),
        encomenda_id: json['encomenda_id']);
  }

  factory Encomenda.fromMap_2(Map<String, dynamic> json, Cliente cliente) {
    Usuario usuario = Usuario(
        usuario: '276D1CB0-6C8F-4078-8904-2E119D13B4FB',
        nome: 'dercio',
        perfil: 'admin',
        documento: 'vd',
        senha: 'rere');
    // Cliente cliente = Cliente(cliente: json['cliente']);
    return new Encomenda(
        id: json['encomenda'].toString(),
        cliente: cliente,
        vendedor: usuario,
        artigos: List<Artigo>(),
        valorTotal: json['valor'],
        estado: json['estado'],
        dataHora: DateFormat('dd-MM-yyyy HH:mm:ss')
            .parse(json['data_hora'].toString()),
        encomenda_id: json['encomenda_id']);
  }

  Map<String, dynamic> toMap() => {
        'cliente': cliente.cliente,
        'vendedor': vendedor.usuario,
        // 'artigos': artigos,
        'valor': valorTotal,
        'estado': estado,
        'data_hora': dataHora.toString(),
        'encomenda_id': this.encomenda_id
      };

  Map<String, dynamic> toMapApi() {
    if (artigos != null) {
      artigos.forEach((element) {
        artigos_json.add(element.toMap());
      });
    } else {
      artigos_json = [];
    }

    return {
      'cliente': cliente.toMap(),
      'vendedor': vendedor.toMap(),
      'artigos': artigos_json,
      'valorTotal': valorTotal,
      'estado': estado,
      'dataHora': dataHora.toString(),
      'encomenda_id': this.encomenda_id
    };
  }

  Map<String, dynamic> ItemtoMap() => {
        'encomenda': id,
        'artigo': vendedor.usuario,
        'valor_unit': artigos,
        'quantidade': valorTotal,
        'valor_total': estado,
      };

  factory Encomenda.fromJson(Map<String, dynamic> data) {
    List artigos_json = data['artigos'];
    List<Artigo> lista_artigo = new List<Artigo>();

    for (int i = 0; i < artigos_json.length; i++) {
      lista_artigo.add(Artigo.fromJson(artigos_json[i]));
    }
    try {
      String datatime = data['dataHora'].toString().replaceAll('/', '-');
      return Encomenda(
          cliente: Cliente.fromJson(data['cliente']),
          vendedor: Usuario.fromJson(data['vendedor']),
          artigos: lista_artigo,
          valorTotal: double.parse(data['valorTotal'].toString()),
          estado: data['estado'],
          dataHora: new DateFormat("yyyy-MM-dd HH:mm:ss").parse(datatime),
          encomenda_id: data['encomenda_id']);
    } catch (e) {
      print('Ocorreu um erro');
      print(e.message);
      return null;
    }
  }

  List<Encomenda> parseUsuarios(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Encomenda>((json) => Encomenda.fromJson(json)).toList();
  }

  static Future<Cliente> getCliente(String cliente) async {
    Cliente cli = await DBProvider.db.getCliente(cliente);
    return cli;
  }

  static void getVendedor(String usuario) async {
    await DBProvider.db.getUsuario(usuario);
  }
}
