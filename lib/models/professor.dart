/// Modelo de Professor, conforme os campos das telas "Cadastro Professor"
/// do protótipo. Persistido localmente (SharedPreferences), já que a API
/// do projeto ainda não expõe um endpoint de professores.
class Professor {
  final String id;
  final String nomeCompleto;
  final String cpf;
  final String estado;
  final String cidade;
  final String cep;
  final String numero;
  final String email;
  final String telefone;
  final String dataNascimento;
  final String raca;
  final String genero;
  final String rg;
  final String statusProfessor;
  final String unidade;
  final String contrato;

  const Professor({
    required this.id,
    required this.nomeCompleto,
    this.cpf = '',
    this.estado = '',
    this.cidade = '',
    this.cep = '',
    this.numero = '',
    this.email = '',
    this.telefone = '',
    this.dataNascimento = '',
    this.raca = '',
    this.genero = '',
    this.rg = '',
    this.statusProfessor = 'Ativo',
    this.unidade = '',
    this.contrato = '',
  });

  factory Professor.fromMap(Map<String, dynamic> m) => Professor(
        id: m['id']?.toString() ?? '',
        nomeCompleto: m['nomeCompleto'] ?? '',
        cpf: m['cpf'] ?? '',
        estado: m['estado'] ?? '',
        cidade: m['cidade'] ?? '',
        cep: m['cep'] ?? '',
        numero: m['numero'] ?? '',
        email: m['email'] ?? '',
        telefone: m['telefone'] ?? '',
        dataNascimento: m['dataNascimento'] ?? '',
        raca: m['raca'] ?? '',
        genero: m['genero'] ?? '',
        rg: m['rg'] ?? '',
        statusProfessor: m['statusProfessor'] ?? 'Ativo',
        unidade: m['unidade'] ?? '',
        contrato: m['contrato'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nomeCompleto': nomeCompleto,
        'cpf': cpf,
        'estado': estado,
        'cidade': cidade,
        'cep': cep,
        'numero': numero,
        'email': email,
        'telefone': telefone,
        'dataNascimento': dataNascimento,
        'raca': raca,
        'genero': genero,
        'rg': rg,
        'statusProfessor': statusProfessor,
        'unidade': unidade,
        'contrato': contrato,
      };
}
