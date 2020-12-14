import 'dart:convert';

class Cliente {
  String cliente;
  String nome;  
  int numContrib;
  Endereco endereco;
  bool anulado;
  int tipoCred;
  double totalDeb;
  double encomendaPendente;
  double vendaNaoConvertida;
  double limiteCredito;

  Cliente({this.cliente, this.nome, this.numContrib = 0, this.endereco, this.anulado, this.tipoCred, this.totalDeb, this.encomendaPendente, this.vendaNaoConvertida, this.limiteCredito});


  factory Cliente.fromMap(Map<String, dynamic> json) => new Cliente(

        cliente: json['cliente'],
        nome: json['nome'],
      numContrib : int.parse(json['numContrib'].toString()),
        endereco: new Endereco(descricao: json['endereco']),
        anulado : json['anulado'] == 0 ? false : true,
        tipoCred:  json['tipoCred'],
        totalDeb:json['totalDeb'],
        encomendaPendente:  json['encomendaPendente'],
        vendaNaoConvertida:  json['vendaNaoConvertida'],
        limiteCredito:  json['limiteCredito']


      );

  Map<String, dynamic> toMap() => {
        'cliente': cliente,
        'nome': nome,
        'numContrib': numContrib,
        'endereco': endereco.descricao,
        'anulado': anulado,
        'tipoCred': tipoCred,
        'totalDeb': totalDeb,
        'encomendaPendente' : encomendaPendente,
        'vendaNaoConvertida': vendaNaoConvertida,
        'limiteCredito': limiteCredito


      };


factory Cliente.fromJson(Map<String, dynamic> data) {
    var numContrib = data['numContrib'] == ""  ? "0" : data['numContrib']  ;
   return Cliente(
      cliente: data['cliente'],
      nome: data['nome'], 
      numContrib : int.parse(numContrib),
      endereco : new Endereco(descricao: data['endereco']),
               anulado :  data['anulado'],
        tipoCred: data['tipoCred'],
        totalDeb: data['totalDeb'],
        encomendaPendente:  data['encomendaPendente'],
        vendaNaoConvertida: data['vendaNaoConvertida'],
                limiteCredito: data['limiteCredito']

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