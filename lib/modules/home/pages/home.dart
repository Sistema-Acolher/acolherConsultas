import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            final FirebaseFirestore firestore = FirebaseFirestore.instance;
            firestore.collection("consultas").add({
              "data": DateTime.now(),
              "paciente": "João da Silva",
              "medico": "Dr. José",
              "especialidade": "Cardiologia",
              "status": "Agendada"
            });
          },
          child: Text("Teste - Adicionar Consulta")
        ),
      ),
    );
  }
}