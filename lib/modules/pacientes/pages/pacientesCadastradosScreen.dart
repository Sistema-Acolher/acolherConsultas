import 'package:acolherconsultas/modules/pacientes/controllers/pacientesCadastradosProvider.dart';
import 'package:acolherconsultas/modules/pacientes/models/cadastroPaciente.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// A classe PacientesCadastradosScreen é a tela que exibe a lista de pacientes cadastrados.
class PacientesCadastradosScreen extends StatefulWidget {
  const PacientesCadastradosScreen({super.key});

  @override
  State<PacientesCadastradosScreen> createState() => _PacientesCadastradosScreenState();
}

// A classe _PacientesCadastradosScreenState é a classe que representa o estado da tela de lista de pacientes cadastrados.
class _PacientesCadastradosScreenState extends State<PacientesCadastradosScreen> {

  // O método initState é chamado quando o estado do widget é inserido na árvore de widgets.
  // Isto é, assim que a tela é construída/chamada.
  @override
  void initState() {
    super.initState();
    context.read<PacientesCadastradosProvider>().getPacientes();
  }

  // O método _refreshPacientes é responsável por atualizar a lista de pacientes cadastrados.
  Future<void> _refreshPacientes() async {
    await context.read<PacientesCadastradosProvider>().getPacientes();
  }

  // O método build é responsável por construir a interface da tela de lista de pacientes cadastrados.
  @override
  Widget build(BuildContext context) {
    List<CadastroPaciente> pacientes = Provider.of<PacientesCadastradosProvider>(context).pacientes;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Pacientes Cadastrados"),
      ),
      // O RefreshIndicator é um widget que implementa um indicador de atualização. 
      // Ao se fazer o gesto de 'puxar para baixo', a função onRefresh é chamada e a lista é atualizada.
      body: RefreshIndicator(
        onRefresh: _refreshPacientes,
        // O ListView.builder é um widget que implementa uma lista de widgets filhos, onde os itens são construídos a partir de uma lista de dados.
        child: ListView.builder(
          // O itemCount é uma propriedade que define o número de itens da lista.
          itemCount: pacientes.length,
          // O itemBuilder é uma propriedade que define a função que constrói os itens da lista.
          itemBuilder: (context, index) {
            // O ListTile é um widget que implementa um item de lista genérico.
            return ListTile(
              // Informa o nome e o CPF do paciente de acordo com o index da lista de pacientes do provedor.
              title: Text("Paciente: ${pacientes[index].paciente.nome} -"),
              subtitle: Text("CPF: ${pacientes[index].paciente.cpf}"),
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