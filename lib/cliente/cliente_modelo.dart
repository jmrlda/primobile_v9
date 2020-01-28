import 'dart:convert';

class Cliente {
  String cliente;
  String nome;  
  int numContrib;
  Endereco endereco;
  Cliente({this.cliente, this.nome, this.numContrib = 0, this.endereco});


  factory Cliente.fromMap(Map<String, dynamic> json) => new Cliente(

        cliente: json['cliente'],
        nome: json['nome'],
      numContrib : int.parse(json['numContrib'] == ""  ? 0 : json['numContrib']  ),
        endereco: new Endereco(descricao: json['endereco']),
      );

  Map<String, dynamic> toMap() => {
        'cliente': cliente,
        'nome': nome,
        'numContrib': numContrib,
        'endereco': endereco.descricao,
      };


factory Cliente.fromJson(Map<String, dynamic> data) {
    var numContrib = data['numContrib'] == ""  ? "0" : data['numContrib']  ;
   return Cliente(
      cliente: data['cliente'],
      nome: data['nome'], 
      numContrib : int.parse(numContrib),
      endereco : new Endereco(descricao: data['endereco']),
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
  String descricao;
  Endereco({this.pais, this.provincia, this.ruaAv, this.bairro, this.descricao});  
}