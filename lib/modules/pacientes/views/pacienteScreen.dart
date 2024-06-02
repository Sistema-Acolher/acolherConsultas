import 'package:acolherconsultas/modules/pacientes/controllers/pacienteCadastradoController.dart';
import 'package:acolherconsultas/modules/pacientes/states/pacienteCadastroState.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:acolherconsultas/shared/components/inputs/inputCaixaDeTexto.dart';
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
  bool _isEdited = false;

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

  void _checkIfEdited() {
    if (widget.paciente == null) return;

    setState(() {
      _isEdited = widget.state.nome.text != widget.paciente!.nome ||
          widget.state.cpf.text != widget.paciente!.cpf ||
          widget.state.rg.text != widget.paciente!.rg ||
          widget.state.genero.text != widget.paciente!.genero ||
          widget.state.numeroCartaoSus.text !=
              widget.paciente!.numeroCartaoSus ||
          widget.state.dataNascimento.text !=
              (widget.paciente?.dataNasc != null
                  ? DateFormat('dd/MM/yyyy').format(widget.paciente!.dataNasc!)
                  : '') ||
          widget.state.motivoAcolhimento.text !=
              widget.paciente!.motivoAcolhimento;
      //  widget.state.acolhimentoAnterior.text !=
      // widget.paciente!.acolhimentoAnterior;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.paciente == null) {
      return const Center(child: Text("Nenhum paciente selecionado."));
    }

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildInputTextoEditar(
                context, "Nome", widget.state.nome, widget.paciente!.nome),
            _buildInputTextoEditar(
                context, "CPF", widget.state.cpf, widget.paciente?.cpf ?? ''),
            _buildInputTextoEditar(
                context, "RG", widget.state.rg, widget.paciente?.rg ?? ''),
            _buildDataEditar(
                context,
                "Data de Nascimento",
                widget.state.dataNascimento,
                widget.paciente?.dataNasc != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(widget.paciente?.dataNasc ?? DateTime.now())
                    : ''),
            _buildInputTextoEditar(context, "Gênero", widget.state.genero,
                widget.paciente!.genero),
            _buildInputTextoEditar(
                context,
                "Número do Cartão SUS",
                widget.state.numeroCartaoSus,
                widget.paciente?.numeroCartaoSus ?? ''),
            _buildEditavelMotivoDoAcolhimento(
                context,
                "Motivo do Acolhimento",
                widget.state.motivoAcolhimento,
                widget.paciente!.motivoAcolhimento),
            _buildInputTextoEditar(
                context,
                "Acolhimento Anterior",
                widget.state.acolhimentoAnterior,
                widget.paciente?.acolhimentoAnterior ?? ''),
          ],
        ),
        if (_isEdited)
          Positioned(
            bottom: 16,
            right: 16,
            child: StandartRoundButton(
              text: "Salvar",
              onPressed: () async {
                await context
                    .read<PacientesCadastradosController>()
                    .atualizaPaciente(
                        widget.state.cadastro(),
                        widget.paciente!.id ?? "",
                        widget.paciente!.casaDeApoioId);
              },
              icon: Icons.save,
            ),
          ),
      ],
    );
  }

  Widget _buildInputTextoEditar(BuildContext context, String label,
      TextEditingController state, String defaultValue) {
    bool isEditable = false;

    if (_isEdited) {
      state.text = state.text;
    } else {
      state.text = defaultValue;
    }

    if (label == "Acolhimento Anterior") {
      return InputRadioButtonsCadastroPaciente(
        label: label,
        controller: state,
        options: const ["Sim", "Não"],
        isChecked: ValueNotifier(false),
      );
    }

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
                _checkIfEdited();
              }),
        );
      },
    );
  }

  Widget _buildEditavelMotivoDoAcolhimento(BuildContext context, String label,
      TextEditingController state, String defaultValue) {
    state.text = defaultValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputCaixaDeTexto(
        label: label,
        controller: state,
        editable: true,
      ),
    );
  }

  Widget _buildDataEditar(BuildContext context, String label,
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
