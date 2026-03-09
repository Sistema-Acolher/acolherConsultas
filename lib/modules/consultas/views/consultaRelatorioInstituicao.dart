import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/buttons/bigRoundButton.dart';
import 'package:acolherconsultas/shared/components/inputs/inputCaixaDeTexto.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtons.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/state/consultaState.dart';
import 'package:acolherconsultas/modules/consultas/controllers/consultaController.dart';

class ConsultaRelatorioInstituicao extends StatefulWidget {
  final ConsultaCadastro consultaCadastro;
  final bool eInstituicao;

  const ConsultaRelatorioInstituicao({
    super.key,
    required this.consultaCadastro,
    required this.eInstituicao,
  });

  @override
  State<ConsultaRelatorioInstituicao> createState() =>
      _ConsultaRelatorioInstituicaoState();
}

class _ConsultaRelatorioInstituicaoState
    extends State<ConsultaRelatorioInstituicao> {
  late TextEditingController _pacienteNomeController;
  late TextEditingController _horarioController;
  late TextEditingController _dataController;
  late TextEditingController _pesoController;
  late TextEditingController _estaturaController;
  late TextEditingController _imcController;
  late TextEditingController _frequenciaCardiacaController;
  late TextEditingController _temperaturaController;
  late TextEditingController _saturacaoController;
  late TextEditingController _pressaoArterialController;
  late TextEditingController _auscultaPulmonarController;
  late TextEditingController _auscultaCardiacaController;
  late TextEditingController _orofaringeController;
  late TextEditingController _analiseGeralController;
  late TextEditingController _exameFisicoController;
  late TextEditingController _avaliacoesController;
  late TextEditingController _oriCuidadorController;
  late TextEditingController _oriPacienteController;
  late TextEditingController _oriCoordenacaoController;
  late TextEditingController _assinaturaController;
  late TextEditingController _condicaoGeralController;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initializeControllers();
      _initialized = true;
    }
  }

  void _initializeControllers() {
    _pacienteNomeController =
        TextEditingController(text: widget.consultaCadastro.pacienteNome);
    _horarioController = TextEditingController(
      text: TimeOfDay.fromDateTime(widget.consultaCadastro.dataHorario)
          .format(context),
    );
    _dataController = TextEditingController(
      text:
          DateFormat('dd/MM/yyyy').format(widget.consultaCadastro.dataHorario),
    );
    _pesoController = TextEditingController(
      text: widget.consultaCadastro.dadosConsulta?.peso.toString() ?? '',
    );
    _estaturaController = TextEditingController(
        text: widget.consultaCadastro.dadosConsulta?.comprimentoPorIdade
                .toString() ??
            '');
    _imcController = TextEditingController(
        text: widget.consultaCadastro.dadosConsulta?.imcPorIdade.toString() ??
            '');
    _frequenciaCardiacaController = TextEditingController(
        text: widget.consultaCadastro.dadosConsulta?.frequenciaCardiaca
                .toString() ??
            '');
    _temperaturaController = TextEditingController(
        text: widget.consultaCadastro.dadosConsulta?.temperatura.toString() ??
            '');
    _saturacaoController = TextEditingController(
        text:
            widget.consultaCadastro.dadosConsulta?.saturacao.toString() ?? '');
    _pressaoArterialController = TextEditingController(
        text:
            widget.consultaCadastro.dadosConsulta?.pressaoArterial.toString() ??
                '');
    _auscultaPulmonarController = TextEditingController(
        text: widget.consultaCadastro.dadosConsulta?.auscultaPulmonar
                .toString() ??
            '');
    _auscultaCardiacaController = TextEditingController(
        text: widget.consultaCadastro.dadosConsulta?.auscultaCardiaca
                .toString() ??
            '');
    _orofaringeController = TextEditingController(
        text:
            widget.consultaCadastro.dadosConsulta?.orofaringe.toString() ?? '');
    _analiseGeralController = TextEditingController(
        text: widget.consultaCadastro.dadosConsulta?.analiseGeral.toString() ??
            '');
    _exameFisicoController = TextEditingController(
        text: widget.consultaCadastro.dadosConsulta?.exameFisicoCasa
                ?.toString() ??
            '');
    _avaliacoesController = TextEditingController(
        text:
            widget.consultaCadastro.dadosConsulta?.avaliacoes.toString() ?? '');
    _oriCuidadorController = TextEditingController(
        text: widget.consultaCadastro.dadosConsulta?.oriParaCuidador
                ?.toString() ??
            '');
    _oriPacienteController = TextEditingController(
        text: widget.consultaCadastro.dadosConsulta?.oriParaPaciente
                ?.toString() ??
            '');
    _oriCoordenacaoController = TextEditingController(
        text: widget.consultaCadastro.dadosConsulta?.oriParaCoordenacao
                ?.toString() ??
            '');
    _assinaturaController = TextEditingController(
        text: widget.consultaCadastro.dadosConsulta?.cuidadorPrincipal
                .toString() ??
            '');
    _condicaoGeralController = TextEditingController(
      text: widget.consultaCadastro.dadosConsulta?.imcPorIdade != 'Eutrofia'
          ? "Adequado"
          : "Inadequado",
    );
  }

  @override
  void dispose() {
    _pacienteNomeController.dispose();
    _horarioController.dispose();
    _dataController.dispose();
    _pesoController.dispose();
    _estaturaController.dispose();
    _imcController.dispose();
    _frequenciaCardiacaController.dispose();
    _temperaturaController.dispose();
    _saturacaoController.dispose();
    _pressaoArterialController.dispose();
    _auscultaPulmonarController.dispose();
    _auscultaCardiacaController.dispose();
    _orofaringeController.dispose();
    _analiseGeralController.dispose();
    _exameFisicoController.dispose();
    _avaliacoesController.dispose();
    _oriCuidadorController.dispose();
    _oriPacienteController.dispose();
    _oriCoordenacaoController.dispose();
    _assinaturaController.dispose();
    _condicaoGeralController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      widget.consultaCadastro.pacienteNome = _pacienteNomeController.text;
      widget.consultaCadastro.dataHorario = DateFormat('dd/MM/yyyy HH:mm')
          .parse("${_dataController.text} ${_horarioController.text}");
      widget.consultaCadastro.dadosConsulta?.peso =
          double.tryParse(_pesoController.text) ?? 0.0;
      widget.consultaCadastro.dadosConsulta?.comprimentoPorIdade =
          _estaturaController.text;
      widget.consultaCadastro.dadosConsulta?.imcPorIdade = _imcController.text;
      widget.consultaCadastro.dadosConsulta?.frequenciaCardiaca =
          _frequenciaCardiacaController.text;
      widget.consultaCadastro.dadosConsulta?.temperatura =
          double.tryParse(_temperaturaController.text) ?? 0.0;
      widget.consultaCadastro.dadosConsulta?.saturacao =
          _saturacaoController.text;
      widget.consultaCadastro.dadosConsulta?.pressaoArterial =
          _pressaoArterialController.text;
      widget.consultaCadastro.dadosConsulta?.auscultaPulmonar =
          _auscultaPulmonarController.text;
      widget.consultaCadastro.dadosConsulta?.auscultaCardiaca =
          _auscultaCardiacaController.text;
      widget.consultaCadastro.dadosConsulta?.orofaringe =
          _orofaringeController.text;
      widget.consultaCadastro.dadosConsulta?.analiseGeral =
          _analiseGeralController.text;
      widget.consultaCadastro.dadosConsulta?.exameFisicoCasa =
          _exameFisicoController.text;
      widget.consultaCadastro.dadosConsulta?.avaliacoes =
          _avaliacoesController.text;
      widget.consultaCadastro.dadosConsulta?.oriParaCuidador =
          _oriCuidadorController.text;
      widget.consultaCadastro.dadosConsulta?.oriParaPaciente =
          _oriPacienteController.text;
      widget.consultaCadastro.dadosConsulta?.oriParaCoordenacao =
          _oriCoordenacaoController.text;
      widget.consultaCadastro.dadosConsulta?.cuidadorPrincipal =
          _assinaturaController.text;
      widget.consultaCadastro.dadosConsulta?.imcPorIdade =
          _condicaoGeralController.text;

      await ConsultaController().atualizarConsulta(
          widget.consultaCadastro, widget.consultaCadastro.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consulta atualizada com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar as alterações.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isChecked = ValueNotifier(false);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: PageAppBar(
            titulo: "Relatório",
            casaDeApoioSelecionada: Provider.of<CasaDeApoio>(context),
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context)),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputTextoAcolher(
                  label: "Nome da Criança",
                  controller: _pacienteNomeController,
                  icone: !widget.eInstituicao ? Icons.edit : null,
                  readOnly: widget.eInstituicao,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InputTextoAcolher(
                        label: "Horário",
                        controller: _horarioController,
                        icone: !widget.eInstituicao ? Icons.edit : null,
                        readOnly: widget.eInstituicao,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputTextoAcolher(
                        label: "Data",
                        controller: _dataController,
                        icone: !widget.eInstituicao ? Icons.edit : null,
                        readOnly: widget.eInstituicao,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InputTextoAcolher(
                        label: "Peso",
                        controller: _pesoController,
                        icone: !widget.eInstituicao ? Icons.edit : null,
                        readOnly: widget.eInstituicao,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputTextoAcolher(
                        label: "Estatura",
                        controller: _estaturaController,
                        icone: !widget.eInstituicao ? Icons.edit : null,
                        readOnly: widget.eInstituicao,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputTextoAcolher(
                        label: "IMC",
                        controller: _imcController,
                        icone: !widget.eInstituicao ? Icons.edit : null,
                        readOnly: widget.eInstituicao,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InputRadioButtonsCadastroPaciente(
                        label: "Condição Geral",
                        controller: TextEditingController(
                          text: widget.consultaCadastro.dadosConsulta
                                      ?.imcPorIdade !=
                                  'Eutrofia'
                              ? "Adequado"
                              : "Inadequado",
                        ),
                        options: const ["Adequado", "Inadequado"],
                        isChecked: isChecked,
                        readOnly: widget.eInstituicao,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputTextoAcolher(
                        label: "Freq.cardíaca",
                        controller: _frequenciaCardiacaController,
                        icone: !widget.eInstituicao ? Icons.edit : null,
                        readOnly: widget.eInstituicao,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InputTextoAcolher(
                        label: "Temperatura",
                        controller: _temperaturaController,
                        icone: !widget.eInstituicao ? Icons.edit : null,
                        readOnly: widget.eInstituicao,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputTextoAcolher(
                        label: "Saturação",
                        controller: _saturacaoController,
                        icone: !widget.eInstituicao ? Icons.edit : null,
                        readOnly: widget.eInstituicao,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputTextoAcolher(
                        label: "Pressão arterial",
                        controller: _pressaoArterialController,
                        icone: !widget.eInstituicao ? Icons.edit : null,
                        readOnly: widget.eInstituicao,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InputTextoAcolher(
                        label: "Ausculta pulmonar",
                        controller: _auscultaPulmonarController,
                        icone: !widget.eInstituicao ? Icons.edit : null,
                        readOnly: widget.eInstituicao,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputTextoAcolher(
                        label: "Ausculta cardíaca",
                        controller: _auscultaCardiacaController,
                        icone: !widget.eInstituicao ? Icons.edit : null,
                        readOnly: widget.eInstituicao,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputTextoAcolher(
                        label: "Orofaringe",
                        controller: _orofaringeController,
                        icone: !widget.eInstituicao ? Icons.edit : null,
                        readOnly: widget.eInstituicao,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                InputCaixaDeTexto(
                  label: 'Análise Geral',
                  controller: _analiseGeralController,
                  editable: widget.eInstituicao ? false : true,
                ),
                const SizedBox(height: 16),
                InputCaixaDeTexto(
                  label: 'Exame físico',
                  controller: _exameFisicoController,
                  editable: widget.eInstituicao ? false : true,
                ),
                const SizedBox(height: 16),
                InputCaixaDeTexto(
                  label: 'Avaliações',
                  controller: _avaliacoesController,
                  editable: widget.eInstituicao ? false : true,
                ),
                const SizedBox(height: 16),
                InputCaixaDeTexto(
                  label: 'Orientações - Cuidador',
                  controller: _oriCuidadorController,
                  editable: widget.eInstituicao ? false : true,
                ),
                const SizedBox(height: 16),
                InputCaixaDeTexto(
                  label: 'Orientações - Crianças/Adolescntes',
                  controller: _oriPacienteController,
                  editable: widget.eInstituicao ? false : true,
                ),
                const SizedBox(height: 16),
                InputCaixaDeTexto(
                  label: 'Orientações - Coordenação da casa',
                  controller: _oriCuidadorController,
                  editable: widget.eInstituicao ? false : true,
                ),
                const SizedBox(height: 16),
                InputTextoAcolher(
                  label: "Assinatura",
                  controller: _assinaturaController,
                  icone: !widget.eInstituicao ? Icons.edit : null,
                  readOnly: widget.eInstituicao,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: !widget.eInstituicao
            ? BigRoundButton(
                text: "Atualizar Relatório",
                icon: Icons.send,
                onPressed: _saveChanges,
              )
            : null);
  }
}
