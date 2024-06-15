import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/dropdown/casasDropdown.dart';
import 'package:flutter/material.dart';

class PacienteAppbar extends StatefulWidget implements PreferredSizeWidget {
  final Paciente? paciente;
  final bool admin;
  final bool perfil;

  const PacienteAppbar(
      {super.key, this.paciente, this.admin = false, this.perfil = false});

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
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black)),
      title: !widget.admin
          ? Text(
              widget.paciente != null ? widget.paciente!.nome : "Novo Cadastro",
              style: const TextStyle(
                  fontSize: 30,
                  fontFamily: "BobbyJonesSoft",
                  color: Colors.black),
            )
          : null,
      actions: [
        if (widget.admin)
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CasaItem(
              text: "Admin",
              color: 0xFF7A7A7A,
              reverse: true,
            ),
          ),
        if (widget.perfil == true)
          Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            children: [
              const Text(
                'Ativo',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Checkbox(
                activeColor: preto,
                value: widget.paciente?.ativo,
                onChanged: (value) {
                  setState(() {
                    widget.paciente!.ativo = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
