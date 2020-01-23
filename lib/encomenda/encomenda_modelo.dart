

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
        valorTotal: json['valorTotal'],
        estado: json['estado'],
        dataHora: json['dataHora'],

      );

  Map<String, dynamic> toMap() => {
        'cliente': cliente,
        'vendedor': vendedor,
        'artigos': artigos,
        'valorTotal':valorTotal,
        'estado':estado,
        'dataHora':dataHora,

      };


factory Encomenda.fromJson(Map<String, dynamic> data) {
   return Encomenda(
   cliente: data['cliente'],
        vendedor: data['nome'],
        artigos: data['artigos'],
        valorTotal: data['valorTotal'],
        estado: data['estado'],
        dataHora: data['dataHora'],

   );
}


  List<Encomenda> parseUsuarios(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Encomenda>((json) => Encomenda.fromJson(json)).toList();
    
  }





}

