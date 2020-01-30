import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:primobile/artigo/artigo_modelo.dart';
import 'package:primobile/cliente/cliente_modelo.dart';
import 'package:primobile/encomenda/encomenda_modelo.dart';
import 'package:primobile/usuario/usuario_modelo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as _;

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static _.Database _database;

  Future<_.Database> get database async {
    if ( _database != null ) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join( documentsDirectory.path, "primobileDB.db");
    return await openDatabase(path, version: 1, onOpen: ( db ) {
    },
     onCreate: (_.Database db, int version) async {
        await db.execute(" CREATE TABLE Artigo (" 
          "artigo TEXT PRIMARY KEY, "
          "descricao TEXT, "
          "preco REAL, "
          "quantidadeStock REAL, "
          "iva REAL, "
          "civa REAL, "
          "unidade TEXT,"
          "pvp1 REAL,"
          "pvp1Iva INTEGER,"
          "pvp2 REAL,"
          "pvp2Iva INTEGER,"
          "pvp3 REAL,"
          "pvp3Iva INTEGER,"
          "pvp4 REAL,"
          "pvp4Iva INTEGER,"
          "pvp5 REAL,"
          "pvp5Iva INTEGER,"
          "pvp6 REAL,"
          "pvp6Iva INTEGER"

          ")"
      );

        await db.execute(" CREATE TABLE Cliente (" 
          "cliente TEXT PRIMARY KEY, "
          "nome TEXT, "
          "numContrib INTEGER, "
          "endereco TEXT "
          ")"
      );


      await db.execute(" CREATE TABLE usuario (" 
          "usuario INTEGER PRIMARY KEY, "
          "nome TEXT, "
          "senha TEXT, "
          "documento TEXT, "
          "nivel TEXT "

          ")"
      );



    });
  }

  

novoArtigo( Artigo artigo ) async {
  final db = await database;
  var res = await db.insert(
    "Artigo", 
    artigo.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,    
    );
  return res;
}

getArtigo( String artigo ) async {
  final db = await database;
  var res = await db.query('Artigo', where: "artigo = ?", whereArgs: [artigo]);

  
  return res.isEmpty ? Artigo.fromMap(res.first) : null;
}



getCliente( String cliente ) async {
  final db = await database;
  var res = await db.query('Cliente', where: "cliente = ?", whereArgs: [cliente]);  
  return res.isEmpty ? Artigo.fromMap(res.first) : null;
}

getUsuario( String usuario ) async {
  final db = await database;
  var res = await db.query('Usuario', where: "usuario = ?", whereArgs: [usuario]);
  
  return res.isEmpty ? Artigo.fromMap(res.first) : null;
}



getTodosArtigos() async {
  final db = await database;
  var res = await db.query('Artigo');
  List<Artigo> artigos = res.isNotEmpty ? res.map((c) => Artigo.fromMap(c)).toList() : [];

  return artigos;
}


getTodosUsuarios() async {
  final db = await database;
  var res = await db.query('Uusario');
  List<Usuario> usuarios = res.isNotEmpty ? res.map((c) => Usuario.fromMap(c)).toList() : [];

  return usuarios;
}


getTodosClientes() async {
  final db = await database;
  var res = await db.query('Cliente');
  List<Cliente> clientes = res.isNotEmpty ? res.map((c) => Cliente.fromMap(c)).toList() : [];

  return clientes;
}







actualizarArtigo( Artigo artigo ) async {
  final db = await database;
  var res = await db.update('Artigo', artigo.toMap(),
    where: "artigo = ?", whereArgs: [artigo.artigo]);
  return res;
}





actualizarUsuario( Usuario usuario ) async {
  final db = await database;
  var res = await db.update('Usuario', usuario.toMap(),
    where: "usuario = ?", whereArgs: [usuario.usuario]);
  return res;
}





actualizarCliente( Cliente cliente ) async {
  final db = await database;
  var res = await db.update('Artigo', cliente.toMap(),
    where: "cliente = ?", whereArgs: [cliente.cliente]);
  return res;
}



apagarArtigo ( String artigo ) async {
  final db = await database;
  db.delete('Artigo', where: 'artigo = ?', whereArgs: [artigo]);
}

apagarUsuario ( String usuario ) async {
  final db = await database;
  db.delete('Usuario', where: 'usuario = ?', whereArgs: [usuario]);
}

apagarCliente ( String cliente ) async {
  final db = await database;
  db.delete('Cliente', where: 'cliente = ?', whereArgs: [cliente]);
}


apagarTodosArtigo () async {
  final db = await database;
  db.rawDelete('Delete * from Artigo');
}


apagarTodosUsuarios () async {
  final db = await database;
  db.rawDelete('Delete * from Usuario');
}


apagarTodosClientes () async {
  final db = await database;
  db.rawDelete('Delete * from Cliente');
}



Future<dynamic> insertArtigo( Artigo artigo ) async {
  final db = await database;
  var res;
  try {
   res = await db.insert(
    "Artigo", 
    artigo.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,    
    );    
  } catch (e) {
    print('[insertArtigo] Ocorreu um erro');
    print(e.message);
  }

  return res;
}

insertCliente( Cliente cliente ) async {
  final db = await database;
  var res;
  try {
    
  res = await db.insert(
    "Cliente", 
    cliente.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,    
    );
        print('sucesso');

  } catch (e) {
    print('[insertCliente] Ocorreu um erro');
    print(e.message());

  }

  return res;
}

insertUsuario( Usuario usuario ) async {
  final db = await database;
  var res = await db.insert(
    "Usuario", 
    usuario.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,    
    );
  return res;
}



insertEncomenda( Encomenda encomenda ) async {
  final db = await database;
  var res = await db.insert(
    "Encomenda", 
    encomenda.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,    
    );
  return res;
}





}