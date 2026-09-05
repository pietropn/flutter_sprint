# Euro Tech! - Sistema Educacional (Flutter)

Aplicativo Flutter integrado à API REST Spring Boot (`Sprint_microservico`) com persistência local completa via `SharedPreferences`.

---

## 🏆 Critério: Persistência Local e Configuração (10 pontos)

O projeto implementa todos os 4 exemplos solicitados de persistência local utilizando a biblioteca oficial `shared_preferences`:

| Funcionalidade | Implementação | Onde Encontrar |
|---|---|---|
| **1. Manter usuário logado** | Persiste o token de autenticação e os dados do usuário (`email`, `nome`). Ao abrir o app, a sessão é restaurada automaticamente via `AuthProvider` e o usuário vai direto para a `HomePage` sem precisar logar de novo. No logout, os dados são limpos. | [`PreferencesService.saveUserSession`](lib/services/preferences_service.dart), [`AuthProvider`](lib/providers/auth_provider.dart) |
| **2. Salvar configurações** | Permite alterar e salvar a URL base da API do Spring Boot (`baseUrl`) diretamente pelo app na tela de Configurações (`http://localhost:8080`, `http://10.0.2.2:8080`, etc.). A URL personalizada é mantida entre inicializações. | [`PreferencesService.getApiUrl / setApiUrl`](lib/services/preferences_service.dart), [`SettingsPage`](lib/pages/settings/settings_page.dart) |
| **3. Armazenar preferências** | Preferência de **Tema Escuro (Dark Mode) / Claro (Light Mode)** e opção **"Lembrar e-mail no login"** salvas e recuperadas no SharedPreferences. | [`ThemeProvider`](lib/providers/theme_provider.dart), [`LoginPage`](lib/pages/login/login_page.dart), [`SettingsPage`](lib/pages/settings/settings_page.dart) |
| **4. Cache simples de dados** | Cache local da lista de alunos. Ao carregar dados da API (`GET /alunos`), a lista é gravada em formato JSON no SharedPreferences. Se o app estiver offline ou a API estiver fora do ar, o app exibe imediatamente os alunos do cache local com indicação visual. | [`StudentRepository`](lib/repositories/student_repository.dart), [`StudentProvider`](lib/providers/student_provider.dart) |

---

## 🔌 Integração com a API (`Sprint_microservico`)

- **Endpoints**: Consome o endpoint `/alunos` (GET, POST, DELETE).
- **Validação de Modelo**: Alinhado com o DTO do backend Spring Boot (`nome`, `cpf` com 11 dígitos numéricos, `email` válido).
- **Tratamento de Erros**: Captura e trata `SocketException` (servidor offline), timeouts e erros de validação HTTP (400, 404, 500).

---

## 🚀 Como Executar

### 1. Iniciar a API Spring Boot (`Sprint_microservico`)
```bash
cd Sprint_microservico
./mvnw spring-boot:run
# API disponível em http://localhost:8080
```

### 2. Executar o Aplicativo Flutter
```bash
flutter pub get
flutter run
```

> **Dica para Emuladores/Dispositivos Físicos:**
> Abra a tela de **Configurações** (ícone de engrenagem no app) e selecione ou digite a URL da sua máquina (ex: `http://10.0.2.2:8080` para emulador Android padrão). A configuração será salva no SharedPreferences!

---

## 🧪 Executar Testes Unitários de Persistência

Para rodar os testes automatizados que validam a persistência local:
```bash
flutter test
```