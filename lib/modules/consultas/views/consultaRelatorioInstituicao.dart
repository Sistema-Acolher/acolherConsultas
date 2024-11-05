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
  final ConsultaCadastro dadosConsulta;
  final Consulta? relatorioPacienteConsulta;

  const ConsultaRelatorioInstituicao({
    super.key,
    required this.dadosConsulta,
    this.relatorioPacienteConsulta,
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
                    text: dadosConsulta.pacienteNome ?? ''),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Horário",
                      controller: TextEditingController(
                        text: TimeOfDay.fromDateTime(dadosConsulta.dataHorario)
                            .format(context),
                      ),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Data",
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy')
                            .format(dadosConsulta.dataHorario),
                      ),
                      readOnly: true,
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
                              relatorioPacienteConsulta?.peso.toString() ?? ''),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Estatura",
                      controller: TextEditingController(
                        text: relatorioPacienteConsulta?.comprimentoPorIdade
                                .toString() ??
                            '',
                      ),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "IMC",
                      controller: TextEditingController(
                        text:
                            relatorioPacienteConsulta?.imcPorIdade.toString() ??
                                '',
                      ),
                      readOnly: true,
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
                      options: const ["Adequado", "Inadequado"],
                      label: "Condição Geral",
                      controller: TextEditingController(
                        text: relatorioPacienteConsulta
                                ?.auscultaCardiaca //Falta o dado do adequado ou não
                                .toString() ??
                            '',
                      ),
                      isChecked: isChecked,
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Freq.cardíaca",
                      controller: TextEditingController(
                        text: relatorioPacienteConsulta
                                ?.auscultaCardiaca //Falta o dado da frequencia cardiaca
                                .toString() ??
                            '',
                      ),
                      readOnly: true,
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
                        text:
                            relatorioPacienteConsulta?.temperatura.toString() ??
                                '',
                      ),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Saturação",
                      controller: TextEditingController(
                        text: relatorioPacienteConsulta?.saturacao.toString() ??
                            '',
                      ),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Pressão arterial",
                      controller: TextEditingController(
                        text: relatorioPacienteConsulta?.saturacao.toString() ??
                            '', //Falta o dado da pressão arterial
                      ),
                      readOnly: true,
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
                        text: relatorioPacienteConsulta?.auscultaPulmonar
                                .toString() ??
                            '',
                      ),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Ausculta cardíaca",
                      controller: TextEditingController(
                        text: relatorioPacienteConsulta?.auscultaCardiaca
                                .toString() ??
                            '',
                      ),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputTextoAcolher(
                      label: "Orofaringe",
                      controller: TextEditingController(
                        text:
                            relatorioPacienteConsulta?.orofaringe.toString() ??
                                '',
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InputCaixaDeTexto(
                label: 'Análise Geral',
                controller: TextEditingController(
                  text:
                      relatorioPacienteConsulta?.analiseGeral.toString() ?? '',
                ),
                editable: false,
              ),
              const SizedBox(height: 16),
              InputCaixaDeTexto(
                label: 'Exame físico',
                controller: TextEditingController(
                  text: relatorioPacienteConsulta?.analiseGeral.toString() ??
                      '', //Falta o dado do exame fisico
                ),
                editable: false,
              ),
              const SizedBox(height: 16),
              InputCaixaDeTexto(
                label: 'Avaliações',
                controller: TextEditingController(
                  text: relatorioPacienteConsulta?.avaliacoes.toString() ?? '',
                ),
                editable: false,
              ),
              const SizedBox(height: 16),
              InputCaixaDeTexto(
                label: 'Orientações - Cuidador',
                controller: TextEditingController(
                  text:
                      relatorioPacienteConsulta?.cuidadorPrincipal.toString() ??
                          '', //Falta o dado da orientação
                ),
                editable: false,
              ),
              const SizedBox(height: 16),
              InputCaixaDeTexto(
                label: 'Orientações - Crianças/Adolescntes',
                controller: TextEditingController(
                  text:
                      relatorioPacienteConsulta?.cuidadorPrincipal.toString() ??
                          '', //Falta o dado da orientação
                ),
                editable: false,
              ),
              const SizedBox(height: 16),
              InputCaixaDeTexto(
                label: 'Orientações - Coordenação da casa',
                controller: TextEditingController(
                  text:
                      relatorioPacienteConsulta?.cuidadorPrincipal.toString() ??
                          '', //Falta o dado da orientação
                ),
                editable: false,
              ),
              const SizedBox(height: 16),
              InputTextoAcolher(
                label: "Assinatura",
                controller: TextEditingController(
                  text: dadosConsulta.pacienteNome
                      .toString(), //falta a assinatura
                ),
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
