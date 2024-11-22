import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/inputs/inputCaixaDeTexto.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtons.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';

class ConsultaRelatorioInstituicao extends StatelessWidget {
  final ConsultaCadastro consultaCadastro;
  final bool eInstituicao;

  const ConsultaRelatorioInstituicao({
    super.key,
    required this.consultaCadastro,
    required this.eInstituicao,
  });

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
            onPressed: () => Navigator.pop(context)
          ),
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
                controller: TextEditingController(
                    text: consultaCadastro.pacienteNome ?? ''),
                readOnly: eInstituicao,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Horário",
                      controller: TextEditingController(
                        text:
                            TimeOfDay.fromDateTime(consultaCadastro.dataHorario)
                                .format(context),
                      ),
                      readOnly: eInstituicao,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Data",
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy')
                            .format(consultaCadastro.dataHorario),
                      ),
                      readOnly: eInstituicao,
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
                      controller: TextEditingController(
                          text:
                              consultaCadastro.dadosConsulta?.peso.toString() ??
                                  ''),
                      readOnly: eInstituicao,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Estatura",
                      controller: TextEditingController(
                        text: consultaCadastro
                                .dadosConsulta?.comprimentoPorIdade
                                .toString() ??
                            '',
                      ),
                      readOnly: eInstituicao,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "IMC",
                      controller: TextEditingController(
                        text: consultaCadastro.dadosConsulta?.imcPorIdade
                                .toString() ??
                            '',
                      ),
                      readOnly: eInstituicao,
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
                        text: consultaCadastro.dadosConsulta?.imcPorIdade !=
                                'Eutrofia'
                            ? "Adequado"
                            : "Inadequado",
                      ),
                      options: const ["Adequado", "Inadequado"],
                      isChecked: isChecked,
                      readOnly: eInstituicao,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Freq.cardíaca",
                      controller: TextEditingController(
                        text: consultaCadastro.dadosConsulta?.frequenciaCardiaca
                                .toString() ??
                            '',
                      ),
                      readOnly: eInstituicao,
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
                      controller: TextEditingController(
                        text: consultaCadastro.dadosConsulta?.temperatura
                                .toString() ??
                            '',
                      ),
                      readOnly: eInstituicao,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Saturação",
                      controller: TextEditingController(
                        text: consultaCadastro.dadosConsulta?.saturacao
                                .toString() ??
                            '',
                      ),
                      readOnly: eInstituicao,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Pressão arterial",
                      controller: TextEditingController(
                        text: consultaCadastro.dadosConsulta?.pressaoArterial
                                .toString() ??
                            '',
                      ),
                      readOnly: eInstituicao,
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
                      controller: TextEditingController(
                        text: consultaCadastro.dadosConsulta?.auscultaPulmonar
                                .toString() ??
                            '',
                      ),
                      readOnly: eInstituicao,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Ausculta cardíaca",
                      controller: TextEditingController(
                        text: consultaCadastro.dadosConsulta?.auscultaCardiaca
                                .toString() ??
                            '',
                      ),
                      readOnly: eInstituicao,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Orofaringe",
                      controller: TextEditingController(
                        text: consultaCadastro.dadosConsulta?.orofaringe
                                .toString() ??
                            '',
                      ),
                      readOnly: eInstituicao,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InputCaixaDeTexto(
                label: 'Análise Geral',
                controller: TextEditingController(
                  text:
                      consultaCadastro.dadosConsulta?.analiseGeral.toString() ??
                          '',
                ),
                editable: false,
              ),
              const SizedBox(height: 16),
              InputCaixaDeTexto(
                label: 'Exame físico',
                controller: TextEditingController(
                  text: consultaCadastro.dadosConsulta?.exameFisicoCasa
                          .toString() ??
                      '',
                ),
                editable: false,
              ),
              const SizedBox(height: 16),
              InputCaixaDeTexto(
                label: 'Avaliações',
                controller: TextEditingController(
                  text: consultaCadastro.dadosConsulta?.avaliacoes.toString() ??
                      '',
                ),
                editable: false,
              ),
              const SizedBox(height: 16),
              InputCaixaDeTexto(
                label: 'Orientações - Cuidador',
                controller: TextEditingController(
                  text: consultaCadastro.dadosConsulta?.oriParaCuidador
                          .toString() ??
                      '',
                ),
                editable: false,
              ),
              const SizedBox(height: 16),
              InputCaixaDeTexto(
                label: 'Orientações - Crianças/Adolescntes',
                controller: TextEditingController(
                  text: consultaCadastro.dadosConsulta?.oriParaPaciente
                          .toString() ??
                      '',
                ),
                editable: false,
              ),
              const SizedBox(height: 16),
              InputCaixaDeTexto(
                label: 'Orientações - Coordenação da casa',
                controller: TextEditingController(
                  text: consultaCadastro.dadosConsulta?.oriParaCoordenacao
                          .toString() ??
                      '',
                ),
                editable: false,
              ),
              const SizedBox(height: 16),
              InputTextoAcolher(
                label: "Assinatura",
                controller: TextEditingController(
                  text: consultaCadastro.dadosConsulta?.cuidadorPrincipal
                      .toString(),
                ),
                readOnly: eInstituicao,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
