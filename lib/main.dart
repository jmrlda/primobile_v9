import 'package:flutter/material.dart';
import 'package:primobile/artigo/artigo_page.dart';
import 'package:primobile/artigo/artigo_selecionar_page.dart';

import 'package:primobile/cliente/cliente_page.dart';
import 'package:primobile/cliente/cliente_page_selecionar.dart';
import 'package:primobile/encomenda/encomenda_lista_confirmacao.dart';
import 'package:primobile/encomenda/encomenda_lista_page.dart';
import 'package:primobile/encomenda/encomenda_nova_page.dart';
import 'package:primobile/encomenda/encomenda_sucesso_page.dart';
import 'package:primobile/menu/menuPage.dart';
import 'package:primobile/sessao/loginPage.dart';
import 'package:primobile/usuario/usuario_nova_senha.dart';
import 'package:primobile/util.dart';

import 'encomenda/assinatura.dart';


void main() => runApp(
  MaterialApp(
    theme: ThemeData(primaryColor: Colors.red, accentColor: Colors.yellowAccent),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': ( context ) => LoginPage(),
      '/menu': ( context ) => MenuPage(),
      '/encomenda_novo': ( context ) => EncomendaPage(),
      '/encomenda_lista': ( context ) => EncomendaListaPage(),
      '/encomenda_lista_confirmacao': ( context ) => EncomendaListaConfirmacaoPage(),
      '/encomenda_sucesso': ( context ) => EncomendaSucessoPage(),
      '/cliente_lista': ( context ) => ClientePage(),
      '/cliente_selecionar_lista': ( context ) => ClienteSelecionarPage(),
      '/artigo_lista': ( context ) => ArtigoPage(),
      '/artigo_selecionar_lista': ( context ) => ArtigoSelecionarPage(),
      '/alterar_senha': ( context ) => AlterarSenhaPage(),
      '/sucesso': ( context ) => SucessoPage(),
      '/assinatura': ( context ) => AssinaturaDigital(),


      // '/artigo_lista_selecionar': ( context ) => Artigo(),
      
    },
    // home: LoginPage(),
  )
);
