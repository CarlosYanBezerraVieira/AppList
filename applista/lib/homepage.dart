import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _listaTarefas = ["Acordar", "Comer", "Academia", "Programar"];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;

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
              return ListTile(
                title: Text(_listaTarefas[index]),
              );
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
                    decoration: InputDecoration(labelText: "Digite sua tarefa"),
                    onChanged: (text) {},
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancelar")),
                    TextButton(
                        onPressed: () {
                          //salvar
                          TextButton(onPressed: () {}, child: Text("Cancelar"));
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
