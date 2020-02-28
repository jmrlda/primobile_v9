

import 'dart:convert';

import 'package:primobile/Database/Database.dart';
import 'package:primobile/artigo/artigo_modelo.dart';
import 'package:primobile/cliente/cliente_modelo.dart';
import 'package:primobile/usuario/usuario_modelo.dart';

class Encomenda {
  String id;
  Cliente cliente;
  Usuario vendedor;
  List<Artigo> artigos;
  List artigos_json = List();
  double valorTotal;
  String estado;
  DateTime dataHora;


Encomenda({this.id, this.cliente, this.vendedor, this.artigos, this.valorTotal, this.estado, this.dataHora});


  factory Encomenda.fromMap(Map<String, dynamic> json)   {
    
    Usuario usuario = Usuario(usuario: '276D1CB0-6C8F-4078-8904-2E119D13B4FB', nome: 'dercio', perfil: 'admin', documento: 'vd', senha: 'rere');
        Cliente cliente = Cliente(cliente: json['cliente']);

     return new Encomenda(
         id: json['encomenda'].toString(),
        cliente: cliente,
        vendedor: usuario,
        artigos: List<Artigo>(),
        valorTotal: json['valor'],
        estado: json['estado'],
        dataHora: DateTime.tryParse(json['data_hora']),

      );}


  factory Encomenda.fromMap_2(Map<String, dynamic> json, Cliente cliente)   {
    Usuario usuario = Usuario(usuario: '276D1CB0-6C8F-4078-8904-2E119D13B4FB', nome: 'dercio', perfil: 'admin', documento: 'vd', senha: 'rere');
    // Cliente cliente = Cliente(cliente: json['cliente']);
     return new Encomenda(
         id: json['encomenda'].toString(),
        cliente: cliente,
        vendedor: usuario,
        artigos: List<Artigo>(),
        valorTotal: json['valor'],
        estado: json['estado'],
        dataHora: DateTime.tryParse(json['data_hora']),

      );}

  Map<String, dynamic> toMap() => {
        'cliente': cliente.cliente,
        'vendedor': vendedor.usuario,
        // 'artigos': artigos,
        'valor':valorTotal,
        'estado':estado,
        'data_hora':dataHora.toString(),

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
        'valorTotal':valorTotal,
        'estado':estado,
        'data_hora':dataHora.toString(),

      };
  }

  Map<String, dynamic> ItemtoMap() => {
        'encomenda': id,
        'artigo': vendedor.usuario,
        'valor_unit': artigos,
        'quantidade':valorTotal,
        'valor_total':estado,
      };

      


factory Encomenda.fromJson(Map<String, dynamic> data) {
   return Encomenda(
   cliente: data['cliente'],
        vendedor: data['nome'],
        artigos: data['artigos'],
        valorTotal: data['valor'],
        estado: data['estado'],
        dataHora: data['data_hora'],

   );
}


  List<Encomenda> parseUsuarios(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Encomenda>((json) => Encomenda.fromJson(json)).toList();
    
  }

  static Future<Cliente>  getCliente(String cliente ) async {
    Cliente cli = await DBProvider.db.getCliente(cliente);
    print('cliente vendedor');
    print(cli);
    return cli;
  }


  static void  getVendedor( String usuario ) async {
    Usuario user = await DBProvider.db.getUsuario(usuario);
    print('user vendedor');
    print(user);
  }



  static Future<Encomenda> fromMap_1(Map<String, dynamic> json)   async {
    
    Usuario usuario = Usuario(usuario: '276D1CB0-6C8F-4078-8904-2E119D13B4FB', nome: 'dercio', perfil: 'admin', documento: 'vd', senha: 'rere');
        Cliente cliente = await DBProvider.db.getCliente(json['cliente']);

     return new Encomenda(
         id: json['encomenda'].toString(),
        cliente: cliente,
        vendedor: usuario,
        artigos: List<Artigo>(),
        valorTotal: json['valor'],
        estado: json['estado'],
        dataHora: DateTime.tryParse(json['data_hora']),

      );}


}

