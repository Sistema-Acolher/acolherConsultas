import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:flutter/material.dart';

class PacienteAppbar extends StatefulWidget implements PreferredSizeWidget {
  const PacienteAppbar({super.key, this.paciente});

  final Paciente? paciente;
  
  @override
  State<PacienteAppbar> createState() => _PacienteAppbar();
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PacienteAppbar extends State<PacienteAppbar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: amareloNavbar,
      toolbarHeight: 60,
      centerTitle: true,
      leading: IconButton(
        onPressed:() {
          Navigator.of(context, rootNavigator: true).pop();
        }, 
        icon: const Icon(Icons.arrow_back,color: Colors.black)
      ),
      title: Text(
        widget.paciente!=null?widget.paciente!.nome:"Novo Cadastro",
        style: const TextStyle(
          fontSize: 30,
          fontFamily: "BobbyJonesSoft",
          color: Colors.black
        ),
      ),
    );
  }
}
