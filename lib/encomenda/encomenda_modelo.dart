

import 'dart:convert';

import 'package:primobile/artigo/artigo_modelo.dart';
import 'package:primobile/cliente/cliente_modelo.dart';
import 'package:primobile/usuario/usuario_modelo.dart';

class Encomenda {
  String id;
  Cliente cliente;
  Usuario vendedor;
  List<Artigo> artigos;
  double valorTotal;
  String estado;
  DateTime dataHora;


Encomenda({this.cliente, this.vendedor, this.artigos, this.valorTotal, this.estado, this.dataHora});


  factory Encomenda.fromMap(Map<String, dynamic> json) => new Encomenda(
        cliente: json['cliente'],
        vendedor: json['nome'],
        artigos: json['artigos'],
        valorTotal: json['valor'],
        estado: json['estado'],
        dataHora: json['data_hora'],

      );

  Map<String, dynamic> toMap() => {
        'cliente': cliente.cliente,
        'vendedor': vendedor.usuario,
        // 'artigos': artigos,
        'valor':valorTotal,
        'estado':estado,
        'data_hora':dataHora.toString(),

      };

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





}

