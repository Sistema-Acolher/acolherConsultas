import 'package:acolherconsultas/modules/pacientes/controllers/pacientesCadastradosProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PacientesCadastradosScreen extends StatefulWidget {
  const PacientesCadastradosScreen({super.key});

  @override
  State<PacientesCadastradosScreen> createState() => _PacientesCadastradosScreenState();
}

class _PacientesCadastradosScreenState extends State<PacientesCadastradosScreen> {
  @override
  void initState() {
    super.initState();
    
    context.read<PacientesCadastradosProvider>().getPacientes();
  }

  Future<void> _refreshPacientes() async {
    await context.read<PacientesCadastradosProvider>().getPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Pacientes Cadastrados"),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPacientes,
        child: ListView.builder(
          itemCount: context.watch<PacientesCadastradosProvider>().pacientes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Paciente: ${context.watch<PacientesCadastradosProvider>().pacientes[index].paciente.nome} -"),
              subtitle: Text("CPF: ${context.watch<PacientesCadastradosProvider>().pacientes[index].paciente.cpf}"),
              onTap: () {
                // Navigator.pushNamed(context);
              },
            );
          },
        ),
      ),
    );
  }
}