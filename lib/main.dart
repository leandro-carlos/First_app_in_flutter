// ignore_for_file: prefer_const_constructors, camel_case_types
import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple, accentColor: Colors.purple[300]),
        ),
        home: listTransfer()),
  );
}

class changePag extends StatelessWidget {
  TextEditingController controladorConta = TextEditingController();
  TextEditingController controladorValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando Transferências'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: controladorConta,
              rotulo: 'Digite sua conta',
              dica: '12345-6',
              icone: null,
            ),
            Editor(
              controlador: controladorValor,
              rotulo: 'Digite o valor da transferencia',
              dica: '1000,00',
              icone: Icons.monetization_on,
            ),
            ElevatedButton(
                child: Text('Confirmar Transferencia!'),
                onPressed: () {
                  final nConta = controladorConta.text;
                  final nValor = controladorValor.text;

                  final int? numConta = int.tryParse(nConta);
                  final double? numValor = double.tryParse(nValor);

                  if (numConta != null && numValor != null) {
                    final transferenciaCriada =
                        Transferencia(numConta, numValor);
                    Navigator.pop(context, transferenciaCriada);
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //   content: Text('$transferenciaCriada'),
                    // ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Por favor insira os campos pra poder efetuar a transação!'),
                    ));
                  }
                })
          ],
        ),
      ),
    );
  }
}

class Transferencia {
  final int numConta;
  final double numValor;

  Transferencia(this.numConta, this.numValor);

  @override
  String toString() {
    // TODO: implement toString
    return 'Efetuamos uma transação de valor $numValor para a conta de número $numConta';
  }
}

class itemTransferencia extends StatelessWidget {
  final Transferencia transferencia;
  itemTransferencia(this.transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          title: Text(transferencia.numConta.toString()),
          subtitle: Text(transferencia.numValor.toString())),
    );
  }
}

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;

  Editor({this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        decoration: InputDecoration(
          labelText: rotulo,
          hintText: dica,
          icon: icone != null ? (Icon(icone)) : null,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class listTransfer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return listTransferstate();
  }
}

class listTransferstate extends State<listTransfer> {
  // final int contador = 0;F
  final List<Transferencia> transferencias = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Transferencias'),
      ),
      body: ListView.builder(
        itemCount: transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = transferencias[indice];
          return itemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future<Transferencia?> future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return changePag();
          }));
          future.then((transferenciaRecebida) {
            int contador = 0;
            setState(() {
              contador++;
            });
            debugPrint('$transferenciaRecebida');
            if (transferenciaRecebida != null) {
              transferencias.add(transferenciaRecebida);
            }
            debugPrint('Chegou no then do futuro');
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
