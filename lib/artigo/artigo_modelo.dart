import 'dart:convert';
import 'package:http/http.dart' as http;

class Artigo {
  String artigo;
  String descricao;
  double preco;
  int quantidade;
  double civa;
  double iva;
  String unidade;

  Artigo(
      {this.artigo,
      this.descricao,
      this.preco,
      this.quantidade,
      this.civa,
      this.iva,
      this.unidade});

  factory Artigo.fromMap(Map<String, dynamic> json) => new Artigo(
        artigo: json['artigo'],
        descricao: json['descricao'],
        preco: json['preco'].toDouble(),
        quantidade: json['quantidade'].toInt(),
        civa: json['civa']?.toDouble(),
        iva: json['iva']?.toDouble(),
        unidade: json['unidade'],
      );

  Map<String, dynamic> toMap() => {
        'artigo': artigo,
        'descricao': descricao,
        'preco': preco,
        'quantidade': quantidade,
        'civa': civa,
        'iva': iva,
        'unidade': unidade,
      };


factory Artigo.fromJson(Map<String, dynamic> data) {
   return Artigo(
      artigo: data['artigo'],
      descricao: data['descricao'], 
      preco : data['preco'].toDouble() ,
      quantidade : data['quantidade'].toInt(),
      civa: data['civa']?.toDouble()  ,
      iva: data['iva']?.toDouble()  ,
      unidade : data['unidade'],
   );
}


  List<Artigo> parseArtigos(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Artigo>((json) => Artigo.fromJson(json)).toList();
    
  }

  Future<List<Artigo>>    fetchArtigos() async {
    final response = await http.get('192.168.232.1:44390/api/Artigo/');

    if ( response.statusCode == 200 ) {
      print('dentro');
      print(response.body); 
      return parseArtigos(response.body);

    } else {
      throw Exception('Nao foi possivel obter artigos do RESP API');
    }
    
  }
}
