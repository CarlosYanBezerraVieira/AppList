import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _listaTarefas = [];
  Map<String, dynamic> _ultimoTarefaRemovida = Map();
  TextEditingController _controllerText = TextEditingController();
  TextEditingController _controllerConteudo = TextEditingController();
  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvarTarefa() {
    String textoDigitado = _controllerText.text;
    String descricao = _controllerConteudo.text;
    //criar dados
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = textoDigitado;
    tarefa["realizada"] = false;
    tarefa["conteudo"] = descricao;
    //criar novo campo descrição aqui
    setState(() {
      _listaTarefas.add(tarefa);
    });
    _salvarArquivo();
    _controllerText.text = "";
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();

    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
    var arquivo = await _getFile();
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _lerArquivo().then((dados) {
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
  }

  Widget criarItemLista(context, index) {
    return Dismissible(
        onDismissed: (direction) {
          //recuperar ultimo item excluido
          _ultimoTarefaRemovida = _listaTarefas[index];

          //remover tarefa
          setState(() {
            _listaTarefas.removeAt(index);
            _salvarArquivo();
          });

          final snackbar = SnackBar(
              action: SnackBarAction(
                  label: "Desfazer",
                  onPressed: () {
                    //inserindo novamente o item
                    setState(() {
                      _listaTarefas.insert(index, _ultimoTarefaRemovida);
                      _salvarArquivo();
                    });
                  }),

              //  backgroundColor: Colors.grey,
              content: Text("Tarefa removida"));
          Scaffold.of(context).showSnackBar(snackbar);
        },
        background: Container(
          color: Colors.green,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.edit,
                color: Colors.white,
              )
            ],
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
              )
            ],
          ),
        ),
        direction: DismissDirection.horizontal,
        key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_listaTarefas[index]["titulo"]),
                    Checkbox(
                        value: _listaTarefas[index]["realizada"],
                        onChanged: (valorAlterado) {
                          setState(() {
                            _listaTarefas[index]["realizada"] = valorAlterado;
                            _salvarArquivo();
                          });
                        }),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    //var height = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Lista De Tarefas"),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  // physics: BouncingScrollPhysics(),
                  itemCount: _listaTarefas.length,
                  itemBuilder: criarItemLista))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Criar tarefa"),
                  content: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _controllerText,
                          decoration: InputDecoration(labelText: "Titulo"),
                          onChanged: (text) {},
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextField(
                            controller: _controllerConteudo,
                            decoration:
                                InputDecoration(labelText: "Descrição "),
                            onChanged: (text) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancelar")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _salvarTarefa();
                          //salvar
                        },
                        child: Text("Salvar"))
                  ],
                );
              });
        },
      ),
      //bottomNavigationBar: BottomAppBar(),
    );
  }
}
