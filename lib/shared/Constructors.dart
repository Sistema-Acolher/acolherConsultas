import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';

final Paciente pacienteTeste = Paciente(
  nome: 'João Silva',
  ativo: true,
  cpf: '123.456.789-00',
  rg: '1234567',
  numeroCartaoSus: '123456789012345',
  dataNasc: DateTime(1980, 5, 15),
  genero: 'Masculino',
  motivoAcolhimento: 'Dor de cabeça persistente',
  acolhimentoAnterior: 'Tratamento de resfriado',
  orientacoes: 'Repouso e hidratação',
  encaminhamentos: 'Agendar consulta com neurologista',
  casaDeApoioId: 'abc123',
);