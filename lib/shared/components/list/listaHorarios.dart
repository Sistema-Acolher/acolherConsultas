import 'package:acolherconsultas/modules/consultas/controllers/consultaController.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/components/text/confirmacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; 
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'; 

class ListaHorario extends StatefulWidget {
  final DateTime? dia;
  final List<ConsultaCadastro> consultasDoDia;
  final Function(ConsultaCadastro p)? onSelect;
  final Paciente? paciente;
  final ConsultaCadastro? consulta;
  final bool fundo;

  const ListaHorario({
    super.key, required this.consultasDoDia, this.paciente, this.dia, this.fundo =false, this.consulta, this.onSelect
  });

  @override
  State<ListaHorario> createState() => _ListaHorarioState();
}

class _ListaHorarioState extends State<ListaHorario> {
  final consultaController = ConsultaController();

  List<Widget> data(List<CadastroPaciente> pacientes) {
    List<DateTime> horarios = [];
    int consultaAtual=0;
    
    DateTime dataBase = widget.dia ?? DateTime.now();
    for (var i = 7; i < 18; i++) {
      horarios.add(DateTime(dataBase.year, dataBase.month, dataBase.day, i));
    }
    
    List<Widget> list = [];
    for (var item in horarios) {
      ConsultaCadastro? p;
      if (widget.consultasDoDia.isNotEmpty && consultaAtual<widget.consultasDoDia.length && widget.consultasDoDia[consultaAtual].dataHorario.hour==item.hour) {
        p=widget.consultasDoDia[consultaAtual];
        consultaAtual++;
      } else {
        p=null;
      }
      
      if(p != null && p.pacienteNome != null){
        List<String> parts = p.pacienteNome!.split(' ');
        if (parts.length > 1) {
          p.pacienteNome = '${parts[0]} ${parts[1]}';
        }
      }
      
      list.add(Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque, 
            onTap: () { 
              DateTime hoje = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
              DateTime diaSelecionado = widget.dia != null ? DateTime(widget.dia!.year, widget.dia!.month, widget.dia!.day) : hoje;

              if (widget.onSelect==null && p==null && widget.paciente!=null && widget.dia!=null && (diaSelecionado.isAfter(hoje) || diaSelecionado.isAtSameMomentAs(hoje))) {
                _dialogBuilder(context, widget.paciente?.nome ?? "", item);
              }
              else if(widget.onSelect!=null && p!=null){ 
                widget.onSelect!(p);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6), // Mais espaço para o clique do dedo
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    p==null ? "Vago" : p.estado=="concluida" ? "${p.pacienteNome ?? 'Sem Nome'} (Feita)" : (p.pacienteNome ?? 'Sem Nome'),
                    style: TextStyle(color: p==null?const Color(0xFF0AEC57):p.estado=="concluida"?Colors.blue:Colors.black,fontFamily: "MontSerrat",fontSize: 20)
                  ),
                  Text(
                    DateFormat.Hm().format(item),
                    style: const TextStyle(fontFamily: "MontSerrat",fontSize: 20, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
          item!=horarios.last?const Divider(height: 2,color: Colors.black,):const SizedBox.shrink()
        ],
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    widget.consultasDoDia.sort((a,b)=>a.dataHorario.compareTo(b.dataHorario));
    return Container(
      decoration: BoxDecoration(
        color: widget.fundo?Colors.white:null,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: data(Provider.of<List<CadastroPaciente>>(context))
      ),
    );
  }

  // FUNÇÃO AUXILIAR PARA O SNACKBAR DINÂMICO
  void _showCustomSnackbar(ScaffoldMessengerState messenger, bool isOffline, String acao) {
       final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: isOffline ? 'Salvo Localmente' : 'Sucesso',
            message: isOffline ? 'Sem internet. O $acao foi agendado no aparelho e será sincronizado.' : '$acao realizado com sucesso!',
            contentType: isOffline ? ContentType.warning : ContentType.success,
          ),
          duration: const Duration(seconds: 6),
        );
        messenger..hideCurrentSnackBar()..showSnackBar(snackBar);
  }

  Future<void> _dialogBuilder(BuildContext context, String pacienteNome, DateTime horario) {
    if(widget.dia !=null){
      horario = DateTime(widget.dia!.year, widget.dia!.month, widget.dia!.day, horario.hour, horario.minute);
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(top: 10,left: 10,right: 10),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          content: Confirmacao(nome: pacienteNome, dataHorario: horario, confimacao: () async {
            
            var statusConexao = context.read<List<ConnectivityResult>>();
            bool isOffline = statusConexao.contains(ConnectivityResult.none);
            
            // SALVAMOS O MENSAGEIRO ANTES DE FECHAR AS TELAS
            final messenger = ScaffoldMessenger.of(context);

            if (isOffline) {
              // 🛑 LÓGICA OFFLINE (Sem await, apenas um clique)
              if (widget.consulta != null) {
                consultaController.reagendar(horario, widget.consulta!);
                Navigator.pop(context); // 1. Fecha o Alert de Confirmação
                Navigator.pop(context); // 2. Fecha a tabela de horários
                Navigator.pop(context); // 3. Fecha a tela de detalhes do paciente
                _showCustomSnackbar(messenger, isOffline, "Reagendamento");
              } else {
                consultaController.cadastrarConsulta(widget.paciente!, horario);
                Navigator.pop(context); // 1. Fecha o Alert de Confirmação
                Navigator.pop(context); // 2. Fecha a tabela de horários
                _showCustomSnackbar(messenger, isOffline, "Agendamento");
              }
            } else {
              // ✅ LÓGICA ONLINE (Espera o servidor e fecha)
              if (widget.consulta != null) {
                await consultaController.reagendar(horario, widget.consulta!).then((value){
                  Navigator.pop(context);
                  _showCustomSnackbar(messenger, isOffline, "Reagendamento");
                  if (!value.toLowerCase().contains("erro")) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                });
              } else {
                await consultaController.cadastrarConsulta(widget.paciente!, horario).then((value){
                  Navigator.pop(context);
                  _showCustomSnackbar(messenger, isOffline, "Agendamento");
                  if (!value.toLowerCase().contains("erro")) {
                    Navigator.pop(context);
                  }
                });
              }
            }
          })
        );
      },
    );
  }
}