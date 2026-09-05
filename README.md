# ## 📋 Funcionalidades e Critérios Atendidos
### 💾 Persistência Local e Configuração (10 Pontos)
Implementado centralizadamente em [`lib/services/preferences_service.dart`](lib/services/preferences_service.dart):
1. **Manter Usuário Logado**: Token de acesso e dados do perfil salvos no `SharedPreferences`. O app realiza auto-login na inicialização e descarta os dados no logout.
2. **Salvar Configurações**: URL da API personalizável e persistida através da tela de configurações.
3. **Armazenar Preferências**: Alternância entre **Tema Escuro (Dark Mode)** e **Tema Claro**, além do preenchimento automático do e-mail de login ("Lembrar e-mail").
4. **Cache Simples de Dados**: Os dados retornados da API (`/alunos`) são gravados localmente. Em caso de falha de conexão ou rede offline, o aplicativo continua funcional apresentando os dados do cache com indicação visual de "Modo Offline".
### 🔗 Integração com API REST
- Consumo dos endpoints REST da entidade `/alunos` (GET, POST, DELETE).
- Validação frontend completa espelhando o backend (CPF com 11 dígitos numéricos, e-mail válido e campos obrigatórios).
- Tratamento resiliente de falhas de comunicação (`SocketException`, timeouts e códigos de erro HTTP).
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
PARTICIPANTES:
- Pietro de Paula Nascimento (RM557000)
- Victor Andrade Baptista de Sousa (RM555902)
- Jhonatham Jesus de Souza Barros (RM559114)
- Silvio Toshiaki Yokoyama (RM556716)
```