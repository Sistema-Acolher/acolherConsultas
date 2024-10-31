import 'package:acolherconsultas/modules/pacientes/controllers/pacienteController.dart';
import 'package:acolherconsultas/modules/pacientes/states/pacienteState.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:acolherconsultas/shared/components/dropdown/inputDropdown.dart';
import 'package:acolherconsultas/shared/components/inputs/inputCaixaDeTexto.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtons.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask/mask/mask.dart';
import 'package:material_symbols_icons/symbols.dart';
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
        HistPregressa(
          paciente: paciente,
          cadastroPacienteState: _stateCadastroPaciente,
        ),
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
  bool campoEditado = false;

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
      String dataString = PacientesController.calcularIdade(data);
      widget.state.idade.text = dataString;
    } else {
      widget.state.idade.text = "";
    }
  }

  void checkCampoEditado() {
    if (widget.paciente == null) return;

    setState(() {
      campoEditado = widget.state.nome.text != widget.paciente!.nome ||
          widget.state.cpf.text != widget.paciente!.cpf ||
          widget.state.rg.text != widget.paciente!.rg ||
          widget.state.sexo.text != widget.paciente!.sexo ||
          widget.state.numeroCartaoSus.text !=
              widget.paciente!.numeroCartaoSus ||
          widget.state.dataNascimento.text !=
              (widget.paciente?.dataNasc != null
                  ? DateFormat('dd/MM/yyyy').format(widget.paciente!.dataNasc)
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
                context,
                "Nome",
                widget.state.nome,
                widget.paciente!.nome,
                (value) => Mask.validations
                    .generic(value, error: "Nome inválido", min: 3)),
            _buildInputTextoEditar(
              context,
              "CPF",
              widget.state.cpf,
              widget.paciente?.cpf ?? '',
              (value) => Mask.validations.cpf(value),
            ),
            _buildInputTextoEditar(
                context,
                "RG",
                widget.state.rg,
                widget.paciente?.rg ?? '',
                (value) => Mask.validations
                    .generic(value, error: "RG inválido", min: 8)),
            _buildDataEditar(
                context,
                "Data de Nascimento",
                widget.state.dataNascimento,
                widget.paciente?.dataNasc != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(widget.paciente?.dataNasc ?? DateTime.now())
                    : ''),
            _buildSexoEditar(
                context, "Sexo", widget.state.sexo, widget.paciente!.sexo),
            _buildInputTextoEditar(
                context,
                "Número do Cartão SUS",
                widget.state.numeroCartaoSus,
                widget.paciente?.numeroCartaoSus ?? '',
                (value) => Mask.validations.generic(value,
                    error: "Número do Cartão do SUS inválido", min: 18)),
            _buildMotivoDoAcolhimentoEditar(
                context,
                "Motivo do Acolhimento",
                widget.state.motivoAcolhimento,
                widget.paciente!.motivoAcolhimento),
            _buildInputTextoEditar(
                context,
                "Acolhimento Anterior",
                widget.state.localAcolhimentoAnterior,
                widget.paciente?.localAcolhimentoAnterior ?? '',
                () => {}),
          ],
        ),
        if (campoEditado)
          Positioned(
            bottom: 16,
            right: 16,
            child: StandartRoundButton(
              text: "Salvar",
              onPressed: () async {
                await context.read<PacientesController>().atualizaPaciente(
                    widget.state.cadastro(),
                    widget.paciente!.id ?? "",
                    widget.paciente!.casaDeApoioId);
              },
              icon: Symbols.book,
            ),
          ),
      ],
    );
  }

  Widget _buildInputTextoEditar(BuildContext context, String label,
      TextEditingController state, String defaultValue, Function validation) {
    bool isEditable = false;

    if (campoEditado) {
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
              validation: validation,
              readOnly: !isEditable,
              emptyMessage: 'Informe o $label por favor.',
              checkEdit: () async {
                checkCampoEditado();
              }),
        );
      },
    );
  }

  Widget _buildMotivoDoAcolhimentoEditar(BuildContext context, String label,
      TextEditingController state, String defaultValue) {
    if (campoEditado) {
      state.text = state.text;
    } else {
      state.text = defaultValue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputCaixaDeTexto(
        label: label,
        controller: state,
        editable: true,
        checkEdit: () async {
          checkCampoEditado();
        },
      ),
    );
  }

  Widget _buildSexoEditar(BuildContext context, String label,
      TextEditingController state, String defaultValue) {
    ValueNotifier<bool> dropdownNotifier = ValueNotifier<bool>(false);
    if (!['Masculino', 'Feminino', 'Prefiro não responder']
        .contains(state.text)) {
      state.text = '';
    }

    if (campoEditado) {
      state.text = state.text;
    } else {
      state.text = defaultValue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDropdown(
        label: 'Sexo',
        list: const ['Masculino', 'Feminino'],
        controller: state,
        checkNotifier: dropdownNotifier,
        isEdit: true,
        checkEdit: () async {
          checkCampoEditado();
        },
      ),
    );
  }

  Widget _buildDataEditar(BuildContext context, String label,
      TextEditingController state, String defaultValue) {
    if (campoEditado) {
      state.text = state.text;
    } else {
      state.text = defaultValue;
    }

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
                  checkEdit: () async {
                    checkCampoEditado();
                  },
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
  final Paciente? paciente;
  final CadastroPacienteState cadastroPacienteState;

  const HistPregressa(
      {super.key, this.paciente, required this.cadastroPacienteState});

  @override
  State<HistPregressa> createState() => _HistoriaPregressaState();
}

