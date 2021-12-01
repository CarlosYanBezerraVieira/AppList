import 'package:flutter/material.dart';

class FloatingButtom extends StatelessWidget {
  const FloatingButtom(
      {Key? key,
      required this.controllerText,
      required this.controllerConteudo,
      required this.salvarTarefa})
      : super(key: key);
  final TextEditingController controllerText;
  final TextEditingController controllerConteudo;
  final Function salvarTarefa;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
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
                            controller: controllerText,
                            decoration: InputDecoration(
                              hintText: "Título",
                              hintStyle: TextStyle(
                                  color: Colors.indigo[300], fontSize: 20),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.indigo)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 100),
                            child: TextFormField(
                              maxLines: null,
                              controller: controllerConteudo,
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        controllerConteudo.text = "";
                        controllerText.text = "";
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.indigo)))),
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Colors.indigo, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        salvarTarefa();
                      },
                    ),
                  ],
                );
              });

          // Navigator.push(
          //   context, MaterialPageRoute(builder: (context) => Tarefa()));
        });
  }
}
