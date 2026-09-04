# Euro Tech! - App Exemplo (Flutter)

README para execução do projeto entregue como exemplo de avaliação:
- arquitetura organizada (models/services/pages/widgets)
- formulários com validação e tratamento de erros
- persistência local (SharedPreferences + Hive)

---

## Tecnologias utilizadas

- Flutter (SDK / Dart)
- Provider (gerenciamento de estado)
- Shared Preferences (shared_preferences) — manter usuário logado
- Hive + hive_flutter (persistência local simples / cache)
- path_provider (para diretórios locais do dispositivo)
- uuid (gerar IDs para entidades locais)
- intl (formatos de data/locale, se necessário)

Dependências (exemplo do pubspec.yaml):
- provider
- shared_preferences
- hive
- hive_flutter
- path_provider
- uuid
- intl

---

## Versão do Flutter (recomendada)

Este projeto foi desenvolvido e testado com:
- Flutter 3.10.x (Dart 2.19+)

Você pode usar qualquer versão estável do Flutter 3.x. Para verificar sua versão instalada:
```bash
flutter --version