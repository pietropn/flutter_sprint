# Euro Tech! — App de Gestão de Alunos (Flutter)

Sprint do Diogo (terceira entrega).

## 🛠️ Tecnologias utilizadas

- **Flutter** (Dart SDK `^3.11.5` — recomendado Flutter 3.35 ou superior, canal `stable`)
- **provider** `^6.0.5` — gerenciamento de estado (`ChangeNotifier`)
- **http** `^1.5.0` — cliente HTTP para consumo da API REST
- **shared_preferences** `^2.3.2` — persistência local (sessão, tema, preferências e cache)
- **uuid** `^3.0.6` — geração de identificadores únicos

## 🔗 Integração com API REST

Este aplicativo consome uma **API REST desenvolvida em Spring Boot por outra equipe/disciplina** (projeto de microsserviço, endpoint `/alunos`), e não uma API pública de terceiros. A URL base é configurável dentro do próprio app (tela de Configurações), permitindo apontar para diferentes ambientes (local, rede, produção) sem precisar recompilar.

Funcionalidades cobertas:

- Consumo dos endpoints REST da entidade `/alunos` (`GET`, `POST`, `DELETE`).
- Validação no frontend espelhando as regras do backend (CPF com 11 dígitos numéricos, e-mail válido, campos obrigatórios).
- Tratamento resiliente de falhas de comunicação (`SocketException`, timeouts e códigos de erro HTTP), com fallback para os dados em cache local quando a API está indisponível.

## 💾 Persistência Local e Configuração (10 Pontos)

Implementado centralizadamente em [`lib/services/preferences_service.dart`](lib/services/preferences_service.dart), usando `SharedPreferences`:

1. **Manter Usuário Logado**: Token de acesso e dados do perfil salvos localmente. O app realiza auto-login na inicialização e descarta os dados no logout.
2. **Salvar Configurações**: URL da API personalizável e persistida através da tela de configurações.
3. **Armazenar Preferências**: Alternância entre **Tema Escuro (Dark Mode)** e **Tema Claro**, além do preenchimento automático do e-mail de login ("Lembrar e-mail").
4. **Cache Simples de Dados**: Os dados retornados da API (`/alunos`) são gravados localmente. Em caso de falha de conexão ou rede offline, o aplicativo continua funcional apresentando os dados do cache com indicação visual de "Modo Offline".

---

## 📂 Estrutura de Pastas do Projeto

```text
lib/
├── app.dart                          # Configuração do MaterialApp, temas e rotas
├── main.dart                         # Ponto de entrada, inicialização do SharedPreferences
├── routes.dart                       # Mapeamento de rotas nomeadas
├── models/                           # Modelos de dados com serialização JSON e mapeamento API
│   ├── student.dart                  # Entidade Aluno (nome, cpf, email, turma)
│   └── user.dart                     # Entidade Usuário autenticado
├── pages/                            # Interfaces de usuário (Telas)
│   ├── home/home_page.dart           # Dashboard principal com status de cache e sessão
│   ├── login/login_page.dart         # Tela de autenticação com opção "Lembrar e-mail"
│   ├── settings/settings_page.dart   # Tela de configurações (URL da API, Tema, Cache)
│   └── students/
│       ├── student_form_page.dart    # Formulário de cadastro com validação de CPF e dados
│       └── students_list_page.dart   # Listagem com pull-to-refresh e aviso de cache offline
├── providers/                        # Gerenciamento de estado (ChangeNotifier)
│   ├── auth_provider.dart            # Estado da sessão e credenciais
│   ├── student_provider.dart         # Estado da lista de alunos e sincronização com cache
│   └── theme_provider.dart           # Estado do tema claro/escuro persistido
├── repositories/                     # Camada de abstração de dados (API + Cache local)
│   ├── auth_repository.dart          # Repositório de autenticação e sessão
│   └── student_repository.dart       # Repositório de alunos com suporte a fallback offline
├── services/                         # Serviços de infraestrutura
│   ├── api_service.dart              # Cliente HTTP com URL dinâmica e tratamento de erros
│   └── preferences_service.dart      # Gerenciador de persistência SharedPreferences
├── utils/                            # Constantes e funções utilitárias
│   ├── constants.dart                # Chaves de armazenamento e URLs padrão
│   └── validators.dart               # Validadores de CPF, e-mail e campos obrigatórios
└── widgets/                          # Componentes de interface reutilizáveis
    ├── custom_text_field.dart        # Campo de texto padronizado com validação
    ├── loading_overlay.dart          # Indicador visual de carregamento
    └── primary_button.dart           # Botão principal de ação
```

---

## ▶️ Instalação e Execução

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (canal `stable`, versão compatível com Dart `^3.11.5`). Verifique com:
  ```bash
  flutter --version
  ```
- Um emulador Android/iOS em execução, um navegador (para rodar no Chrome) ou um dispositivo físico conectado.
- A API REST (`/alunos`) desenvolvida em Spring Boot em execução e acessível a partir do dispositivo/emulador escolhido.

### Passo a passo

1. Clone o repositório:
   ```bash
   git clone https://github.com/pietropn/flutter_sprint.git
   cd flutter_sprint
   ```
2. Instale as dependências:
   ```bash
   flutter pub get
   ```
3. Verifique se há algum dispositivo/emulador disponível:
   ```bash
   flutter devices
   ```
4. Execute o aplicativo:
   ```bash
   flutter run
   ```

### 🔧 Como configurar a URL da API

A URL da API **não é fixa no código** — ela é definida em tempo de execução e persistida via `SharedPreferences`. Existem duas formas de configurá-la:

1. **Pelo próprio app**: abra a tela **Configurações** (ícone de engrenagem na tela de Login ou no menu do app), informe a URL base da API (ex.: `http://10.0.2.2:8080` para emulador Android acessando `localhost` da máquina host, ou `http://192.168.x.x:8080` para dispositivo físico na mesma rede) e toque em salvar.
2. **Valor padrão**: caso nenhuma URL tenha sido configurada ainda, o app utiliza o valor definido em [`lib/utils/constants.dart`](lib/utils/constants.dart) (`AppConstants.defaultApiUrl`, atualmente `http://localhost:8080`). Edite essa constante caso queira alterar o padrão de fábrica antes de compilar.

> ⚠️ Atenção: emuladores Android **não enxergam `localhost` da máquina host diretamente** — use `10.0.2.2` no lugar de `localhost` nesse caso. iOS Simulator e Chrome (web) conseguem usar `localhost` normalmente.

---

## 👥 Participantes

- Pietro de Paula Nascimento (RM557000)
- Victor Andrade Baptista de Sousa (RM555902)
- Jhonatham Jesus de Souza Barros (RM559114)
- Silvio Toshiaki Yokoyama (RM556716)
