import 'package:acolherconsultas/modules/pacientes/controllers/pacienteCadastradoController.dart';
import 'package:acolherconsultas/modules/pacientes/models/pacienteCadastro.dart';
import 'package:acolherconsultas/modules/usuarios/views/usuarioCadastro.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:acolherconsultas/shared/components/list/listaSemIcone.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';

// A classe PacienteListaScreen é a tela que exibe a lista de pacientes cadastrados.
class PacienteListaScreen extends StatefulWidget {
  const PacienteListaScreen({super.key});

  @override
  State<PacienteListaScreen> createState() => _PacienteListaScreenState();
}

// A classe _PacienteListaScreenState é a classe que representa o estado da tela de lista de pacientes cadastrados.
class _PacienteListaScreenState extends State<PacienteListaScreen> {

  // O método initState é chamado quando o estado do widget é inserido na árvore de widgets.
  // Isto é, assim que a tela é construída/chamada.
  @override
  void initState() {
    super.initState();
    context.read<PacientesCadastradosController>().getPacientes();
  }

  // O método _refreshPacientes é responsável por atualizar a lista de pacientes cadastrados.
  Future<void> _refreshPacientes() async {
    await context.read<PacientesCadastradosController>().getPacientes();
  }

  // O método build é responsável por construir a interface da tela de lista de pacientes cadastrados.
  @override
  Widget build(BuildContext context) {
    List<CadastroPaciente> pacientes = Provider.of<PacientesCadastradosController>(context).pacientes;
    return Scaffold(
      appBar: const PageAppBar(titulo: "Cadastros",),
      // O RefreshIndicator é um widget que implementa um indicador de atualização. 
      // Ao se fazer o gesto de 'puxar para baixo', a função onRefresh é chamada e a lista é atualizada.
      body: RefreshIndicator(
        onRefresh: _refreshPacientes,
        // O ListView.builder é um widget que implementa uma lista de widgets filhos, onde os itens são construídos a partir de uma lista de dados.
        child: ListaSemIconeAcolher(listaObjeto: pacientes)
      ),
      floatingActionButton: StandartRoundButton(
        icon: Icons.add_box_outlined, 
        text: "Novo cadastro",
        onPressed: () {
          pushWithoutNavBar(
            context,
            MaterialPageRoute(
              builder: (context) => const CadastroUsuarioScreen()
            )
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}