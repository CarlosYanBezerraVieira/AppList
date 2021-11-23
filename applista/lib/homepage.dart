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
  TextEditingController _controllerTarefa = TextEditingController();
  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvarTarefa() {
    String textoDigitado = _controllerTarefa.text;
    //criar dados
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = textoDigitado;
    tarefa["realizada"] = false;
    setState(() {
      _listaTarefas.add(tarefa);
    });
    _salvarArquivo();
    _controllerTarefa.text = "";
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
            itemCount: _listaTarefas.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                  title: Text(_listaTarefas[index]["titulo"]),
                  value: _listaTarefas[index]["realizada"],
                  onChanged: (valorAlterado) {
                    setState(() {
                      _listaTarefas[index]["realizada"] = valorAlterado;
                      _salvarArquivo();
                    });
                  });
              //  return ListTile(
              //
              //  );
            },
          ))
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
                  content: TextField(
                    controller: _controllerTarefa,
                    decoration: InputDecoration(labelText: "Digite sua tarefa"),
                    onChanged: (text) {},
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
