import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/artigo/artigo_modelo.dart';
import 'package:primobile/cliente/cliente_modelo.dart';
import 'package:primobile/encomenda/regraPrecoDesconto_modelo.dart';
import 'package:primobile/usuario/usuario_modelo.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:intl/intl.dart';

import '../util.dart';

class Encomenda {
  int id;
  Cliente cliente;
  Usuario vendedor;
  List<Artigo> artigos;
  List artigosJson = List();
  double valorTotal;
  String estado;
  DateTime dataHora;
  String encomenda_id;
  String latitude;
  String longitude;
  String assinaturaImagemBuffer;
  List<RegraPrecoDesconto> regrasPreco =  List<RegraPrecoDesconto>();
    List regrasPreco_json =  List();


  Encomenda(
      {this.id,
      this.cliente,
      this.vendedor,
      this.artigos,
      this.valorTotal,
      this.estado,
      this.dataHora,
      this.encomenda_id,
      this.latitude,
      this.longitude,
      this.assinaturaImagemBuffer,
      this.regrasPreco 
      });

  factory Encomenda.fromMap(Map<String, dynamic> json) {
    Usuario usuario;
        // senha: 'rere');

    Cliente cliente = Cliente(cliente: json['cliente']);
    Future<Map<String, dynamic>> sessao = SessaoApiProvider.read();
    sessao.then((value) => {});
    return new Encomenda(
        id: json['encomenda'],
        cliente: cliente,
        vendedor: usuario,
        artigos: List<Artigo>(),
        valorTotal: json['valor'],
        estado: json['estado'],
        dataHora: DateTime.tryParse(json['data_hora']),
        encomenda_id: json['encomenda_id'],
                latitude: json['latitude'],
        longitude: json['longitude'],
        assinaturaImagemBuffer: json['assinaturaImagemBuffer'],        
        regrasPreco : json['regrasPreco']);

  }

  factory Encomenda.fromMap_2(Map<String, dynamic> json, Cliente cliente) {
    Usuario usuario ;
    // Cliente cliente = Cliente(cliente: json['cliente']);
    return new Encomenda(
        id: int.parse(json['encomenda']),
        cliente: cliente,
        vendedor: usuario,
        artigos: List<Artigo>(),
        valorTotal: json['valor'],
        estado: json['estado'],
        dataHora: DateFormat('dd-MM-yyyy HH:mm:ss')
            .parse(json['data_hora'].toString()),
        encomenda_id: json['encomenda_id'],
                        latitude: json['latitude'],
        longitude: json['longitude'],
        assinaturaImagemBuffer: json['assinaturaImagemBuffer'],
                regrasPreco : json['regrasPreco']);

  }

  Map<String, dynamic> toMap() => {
        'cliente': cliente.cliente,
        'vendedor': vendedor.usuario,
        // 'artigos': artigos,
        'valor': valorTotal,
        'estado': estado,
        'data_hora': dataHora.toString(),
        'encomenda_id': this.encomenda_id,
                        'latitude':latitude,
        'longitude':longitude,
        'assinaturaImagemBuffer': assinaturaImagemBuffer,
                // 'regrasPreco' : regrasPreco.

      };

  Map<String, dynamic> toMapApi() {
    int i = 0;
    if (artigos != null) {
      artigos.forEach((element) {
        artigosJson.add(element.toMap());
        regrasPreco_json.add(regrasPreco[i++].toMap());
      });
    } else {
      artigosJson = [];
      regrasPreco_json = [];
    }

    return {
      'cliente': cliente.toMap(),
      'vendedor': vendedor.toMap(),
      'artigos': artigosJson,
      'valorTotal': valorTotal,
      'estado': estado,
      'dataHora': dataHora.toString(),
      'encomenda_id': this.encomenda_id,
      'latitude':latitude,
      'longitude':longitude,
      'assinaturaImagemBuffer': assinaturaImagemBuffer,
       'regras' : regrasPreco_json

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
    List artigosJson = data['artigos'];
    List regra_json = data['regras'];

    List<Artigo> lista_artigo = new List<Artigo>();
    List<RegraPrecoDesconto> lista_regra = new List<RegraPrecoDesconto>();

    for (int i = 0; i < artigosJson.length; i++) {
      lista_artigo.add(Artigo.fromJson(artigosJson[i]));
      lista_regra.add(RegraPrecoDesconto.fromJson(regra_json[i]));
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
          encomenda_id: data['encomenda_id'],
                       latitude: data['latitude'],
        longitude: data['longitude'],
        assinaturaImagemBuffer: data['assinaturaImagemBuffer'],
                        regrasPreco : lista_regra


          );
    } catch (e) {
      print('Ocorreu um erro');
      print(e.message);
      return Encomenda();
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

  Future<Position> setLocalizacao() async {
    Position posicao;
    try {
     posicao = await  GetLocalizacaoActual();
    if ( posicao != null) {
      this.latitude = posicao.latitude.toString();
      this.longitude = posicao.longitude.toString();

    } else {
    
      throw Exception("Não foi possivel encontrar a localização");
    }

    } catch(ex) {
      this.latitude = "0";
      this.longitude = "0";
    }

      // this.latitude = "0";
      // this.longitude = "0";
    return posicao;
  }
}
