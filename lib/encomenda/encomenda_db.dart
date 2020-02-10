import 'package:primobile/cliente/cliente_modelo.dart';
import 'package:primobile/encomenda/encomendaItem_modelo.dart';
import 'package:primobile/usuario/usuario_modelo.dart';

import 'encomenda_modelo.dart';

class EncomendaDB {
  List<Encomenda> encomendas;
  List<EncomendaItem> encomendaItens;
  List<Cliente> clientes;
  List<Usuario> vendedores;

  EncomendaDB(
      {this.encomendas, this.encomendaItens, this.clientes, this.vendedores});
}