class _HistoriaPregressaState extends State<HistPregressa> {
  bool campoEditado = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildInputTextoEditar(
                context,
                "Peso ao Nascer",
                widget.cadastroPacienteState.historiaPregressa.pesoNasc,
                widget.paciente?.historiaPregressa?.pesoNasc ?? '',
                (value) => Mask.validations
                    .generic(value, error: "Peso inválido", min: 1)),
            _buildInputTextoEditar(
                context,
                "Estatura",
                widget.cadastroPacienteState.historiaPregressa.estatura,
                widget.paciente?.historiaPregressa?.estatura ?? '',
                (value) => Mask.validations
                    .generic(value, error: "Estatura inválido", min: 1)),
            _buildInputTextoEditar(
                context,
                "PC",
                widget.cadastroPacienteState.historiaPregressa.pc,
                widget.paciente?.historiaPregressa?.pc ?? '',
                (value) => Mask.validations
                    .generic(value, error: "PC inválido", min: 1)),
            _buildInputTextoEditar(
                context,
                "PT",
                widget.cadastroPacienteState.historiaPregressa.pt,
                widget.paciente?.historiaPregressa?.pt ?? '',
                (value) => Mask.validations
                    .generic(value, error: "PT inválido", min: 1)),
            _buildInputTextoEditar(
                context,
                "Teste da Apgar",
                widget.cadastroPacienteState.historiaPregressa.ictericia,
                widget.paciente?.historiaPregressa?.ictericia ?? '',
                (value) => Mask.validations
                    .generic(value, error: "Teste da Apgar inválido", min: 1)),
            _buildInputTextoEditar(
                context,
                "Icterícia",
                widget.cadastroPacienteState.historiaPregressa.testeApgar,
                widget.paciente?.historiaPregressa?.testeApgar ?? '',
                (value) => Mask.validations
                    .generic(value, error: "Icterícia inválido", min: 1)),
            _buildInputTextoEditar(
                context,
                "Teste de Orelhinha",
                widget.cadastroPacienteState.historiaPregressa.testeOrelhinha,
                widget.paciente?.historiaPregressa?.testeOrelhinha ?? '',
                (value) => Mask.validations.generic(value,
                    error: "Teste de orelhinha inválido", min: 1)),
            _buildInputTextoEditar(
                context,
                "Teste do Pezinho",
                widget.cadastroPacienteState.historiaPregressa.testePezinho,
                widget.paciente?.historiaPregressa?.testePezinho ?? '',
                (value) => Mask.validations.generic(value,
                    error: "Teste do Pezinho inválido", min: 1)),
            _buildInputTextoEditar(
                context,
                "RN",
                widget.cadastroPacienteState.historiaPregressa.rn,
                widget.paciente?.historiaPregressa?.rn ?? '',
                () => {}),
            _buildInputTextoEditar(
                context,
                "Intercorrência",
                widget.cadastroPacienteState.historiaPregressa.intercorrencia,
                widget.paciente?.historiaPregressa?.intercorrencia ?? '',
                () => {}),
          ],
        ),
        if (campoEditado)
          Positioned(
            bottom: 16,
            right: 16,
            child: StandartRoundButton(
              text: "Salvar",
              onPressed: () async {
                await context.read<PacientesController>().atualizaPaciente(
                    widget.cadastroPacienteState.cadastro(),
                    widget.paciente!.id ?? "",
                    widget.paciente!.casaDeApoioId);
              },
              icon: Symbols.book,
            ),
          ),
      ],
    );
  }

  void checkCampoEditado() {
    setState(() {
      campoEditado = (widget
                  .cadastroPacienteState.historiaPregressa.pesoNasc.text !=
              widget.paciente?.historiaPregressa?.pesoNasc) ||
          (widget.cadastroPacienteState.historiaPregressa.estatura.text !=
              widget.paciente?.historiaPregressa?.estatura) ||
          (widget.cadastroPacienteState.historiaPregressa.pc.text !=
              widget.paciente?.historiaPregressa?.pc) ||
          (widget.cadastroPacienteState.historiaPregressa.pt.text !=
              widget.paciente?.historiaPregressa?.pt) ||
          (widget.cadastroPacienteState.historiaPregressa.testeApgar.text !=
              widget.paciente?.historiaPregressa?.testeApgar) ||
          (widget.cadastroPacienteState.historiaPregressa.testeOrelhinha.text !=
              widget.paciente?.historiaPregressa?.testeOrelhinha) ||
          (widget.cadastroPacienteState.historiaPregressa.testePezinho.text !=
              widget.paciente?.historiaPregressa?.testePezinho) ||
          (widget.cadastroPacienteState.historiaPregressa.rn.text !=
              widget.paciente?.historiaPregressa?.rn) ||
          (widget.cadastroPacienteState.historiaPregressa.intercorrencia.text !=
              widget.paciente?.historiaPregressa?.intercorrencia);
    });
  }

  Widget _buildInputTextoEditar(BuildContext context, String label,
      TextEditingController state, String defaultValue, Function validation) {
    bool isEditable = false;

    if (campoEditado) {
      state.text = state.text;
    } else {
      state.text = defaultValue;
    }

    if (label == "Intercorrência") {
      return InputRadioButtonsCadastroPaciente(
        label: label,
        controller: state,
        options: const ["Sim", "Não"],
        isChecked: ValueNotifier(false),
      );
    }

    if (label == "Icterícia") {
      return InputRadioButtonsCadastroPaciente(
        label: label,
        controller: state,
        options: const ["Ausente", "Presente"],
        isChecked: ValueNotifier(false),
      );
    }

    if (label == "RN") {
      return InputRadioButtonsCadastroPaciente(
        label: label,
        controller: state,
        options: const ["Pré-termo", "Termo", "Pós-termo"],
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
              validation: validation,
              readOnly: !isEditable,
              emptyMessage: 'Informe o $label por favor.',
              checkEdit: () async {
                checkCampoEditado();
              }),
        );
      },
    );
  }
}
