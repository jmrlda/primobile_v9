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
  String imagemBuffer;

  Cliente({this.cliente, this.nome, this.numContrib = 0, this.endereco, this.anulado, this.tipoCred, this.totalDeb, this.encomendaPendente, this.vendaNaoConvertida, this.limiteCredito, this.imagemBuffer});


  factory Cliente.fromMap(Map<String, dynamic> json) => new Cliente(

        cliente: json['cliente'],
        nome: json['nome'],
      numContrib : int.parse(json['numContrib'].toString().replaceAll(" ", "")),
        endereco: new Endereco(descricao: json['endereco']),
        anulado : json['anulado'] == 0 ? false : true,
        tipoCred:  json['tipoCred'],
        totalDeb:json['totalDeb'],
        encomendaPendente:  json['encomendaPendente'],
        vendaNaoConvertida:  json['vendaNaoConvertida'],
        limiteCredito:  json['limiteCredito'],
            // imagemBuffer: json['imagemBuffer']
         imagemBuffer: json['imagemBuffer'].length <=0 ?  null :   json['imagemBuffer']


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
        'limiteCredito': limiteCredito,
         'imagemBuffer': imagemBuffer


      };

 Map<String, dynamic> imagemToMap() => {
    'cliente': this.cliente,
    'imagemBuffer': this.imagemBuffer
  };
factory Cliente.fromJson(Map<String, dynamic> data) {
    String numContrib = data['numContrib'] == ""  ? "0" : data['numContrib']  ;
    numContrib = numContrib.replaceAll(" ", "");
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
                limiteCredito: data['limiteCredito'],
        // imagemBuffer: data['imagemBuffer']
         imagemBuffer: data['imagemBuffer'] == null ?  null :   data['imagemBuffer']

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