import 'package:acolherconsultas/modules/pacientes/controllers/pacienteCadastradoController.dart';
import 'package:acolherconsultas/modules/pacientes/states/pacienteCadastroState.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtons.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask/mask/mask.dart';
import 'package:provider/provider.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteObservacoes.dart';
import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/bars/tabBar.dart';
import 'package:acolherconsultas/shared/components/buttons/bigRoundButton.dart';

class PacienteScreen extends StatelessWidget {
  final _stateCadastroPaciente = CadastroPacienteState();
  final Paciente paciente;
  PacienteScreen({super.key, required this.paciente});

  @override
  Widget build(BuildContext context) {
    var usuario = context.read<UsuarioController>().usuarioAtual;
    return CustomTabBar(
      appBar: PacienteAppbar(paciente: paciente),
      fabs_: usuario?.nivelAcesso == NivelAcesso.casaDeApoio
          ? [
              BigRoundButton(
                text: "Observações",
                icon: Icons.comment_outlined,
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PacienteObservacoes(paciente: paciente))),
              ),
              BigRoundButton(
                text: "Observações",
                icon: Icons.comment_outlined,
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PacienteObservacoes(paciente: paciente))),
              ),
            ]
          : null,
      tabs_: const [
        "Informações\n\t\t\tPessoais",
        "\t\tHistória\nPregressa",
      ],
      views_: [
        InfoPessoais(paciente: paciente, state: _stateCadastroPaciente),
        const HistPregressa(),
      ],
    );
  }
}

class InfoPessoais extends StatefulWidget {
  final Paciente? paciente;
  final CadastroPacienteState state;
  const InfoPessoais({super.key, this.paciente, required this.state});

  @override
  State<InfoPessoais> createState() => _InfoPessoaisState();
}

class _InfoPessoaisState extends State<InfoPessoais> {
  @override
  void initState() {
    super.initState();

    widget.state.dataNascimento.addListener(() {
      atualizaControllerIdade();
    });
  }

  void atualizaControllerIdade() {
    if (widget.state.dataNascimento.text.length == 10) {
      DateTime data =
          DateFormat('dd/MM/yyyy').parse(widget.state.dataNascimento.text);
      String dataString = Paciente.calcularIdade(data);
      widget.state.idade.text = dataString;
    } else {
      widget.state.idade.text = "";
    }
  }

  Widget build(BuildContext context) {
    if (widget.paciente == null) {
      return const Center(child: Text("Nenhum paciente selecionado."));
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildEditableTextField(
            context, "Nome", widget.state.nome, widget.paciente!.nome),
        _buildEditableTextField(
            context, "CPF", widget.state.cpf, widget.paciente?.cpf ?? ''),
        _buildEditableTextField(
            context, "RG", widget.state.rg, widget.paciente?.rg ?? ''),
        _buildEditableDateTextField(
            context,
            "Data de Nascimento",
            widget.state.dataNascimento,
            widget.paciente?.dataNasc != null
                ? DateFormat('dd/MM/yyyy')
                    .format(widget.paciente?.dataNasc ?? DateTime.now())
                : ''),
        _buildEditableTextField(
            context, "Gênero", widget.state.genero, widget.paciente!.genero),
        _buildEditableTextField(
            context,
            "Número do Cartão SUS",
            widget.state.numeroCartaoSus,
            widget.paciente?.numeroCartaoSus ?? ''),
        _buildEditableTextField(context, "Motivo do Acolhimento",
            widget.state.motivoAcolhimento, widget.paciente!.motivoAcolhimento),
        _buildEditableTextField(
            context,
            "Acolhimento Anterior",
            widget.state.acolhimentoAnterior,
            widget.paciente?.acolhimentoAnterior ?? ''),
      ],
    );
  }

  Widget _buildEditableTextField(BuildContext context, String label,
      TextEditingController state, String defaultValue) {
    bool isEditable = false;

    if (label == "Acolhimento Anterior") {
      return InputRadioButtonsCadastroPaciente(
        label: label,
        controller: state,
        options: const ["Sim", "Não"],
        isChecked: ValueNotifier(false),
      );
    }
    state.text = defaultValue;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InputTextoAcolher(
              label: label,
              controller: state,
              icone: Icons.edit,
              readOnly: !isEditable,
              emptyMessage: 'Informe o $label por favor.',
              checkEdit: () async {
                await context
                    .read<PacientesCadastradosController>()
                    .atualizaPaciente(
                        widget.state.cadastro(),
                        widget.paciente!.id ?? "",
                        widget.paciente!.casaDeApoioId);
              }),
        );
      },
    );
  }

  Widget _buildEditableDateTextField(BuildContext context, String label,
      TextEditingController state, String defaultValue) {
    state.text = defaultValue;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InputTextoAcolher(
                  label: label,
                  controller: state,
                  keyboardType: TextInputType.datetime,
                  icone: Icons.date_range_outlined,
                  validation: (value) => Mask.validations.date(value),
                  inputFormatter: [Mask.date()],
                  readOnly: true,
                  emptyMessage: 'Informe o $label por favor.',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InputTextoAcolher(
                  label: "Idade",
                  placeHolder: "..a ..m ..d",
                  controller: widget.state.idade,
                  readOnly: true,
                  emptyMessage: "Informe a idade",
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class HistPregressa extends StatefulWidget {
  const HistPregressa({super.key});

  @override
  State<HistPregressa> createState() => _HistPregressaState();
}

class _HistPregressaState extends State<HistPregressa> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("História Pregressa"));
  }
}
