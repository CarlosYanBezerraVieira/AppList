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
    _controllerConteudo.text = "";
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
          color: Colors.red,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.delete,
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
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.only(right: 5, left: 5, bottom: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _controllerText.text =
                                  _listaTarefas[index]["titulo"];
                              _controllerConteudo.text =
                                  _listaTarefas[index]["conteudo"];
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Editar Tarefa",
                                        style: TextStyle(color: Colors.indigo),
                                      ),
                                      content: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxHeight: 150),
                                              child: TextFormField(
                                                maxLines: null,
                                                controller: _controllerText,
                                                decoration: InputDecoration(
                                                  hintText: "Título",
                                                  hintStyle: TextStyle(
                                                      color: Colors.indigo[300],
                                                      fontSize: 20),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .indigo)),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxHeight: 150),
                                                child: TextFormField(
                                                  maxLines: null,
                                                  controller:
                                                      _controllerConteudo,
                                                  decoration: InputDecoration(
                                                    hintText: "Descrição",
                                                    hintStyle: TextStyle(
                                                        color:
                                                            Colors.indigo[300],
                                                        fontSize: 15),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .indigo)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.indigo),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ))),
                                          child: Text(
                                            "Cancelar",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _controllerText.text = "";
                                            _controllerConteudo.text = "";
                                          },
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      side: BorderSide(
                                                          color:
                                                              Colors.indigo)))),
                                          child: Text(
                                            "Salvar",
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              _listaTarefas[index]["titulo"] =
                                                  _controllerText.text;
                                              _listaTarefas[index]["conteudo"] =
                                                  _controllerConteudo.text;
                                              _salvarArquivo();
                                              _controllerText.text = "";
                                              _controllerConteudo.text = "";
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              _listaTarefas[index]["titulo"],
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Checkbox(
                              value: _listaTarefas[index]["realizada"],
                              onChanged: (valorAlterado) {
                                setState(() {
                                  _listaTarefas[index]["realizada"] =
                                      valorAlterado;
                                  _salvarArquivo();
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
          SizedBox(
            height: 30,
          ),
          Expanded(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
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
                    title: Text(
                      "Criar tarefa",
                      style: TextStyle(color: Colors.indigo),
                    ),
                    content: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 100),
                            child: TextFormField(
                              maxLines: null,
                              controller: _controllerText,
                              decoration: InputDecoration(
                                hintText: "Título",
                                hintStyle: TextStyle(
                                    color: Colors.indigo[300], fontSize: 20),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.indigo)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 100),
                              child: TextFormField(
                                maxLines: null,
                                controller: _controllerConteudo,
                                decoration: InputDecoration(
                                  hintText: "Descrição",
                                  hintStyle: TextStyle(
                                      color: Colors.indigo[300], fontSize: 15),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.indigo)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.indigo),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _controllerConteudo.text = "";
                          _controllerText.text = "";
                        },
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.indigo)))),
                        child: Text(
                          "Salvar",
                          style: TextStyle(color: Colors.indigo, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _salvarTarefa();
                        },
                      ),
                    ],
                  );
                });

            // Navigator.push(
            //   context, MaterialPageRoute(builder: (context) => Tarefa()));
          }),
      //bottomNavigationBar: BottomAppBar(),
    );
  }
}
