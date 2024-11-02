import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:flutter/material.dart';

class ListaComIcone extends StatelessWidget {
  const ListaComIcone({
    super.key,
    required this.listaElementos,
    required this.onEdit
  });
  
  final List<dynamic> listaElementos;
  final Function onEdit;

  @override
  Widget build(BuildContext context) {
    if (listaElementos.isNotEmpty) {
      return Column(
        children: [
          for (int i = 0; i < listaElementos.length; i++)
            _buildListItem(listaElementos[i]),
        ],
      );
    }
    return const SizedBox.shrink();
  }
  Widget _buildListItem(dynamic item) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: Text(
            item.nome,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "Montserrat"
            ),
          )),
          item is Usuario ? Text(
            item.nivelAcesso.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontFamily: "Montserrat"
            ),
          ) : const SizedBox(),
          Container(
            width: 2,
            height: 30,
            color: preto,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          IconButton(
            visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity),
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.edit_outlined,
              size: 28,
              color: preto,
            ),
            onPressed: () => onEdit(item),
          )
        ],
      ),
    );
  }
}
