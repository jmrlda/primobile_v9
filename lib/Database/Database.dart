import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:primobile/artigo/artigo_modelo.dart';
import 'package:primobile/cliente/cliente_modelo.dart';
import 'package:primobile/encomenda/encomendaItem_modelo.dart';
import 'package:primobile/encomenda/encomenda_modelo.dart';
import 'package:primobile/usuario/usuario_modelo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as _;

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static _.Database _database;

  Future<_.Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "primobileDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (_.Database db, int version) async {
      try {
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
            ")");

        await db.execute(" CREATE TABLE Cliente ("
            "cliente TEXT PRIMARY KEY, "
            "nome TEXT, "
            "numContrib INTEGER, "
            "endereco TEXT "
            ")");

        await db.execute(" CREATE TABLE Usuario ("
            "usuario TEXT, "
            "nome TEXT, "
            "senha TEXT, "
            "documento TEXT, "
            "nivel TEXT "
            ")");

        await db.execute(" CREATE TABLE Encomenda ("
            "encomenda INTEGER PRIMARY KEY AUTOINCREMENT, "
            "cliente TEXT, "
            "vendedor TEXT, "
            "data_hora TEXT, "
            "valor REAL,"
            "documento TEXT,"
            "estado TEXT"
            ")");

        await db.execute(" CREATE TABLE EncomendaItem ("
            "encomenda INTEGER , "
            "artigo TEXT, "
            "valor_unit REAL, "
            "quantidade REAL, "
            "valor_total REAL, "
            "constraint encomenda_fk foreign key (encomenda) references Encomenda(encomenda), "
            "constraint artigo_fk foreign key (artigo) references Artigo(artigo) , "
            "constraint itemEncomenda_pk primary key (encomenda, artigo)"
            ")");
      } catch (e) {
        print('[initDB] Erro: $e.message');
      }
    });
  }

  novoArtigo(Artigo artigo) async {
    final db = await database;
    var res = await db.insert(
      "Artigo",
      artigo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return res;
  }

  Future<Artigo> getArtigo(String artigo) async {
    final db = await database;
    var res =
        await db.query('Artigo', where: "artigo = ?", whereArgs: [artigo]);

    return res.isEmpty ? Artigo.fromMap(res.first) : Artigo;
  }

  Future<Cliente> getCliente(String cliente) async {
    final db = await database;
    var res =
        await db.query('Cliente', where: "cliente = ?", whereArgs: [cliente]);
    print("teste $res");
    return res.length > 0 ? Cliente.fromMap(res[0]) : Cliente();
  }

  Future<Usuario> getUsuario(String usuario) async {
    final db = await database;
    var res =
        await db.query('Usuario', where: "usuario = ?", whereArgs: [usuario]);

    return res.length > 0 ? Usuario.fromMap(res[0]) : Usuario();
  }

  Future<Usuario> getUsuarioByName(String nome) async {
    final db = await database;
    var res = await db.query('Usuario', where: "nome = ?", whereArgs: [nome]);

    return res.length > 0 ? Usuario.fromMap(res[0]) : Usuario();
  }

  Future<Usuario> login(String nome_email, String senha) async {
    final db = await database;
    var res = await db.query('Usuario',
        where: "nome = ? and senha = ?", whereArgs: [nome_email, senha]);

    return res.length > 0 ? Usuario.fromMap(res[0]) : null;
  }

  getTodosArtigos() async {
    final db = await database;
    var res = await db.query('Artigo');
    List<Artigo> artigos =
        res.isNotEmpty ? res.map((c) => Artigo.fromMap(c)).toList() : [];

    return artigos;
  }

  getTodosUsuarios() async {
    final db = await database;
    var res = await db.query('Usuario');
    List<Usuario> usuarios =
        res.isNotEmpty ? res.map((c) => Usuario.fromMap(c)).toList() : [];

    return usuarios;
  }

  Future<List<Cliente>> getTodosClientes() async {
    final db = await database;
    var res = await db.query('Cliente');
    List<Cliente> clientes =
        res.isNotEmpty ? res.map((c) => Cliente.fromMap(c)).toList() : [];

    return clientes;
  }

  dynamic getTodasEncomendas() async {
    final db = await database;
    var res;
    res = await db.query('Encomenda');
    var enc =
        res.isNotEmpty ? res.map((c) => Encomenda.fromMap(c)).toList() : [];

    return enc;
  }

  Future<Encomenda> getEncomenda(int encomenda) async {
    final db = await database;
    var res =
        await db.query('Encomenda', where: "id = ?", whereArgs: [encomenda]);

    return res.isEmpty ? Encomenda.fromMap(res.first) : Encomenda();
  }

  dynamic getTodasEncomendaItens() async {
    final db = await database;
    var res = await db.query('EncomendaItem');

    var enc =
        res.isNotEmpty ? res.map((c) => EncomendaItem.fromMap(c)).toList() : [];

    return enc;
  }

  Future<List<EncomendaItem>> getEncomendaItem(int encomenda) async {
    final db = await database;
    var res = await db
        .query('EncomendaItem', where: "encomenda = ?", whereArgs: [encomenda]);

    List<EncomendaItem> enc =
        res.isNotEmpty ? res.map((c) => EncomendaItem.fromMap(c)).toList() : [];

    return enc;
  }

  actualizarArtigo(Artigo artigo) async {
    final db = await database;
    var res = await db.update('Artigo', artigo.toMap(),
        where: "artigo = ?", whereArgs: [artigo.artigo]);
    return res;
  }

  actualizarUsuario(Usuario usuario) async {
    final db = await database;
    var res = await db.update('Usuario', usuario.toMap(),
        where: "usuario = ?", whereArgs: [usuario.usuario]);
    return res;
  }

  actualizarCliente(Cliente cliente) async {
    final db = await database;
    var res = await db.update('Artigo', cliente.toMap(),
        where: "cliente = ?", whereArgs: [cliente.cliente]);
    return res;
  }

  apagarArtigo(String artigo) async {
    final db = await database;
    db.delete('Artigo', where: 'artigo = ?', whereArgs: [artigo]);
  }

  apagarUsuario(String usuario) async {
    final db = await database;
    db.delete('Usuario', where: 'usuario = ?', whereArgs: [usuario]);
  }

  apagarCliente(String cliente) async {
    final db = await database;
    db.delete('Cliente', where: 'cliente = ?', whereArgs: [cliente]);
  }

  apagarTodosArtigo() async {
    final db = await database;
    db.rawDelete('Delete * from Artigo');
  }

  apagarTodosUsuarios() async {
    final db = await database;
    db.rawDelete('Delete * from Usuario');
  }

  apagarTodosClientes() async {
    final db = await database;
    db.rawDelete('Delete * from Cliente');
  }

  Future<dynamic> insertArtigo(Artigo artigo) async {
    final db = await database;
    var res;
    try {
      res = await db.insert(
        "Artigo",
        artigo.toMapDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('[insertArtigo] Ocorreu um erro');
      print(e.message);
    }

    return res;
  }

  insertCliente(Cliente cliente) async {
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

  insertUsuario(Usuario usuario) async {
    try {
      
    final db = await database;
    var res = await db.insert(
      "Usuario",
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return res;
    } catch (e) {

      throw e;
    }

  }

  insertEncomenda(Encomenda encomenda) async {

    try {
      
    final db = await database;
    var res = await db.insert(
      "Encomenda",
      encomenda.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print('sucesso encomenda $res');

    insertEncomendaItem(encomenda.artigos, res);

    } catch (e) {

      throw e;
    }


  }

  void insertEncomendaItem(List<Artigo> artigos, int encomendaPk) async {
    try {
      final db = await database;
      artigos.forEach((artigo) async {
        var res = await db.insert(
          "EncomendaItem",
          {
            'encomenda': encomendaPk,
            'artigo': artigo.artigo,
            'valor_unit': artigo.preco,
            'quantidade': artigo.quantidade,
            'valor_total': artigo.preco * artigo.quantidade
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print('sucesso encomenda item $res');
      });
    } catch (e) {
      throw e;
    }
  }
}
