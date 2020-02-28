import 'dart:convert';

class Usuario {
  String usuario;
  String nome;
  String senha;
  String documento;
  String perfil;

  Usuario({this.usuario, this.nome, this.senha, this.documento, this.perfil});


  factory Usuario.fromMap(Map<String, dynamic> json) => new Usuario(
        usuario: json['usuario'],
        nome: json['nome'],
        senha: json['senha'],
        documento: json['documento'],
        perfil: json['nivel'],    
      );

  Map<String, dynamic> toMap() => {
        'usuario': usuario,
        'nome': nome,
        'senha': senha,
        'documento': documento,
        'nivel': perfil,
      };


factory Usuario.fromJson(Map<String, dynamic> data) {
  
   return Usuario(
      usuario: data['usuario'],
      nome: data['nome'], 
      senha : data['senha'],
      documento : data['documento'],
      perfil: data['nivel'],
   );
}


  List<Usuario> parseUsuarios(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Usuario>((json) => Usuario.fromJson(json)).toList();
    
  }




}




