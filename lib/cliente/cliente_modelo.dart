import 'dart:convert';

class Cliente {
  String cliente;
  String nome;  
  int numContrib;
  Endereco endereco;
  Cliente({this.cliente, this.nome, this.numContrib, this.endereco});


  factory Cliente.fromMap(Map<String, dynamic> json) => new Cliente(
        cliente: json['cliente'],
        nome: json['nome'],
        numContrib: json['numContrib'],
        endereco: json['endereco'],
      );

  Map<String, dynamic> toMap() => {
        'cliente': cliente,
        'nome': nome,
        'numContrib': numContrib,
        'endereco': endereco.ruaAv,
      };


factory Cliente.fromJson(Map<String, dynamic> data) {
   return Cliente(
      cliente: data['cliente'],
      nome: data['nome'], 
      numContrib : data['numContrib'],
      endereco : data['endereco'],
   );
}


  List<Cliente> parseUsuarios(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Cliente>((json) => Cliente.fromJson(json)).toList();
    
  }






}


class Endereco {
  String pais;
  String provincia;
  String ruaAv;
  String bairro;

  Endereco({this.pais, this.provincia, this.ruaAv, this.bairro});  
}