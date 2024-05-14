import 'package:acolherconsultas/modules/pacientes/states/pacienteCadastradoState.dart';
import 'package:acolherconsultas/modules/pacientes/models/cadastroPaciente.dart';
import 'package:acolherconsultas/shared/components/list/Consulta.dart';
import 'package:acolherconsultas/shared/components/list/listaComIconeAcolher.dart';
import 'package:acolherconsultas/shared/components/list/listaSemIconeAcolher.dart';
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
    // Criando uma lista de consultas para teste
    List<Consulta> consultas = [
    Consulta(
      responsavelId: '1',
      pacienteId: '1',
      dataHorario: DateTime.now(),
      estado: 'Agendada',
    ),
    Consulta(
      responsavelId: '2',
      pacienteId: '2',
      dataHorario: DateTime.now().add(Duration(days: 1)),
      estado: 'Confirmada',
    ),
    Consulta(
      responsavelId: '3',
      pacienteId: '3',
      dataHorario: DateTime.now().add(Duration(days: 2)),
      estado: 'Realizada',
    ),
    Consulta(
      responsavelId: '4',
      pacienteId: '4',
      dataHorario: DateTime.now().add(Duration(days: 3)),
      estado: 'Cancelada',
    ),
    Consulta(
      responsavelId: '5',
      pacienteId: '5',
      dataHorario: DateTime.now().add(Duration(days: 4)),
      estado: 'Agendada',
    ),
    Consulta(
      responsavelId: '6',
      pacienteId: '6',
      dataHorario: DateTime.now().add(Duration(days: 5)),
      estado: 'Confirmada',
    ),
    Consulta(
      responsavelId: '',
      pacienteId: '',
      dataHorario: DateTime(9999),
      estado: '',
    ),
    Consulta(
      responsavelId: '8',
      pacienteId: '8',
      dataHorario: DateTime.now().add(Duration(days: 7)),
      estado: 'Cancelada',
    ),
    Consulta(
      responsavelId: '9',
      pacienteId: '9',
      dataHorario: DateTime.now().add(Duration(days: 8)),
      estado: 'Agendada',
    ),
    Consulta(
      responsavelId: '10',
      pacienteId: '10',
      dataHorario: DateTime.now().add(Duration(days: 9)),
      estado: 'Confirmada',
    ),
  ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Pacientes Cadastrados"),
      ),
      // O RefreshIndicator é um widget que implementa um indicador de atualização. 
      // Ao se fazer o gesto de 'puxar para baixo', a função onRefresh é chamada e a lista é atualizada.
      body: RefreshIndicator(
        onRefresh: _refreshPacientes,
        // O ListView.builder é um widget que implementa uma lista de widgets filhos, onde os itens são construídos a partir de uma lista de dados.
        child: ListaSemIconeAcolher(listaObjeto: pacientes)
      ),
    );
  }
}