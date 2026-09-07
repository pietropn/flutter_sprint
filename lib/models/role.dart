/// Papel do usuário autenticado, usado para decidir qual variação de
/// Home/Dashboard exibir (conforme protótipos "Home Gestor" e
/// "Dashboard de acompanhamento" do Professor).
///
/// Observação: a API do projeto (desenvolvida por outra equipe) ainda não
/// expõe um endpoint de autenticação com papéis de usuário, então o papel
/// é escolhido localmente na tela de login e persistido no SharedPreferences
/// junto ao perfil do usuário.
enum Role { gestor, professor }

extension RoleX on Role {
  String get label => this == Role.gestor ? 'Gestor' : 'Professor';

  static Role fromString(String? value) {
    if (value == 'professor') return Role.professor;
    return Role.gestor;
  }

  String get asString => this == Role.gestor ? 'gestor' : 'professor';
}
